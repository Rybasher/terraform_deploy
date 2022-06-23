data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "aws_ecs_cluster" "this" {
  count = var.ecs_cluster_name == "" ? 1 : 0
  name  = var.task_name
}
resource "aws_ecs_cluster" "existing" {
  count        = var.ecs_cluster_name != "" ? 1 : 0
  name         = var.ecs_cluster_name
}
locals {
  ecs_cluster_arn = var.ecs_cluster_name != "" ? aws_ecs_cluster.existing[0].arn : aws_ecs_cluster.this[0].arn
}


resource "aws_ecr_repository" "ecr-repo" {
  name = var.ecr_repo_name
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${var.task_name}-td" # Naming our first task
  container_definitions    = <<DEFINITION
  [
    {
      "name": "${var.task_name}-td",
      "image": "${aws_ecr_repository.ecr-repo.repository_url}",
      "essential": true,
      "memory": ${var.task_memory},
      "cpu": ${var.task_cpu},
      "environment": ${jsonencode(var.td-environment)},
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${var.task_name}-cloud-watch",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "ecs",
          "awslogs-create-group" : "true"
        }
      }
    }
  ]
  DEFINITION
  task_role_arn            = var.task_role_arn
  execution_role_arn       = local.ecs_task_execution_role_arn
  requires_compatibilities = ["FARGATE"] # Stating that we are using ECS Fargate
  network_mode             = "awsvpc"    # Using awsvpc as our network mode as this is required for Fargate
  memory                   = var.task_memory       # Specifying the memory our container requires
  cpu                      = var.task_cpu  # Specifying the CPU our container requires
}

resource "aws_cloudwatch_event_rule" "event_rule" {
  name                = "${var.task_name}-event-rule"
  schedule_expression = var.cloudwatch_schedule_expression
}

resource "aws_cloudwatch_event_target" "ecs_scheduled_task" {
  rule      = aws_cloudwatch_event_rule.event_rule.name
  target_id = var.task_name
  arn       = local.ecs_cluster_arn
  role_arn  = aws_iam_role.cloudwatch_role.arn

  ecs_target {
    launch_type         = "FARGATE"
    platform_version    = "LATEST"
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.this.arn
    network_configuration {
      subnets = var.subnet_ids
    }
  }
}

resource "aws_cloudwatch_event_rule" "task_failure" {
  name        = "${var.task_name}_task_failure"
  description = "Watch for ${var.task_name} tasks that exit with non zero exit codes"

  event_pattern = <<EOF
  {
    "source": [
      "aws.ecs"
    ],
    "detail-type": [
      "ECS Task State Change"
    ],
    "detail": {
      "lastStatus": [
        "STOPPED"
      ],
      "stoppedReason": [
        "Essential container in task exited"
      ],
      "containers": {
        "exitCode": [
          {"anything-but": 0}
        ]
      },
      "clusterArn": ["${local.ecs_cluster_arn}"],
      "taskDefinitionArn": ["${aws_ecs_task_definition.this.arn}"]
    }
  }
  EOF
}

resource "aws_sns_topic" "task_failure" {
  name = "${var.task_name}_task_failure"
}

resource "aws_cloudwatch_event_target" "sns_target" {
  rule  = aws_cloudwatch_event_rule.task_failure.name
  arn   = aws_sns_topic.task_failure.arn
  input = jsonencode({ "message" : "Task ${var.task_name} failed! Please check logs https://console.aws.amazon.com/cloudwatch/home#logsV2:log-groups/log-group/${var.task_name}" })
}

resource "aws_sns_topic_policy" "task_failure" {
  arn    = aws_sns_topic.task_failure.arn
  policy = data.aws_iam_policy_document.task_failure.json
}

locals {
  ecs_task_execution_role_arn  = var.ecs_task_execution_role_name != "" ? data.aws_iam_role.task_execution_role[0].arn : aws_iam_role.task_execution_role[0].arn
  ecs_task_execution_role_name = var.ecs_task_execution_role_name != "" ? data.aws_iam_role.task_execution_role[0].name : aws_iam_role.task_execution_role[0].name
}

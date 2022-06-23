terraform {
  required_version = ">= 1.0.2"
}


resource "aws_ecr_repository" "ecr-repo" {
  name                 = "${lower(var.name)}-cron-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}


resource "aws_ecs_cluster" "this" {
  count = 1
  name  = "${var.name}-cron-cluster"
}

resource "aws_ecs_task_definition" "ecs-task-definition" {
  family                   = "${title(terraform.workspace)}${var.name}ITD" # Naming our first task
  container_definitions    = <<DEFINITION
  [
    {
      "name": "${title(terraform.workspace)}${var.name}ITD",
      "image": "${aws_ecr_repository.ecr-repo.repository_url}",
      "essential": true,
      "portMappings": [
        {
          "containerPort": ${var.container-port},
          "hostPort": ${var.container-port}
        }
      ],
      "memory": ${var.container-memory},
      "cpu": ${var.container-cpu},
      "environment": ${jsonencode(var.td-env)},
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${var.name}ICloud-watch",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"] # Stating that we are using ECS Fargate
  network_mode             = "awsvpc"    # Using awsvpc as our network mode as this is required for Fargate
  memory                   = var.container-memory       # Specifying the memory our container requires
  cpu                      = var.container-cpu  # Specifying the CPU our container requires
  execution_role_arn       = "arn:aws:iam::166952552828:role/ecsTaskExecutionRole"
}

resource "aws_cloudwatch_log_group" "cloud_watch" {
  name = "${var.name}ICloud-watch"

  tags = {
    Environment = terraform.workspace
    Application = "${var.name}IService"
  }
}

resource "aws_cloudwatch_event_rule" "event_rule" {
  name                = var.task_name
  schedule_expression = var.cloudwatch_schedule_expression
}

resource "aws_cloudwatch_event_target" "ecs_scheduled_task" {
  rule      = aws_cloudwatch_event_rule.event_rule.name
  target_id = var.task_name
  arn       = aws_ecs_cluster.this[0].arn
  role_arn  = aws_iam_role.cloudwatch_role.arn

  ecs_target {
    launch_type         = "FARGATE"
    platform_version    = "LATEST"
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.ecs-task-definition.arn
    network_configuration {
      subnets = var.subnet_ids
    }
  }
}

data "aws_iam_policy_document" "cloudwatch_assume_role" {
  statement {
    principals {
      type = "Service"
      identifiers = [
        "events.amazonaws.com",
        "ecs-tasks.amazonaws.com",
      ]
    }
    actions = ["sts:AssumeRole"]
  }
}


resource "aws_iam_role" "cloudwatch_role" {
  name               = "${var.task_name}-cloudwatch-execution"
  assume_role_policy = data.aws_iam_policy_document.cloudwatch_assume_role.json
}
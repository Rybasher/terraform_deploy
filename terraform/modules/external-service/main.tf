terraform {
  required_version = ">= 1.0.2"
}

resource "aws_ecr_repository" "ecs-repo" {
  name                 = "${terraform.workspace}-${var.name}-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "main" {
  repository = aws_ecr_repository.ecs-repo.name

  policy = jsonencode({
   rules = [{
     rulePriority = 1
     description  = "keep last 5 images"
     action       = {
       type = "expire"
     }
     selection     = {
       tagStatus   = "any"
       countType   = "imageCountMoreThan"
       countNumber = 5
     }
   }]
  })
}

resource "aws_ecs_cluster" "ecs-cluster" {
  name = "${terraform.workspace}-${var.name}-cluster"
}

resource "aws_ecs_task_definition" "ecs-task-definition" {
  family                   = "${terraform.workspace}-${var.name}-td" # Naming our first task
  container_definitions    = <<DEFINITION
  [
    {
      "name": "${terraform.workspace}-${var.name}-td",
      "image": "${aws_ecr_repository.ecs-repo.repository_url}",
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
          "awslogs-group": "${terraform.workspace}-${var.name}-cloud-watch",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ]
  DEFINITION
  task_role_arn = ""
  requires_compatibilities = ["FARGATE"] # Stating that we are using ECS Fargate
  network_mode             = "awsvpc"    # Using awsvpc as our network mode as this is required for Fargate
  memory                   = var.container-memory       # Specifying the memory our container requires
  cpu                      = var.container-cpu  # Specifying the CPU our container requires
  execution_role_arn       = var.execution-role
}

resource "aws_cloudwatch_log_group" "cloud_watch" {
  name = "${terraform.workspace}-${var.name}-cloud-watch"

  tags = {
    Environment = terraform.workspace
    Application = "${terraform.workspace}-${var.name}-service"
  }
}


resource "aws_ecs_service" "ecs_service" {
  name            = "${terraform.workspace}-${var.name}-service"                        # Naming our first service
  cluster         = aws_ecs_cluster.ecs-cluster.id             # Referencing our created Cluster
  task_definition = aws_ecs_task_definition.ecs-task-definition.arn # Referencing the task our service will spin up
  launch_type     = "FARGATE"
  desired_count   = var.service-count # Setting the number of containers to 3

  load_balancer {
    target_group_arn = aws_lb_target_group.lb_target_group.arn # Referencing our target group
    container_name   = aws_ecs_task_definition.ecs-task-definition.family
    container_port   = var.container-port # Specifying the container port
  }

  network_configuration {
    subnets          = var.subnet_ids
    assign_public_ip = true                                                # Providing our containers with public IPs
    security_groups  = [aws_security_group.service_security_group.id] # Setting the security group
  }
}

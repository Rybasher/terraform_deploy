resource "aws_ecr_repository" "repo-indexer" {
  name                 = "prod-repo-indexer"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecs_cluster" "test-cluster" {
  name = "ClusterAPI"
}

#
#resource "aws_ecs_task_definition" "TaskDefinitionAPI" {
#  family                   = "TaskDefinitionAPI" # Naming our first task
#  container_definitions    = <<DEFINITION
#  [
#    {
#      "name": "TaskDefinitionAPI",
#      "image": "${aws_ecr_repository.repo-indexer.repository_url}",
#      "essential": true,
#      "portMappings": [
#        {
#          "containerPort": 3000,
#          "hostPort": 3000
#        }
#      ],
#      "memory": 2048,
#      "cpu": 512,
#      "environment": [
#        {"name": "PG_HOST", "value": "dbapi.coe5dqddfhv5.us-east-1.rds.amazonaws.com"},
#        {"name": "PG_USER", "value": "postgres"},
#        {"name": "PG_PASSWORD", "value": "VVe11C0me2$teakWa11et"},
#        {"name": "PG_DATABASE", "value": "postgres"}
#      ],
#      "logConfiguration": {
#        "logDriver": "awslogs",
#        "options": {
#          "awslogs-group": "${var.cloudwatch_group}",
#          "awslogs-region": "us-east-1",
#          "awslogs-stream-prefix": "ecs"
#        }
#      }
#    }
#  ]
#  DEFINITION
#  requires_compatibilities = ["FARGATE"] # Stating that we are using ECS Fargate
#  network_mode             = "awsvpc"    # Using awsvpc as our network mode as this is required for Fargate
#  memory                   = 2048         # Specifying the memory our container requires
#  cpu                      = 512         # Specifying the CPU our container requires
#  execution_role_arn       = "arn:aws:iam::595878128812:role/ecsTaskExecutionRole"
#}


#resource "aws_ecs_service" "my_first_service" {
#  name            = "ServiceAPI"                             # Naming our first service
#  cluster         = aws_ecs_cluster.test-cluster.id             # Referencing our created Cluster
#  task_definition = aws_ecs_task_definition.TaskDefinitionAPI.arn # Referencing the task our service will spin up
#  launch_type     = "FARGATE"
#  desired_count   = 3 # Setting the number of containers to 3
#
#  load_balancer {
#    target_group_arn = aws_lb_target_group.TargetGroupAPI.arn # Referencing our target group
#    container_name   = aws_ecs_task_definition.TaskDefinitionAPI.family
#    container_port   = 3000 # Specifying the container port
#  }
#
#  network_configuration {
#    subnets          = [aws_default_subnet.default_subnet_a.id, aws_default_subnet.default_subnet_b.id]
#    assign_public_ip = true                                                # Providing our containers with public IPs
#    security_groups  = [aws_security_group.service_security_group.id] # Setting the security group
#  }
#}
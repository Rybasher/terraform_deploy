#module "cron-test" {
#  source = "./modules/cron"
#  name = "api"
#  cloudwatch_schedule_expression = "cron(0/5 * * * ? *)"
#  container-cpu = 512
#  container-memory = 2048
#  container-port = 3000
#  subnet_ids = [aws_subnet.sw-subnet-public-a.id, aws_subnet.sw-subnet-public-b.id]
#  task_name = "scheduled_task"
#  td-env = var.td-environment
#}
#
#module "cron-test2" {
#  source = "./modules/cron2"
#  cloudwatch_schedule_expression = "cron(0/5 * * * ? *)"
#  ecr_repo_name                  = "${terraform.workspace}-cosmos-repo"
#  image_tag                      = "1.0.0"
#  subnet_ids                     = [aws_subnet.sw-subnet-public-a.id, aws_subnet.sw-subnet-public-b.id]
#  task_name                      = "${terraform.workspace}-cosmos-task"
#  ecs_cluster_name = "${terraform.workspace}-cosmos-cluster"
#  task_role_arn = aws_iam_role.ecs_task_role.arn
#  td-environment = var.td-environment
#}

module "api" {
  source = "./modules/external-service"
  name = "api-test"
  vpc_id = aws_vpc.sw-vpc.id
  subnet_ids = [aws_subnet.sw-subnet-public-a.id, aws_subnet.sw-subnet-public-b.id]
  container-cpu = 1024
  container-memory = 3072
  container-port = 3000
  service-count = 1
  td-env = var.td-environment
  execution-role = aws_iam_role.ecs_task_execution_role.arn
}
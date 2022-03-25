resource "aws_db_instance" "default" {
  identifier = var.db_identifier
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "13.4"
  instance_class       = "db.t3.micro"
  username             = "postgres"
  password             = "VVe11C0me2$teakWa11et"
  parameter_group_name = "default.postgres13"
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.load_balancer_security_group.id]
  availability_zone = aws_default_subnet.default_subnet_a.availability_zone
  publicly_accessible = true
}
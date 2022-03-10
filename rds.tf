#resource "aws_subnet" "private-subnet-3" {
#  vpc_id = aws_default_vpc.default_vpc.id
#  cidr_block = ""
#}
#
#resource "aws_db_subnet_group" "database-subnet-group" {
#  name = "database subnets"
#  subnet_ids = []
#  description = "Subnet for database instance"
#
#  tags = {
#    Name = "Database Subnets"
#  }
#}
#
#data "aws_db_snapshot" "latest-db-snapshot" {
#  db_snapshot_identifier = ""
#  most_recent = ""
#  snapshot_type = ""
#}



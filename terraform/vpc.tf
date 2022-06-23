resource "aws_vpc" "sw-vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true #gives you an internal domain name
    enable_dns_hostnames = true #gives you an internal host name
    enable_classiclink = false
    instance_tenancy = "default"
    tags = {
      Name = "SteakWalletVPC"
    }
}

resource "aws_subnet" "sw-subnet-public-a" {
  vpc_id = aws_vpc.sw-vpc.id
  cidr_block = "10.0.21.0/24"
  map_public_ip_on_launch = true //it makes this a public subnet
  availability_zone = "us-east-1a"
  tags = {
    Name = "sw-subnet-public-a"
  }
}

resource "aws_subnet" "sw-subnet-public-b" {
  vpc_id = aws_vpc.sw-vpc.id
  cidr_block = "10.0.31.0/24"
  map_public_ip_on_launch = true //it makes this a public subnet
  availability_zone = "us-east-1b"
  tags = {
    Name = "sw-subnet-public-b"
  }
}

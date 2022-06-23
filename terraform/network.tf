resource "aws_internet_gateway" "sw-igw" {
    vpc_id = aws_vpc.sw-vpc.id
    tags = {
      Name = "sw-igw"
    }
}

resource "aws_route_table" "sw-public-crt" {
    vpc_id = aws_vpc.sw-vpc.id
    route {
        //associated subnet can reach everywhere
        cidr_block = "0.0.0.0/0"
        //CRT uses this IGW to reach internet
        gateway_id = aws_internet_gateway.sw-igw.id
    }
    tags = {
        Name = "sw-public-crt"
    }
}


resource "aws_route_table_association" "sw-crta-public-subnet-a"{
    subnet_id = aws_subnet.sw-subnet-public-a.id
    route_table_id = aws_route_table.sw-public-crt.id
}

resource "aws_route_table_association" "sw-crta-public-subnet-b"{
    subnet_id = aws_subnet.sw-subnet-public-b.id
    route_table_id = aws_route_table.sw-public-crt.id
}
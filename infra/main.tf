variable "region" {
    default = "ap-northeast-2"
}
variable "env" {
    default = "test"
}

locals {

  publics = {
    "ap-northeast-2a" : "10.0.1.0/24",
    "ap-northeast-2b" : "10.0.2.0/24"
  }

  privates = {
    "ap-northeast-2a" : "10.0.101.0/24",
    "ap-northeast-2b" : "10.0.102.0/24"
  }
}

########################################### VPC ###########################################
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${var.env}-vpc"
  }
}

########################################### IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

########################################### Nat Gateway
resource "aws_eip" "eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id = lookup(aws_subnet.publics, "ap-northeast-2a").id

  tags = {
    Name = "nat-gateway"
  }
}

########################################### public subnet
resource "aws_subnet" "publics" {
  for_each = local.publics

  vpc_id            = aws_vpc.vpc.id
  availability_zone = each.key
  cidr_block        = each.value

  tags = {
    Name = "${var.env}-public-${each.key}"
  }
}

########################################### private subnet
resource "aws_subnet" "privates" {
  for_each = local.privates

  vpc_id            = aws_vpc.vpc.id
  availability_zone = each.key
  cidr_block        = each.value

  tags = {
    Name = "${var.env}-private-${each.key}"
  }
}

########################################### public route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.env}-public-igw"
  }
}

########################################### private route table 
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.env}-private-nat"
  }
}


########################################### public rt mapping
resource "aws_route_table_association" "public_association" {
  for_each = aws_subnet.publics

  subnet_id     = each.value.id
  route_table_id = aws_route_table.public_route_table.id
}

########################################### private rt mapping

resource "aws_route_table_association" "private_association" {
  for_each = aws_subnet.privates

  subnet_id = each.value.id
  route_table_id = aws_route_table.private_route_table.id
}

output "id" {
    value = aws_vpc.vpc.id
}

output "public_subnets" {
    value = {
        for subnet in aws_subnet.publics:
            subnet.availability_zone => subnet.id
    }
}

output "private_subnets" {
    value = {
        for subnet in aws_subnet.privates:
            subnet.availability_zone => subnet.id
    }
}

########################################### EC2 ###########################################
data "aws_ami" "amis" {
  most_recent = true
  owners = ["self"]
  
  filter {
    name = "name"
    values = ["grafana", "openvpn"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

output v {
  value = {
  for i, v in data.aws_ami.amis:
    i => v
  }
}
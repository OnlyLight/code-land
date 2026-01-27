# VPC
resource "aws_vpc" "this" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# Subnets
resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.aws_region}a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_app_a" {
  vpc_id     = aws_vpc.this.id
  cidr_block = "10.0.11.0/24"
  availability_zone = "${var.aws_region}a"
}

resource "aws_subnet" "private_db_a" {
  vpc_id     = aws_vpc.this.id
  cidr_block = "10.0.21.0/24"
  availability_zone = "${var.aws_region}a"
}

# IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_assoc" { # Route table
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

#POC VPC
resource "aws_vpc" "production-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.tag}_vpc"
    Environment = "${var.environment}"
  }
}

# Public subnet
resource "aws_subnet" "public-subnet-1" {
  vpc_id            = aws_vpc.production-vpc.id
  cidr_block        = var.public_subnet_1_cidr
  availability_zone = var.availability_zones[0]

  tags = {
    Name        = "${var.tag}-public-1"
    Environment = "${var.environment}"
  }
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id            = aws_vpc.production-vpc.id
  cidr_block        = var.public_subnet_2_cidr
  availability_zone = var.availability_zones[1]

  tags = {
    Name        = "${var.tag}-public-2"
    Environment = "${var.environment}"
  }
}
# Private Subnets
resource "aws_subnet" "private-subnet-1" {
  vpc_id            = aws_vpc.production-vpc.id
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = var.availability_zones[0]

  tags = {
    Name        = "${var.tag}-private-1"
    Environment = "${var.environment}"
  }
}

resource "aws_subnet" "private-subnet-2" {
  vpc_id            = aws_vpc.production-vpc.id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = var.availability_zones[1]

  tags = {
    Name        = "${var.tag}-private-2"
    Environment = "${var.environment}"
  }
}

#Route Table for private subnet
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.production-vpc.id

  tags = {
    Name        = "${var.tag}-public"
    Environment = "${var.environment}"
  }
}
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.production-vpc.id

  tags = {
    Name        = "${var.tag}-private"
    Environment = "${var.environment}"
  }
}

# Associate the newly created route tables to the subnets
resource "aws_route_table_association" "public-route-1-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public-subnet-1.id
}
resource "aws_route_table_association" "public-route-2-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public-subnet-2.id
}
resource "aws_route_table_association" "private-route-1-association" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.private-subnet-1.id
}
resource "aws_route_table_association" "private-route-2-association" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.private-subnet-2.id
}

#Internet Gateway for Public Network
resource "aws_internet_gateway" "production-igw" {
  vpc_id = aws_vpc.production-vpc.id

  tags = {
    Name        = "${var.tag}-igw"
    Environment = "${var.environment}"
  }
}

# Route the public subnet traffic through the Internet Gateway
resource "aws_route" "public-internet-igw-route" {
  route_table_id         = aws_route_table.public-route-table.id
  gateway_id             = aws_internet_gateway.production-igw.id
  destination_cidr_block = "0.0.0.0/0"
}
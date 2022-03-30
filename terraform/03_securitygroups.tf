# ALB Security Group (Traffic Internet -> ALB)
resource "aws_security_group" "load-balancer" {
  name        = "${var.tag}_load_balancer_security_group"
  description = "Controls access to the ALB"
  vpc_id      = aws_vpc.production-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.tag}_load_balancer_security_group"
    Environment = "${var.environment}"
  }
}

resource "aws_security_group" "ssh-group" {
  name        = "ssh-access-group"
  description = "Allow traffic to port 22 (SSH)"
  vpc_id      = aws_vpc.production-vpc.id

  tags = {
    Name = "SSH Access Security Group"
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}

resource "aws_security_group" "http-group" {
  name        = "http-access-group"
  description = "Allow traffic on port 80 (HTTP)"
  vpc_id      = aws_vpc.production-vpc.id

  tags = {
    Name = "HTTP Inbound Traffic Security Group"
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}

resource "aws_security_group" "outbound-all" {
  name        = "outbound-all"
  description = "Allow all outbound traffic"
  vpc_id      = aws_vpc.production-vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.tag}_outbound_all"
    Environment = "${var.environment}"
  }
}

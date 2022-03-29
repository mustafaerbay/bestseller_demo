resource "aws_vpc_endpoint" "example" {
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_id            = aws_vpc.production-vpc.id

  depends_on        = [
    aws_subnet.private-subnet-1,
    aws_subnet.private-subnet-2
    ]
}

resource "aws_vpc_endpoint_route_table_association" "example" {
  route_table_id  = aws_route_table.private-route-table.id
  vpc_endpoint_id = aws_vpc_endpoint.example.id
}
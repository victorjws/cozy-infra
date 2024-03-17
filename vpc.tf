resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_db_subnet_group" "rds" {
  name       = "main"
  subnet_ids = [aws_subnet.public.id, aws_subnet.private.id]
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 3, 1)
  availability_zone = var.availability_zone1
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 3, 2)
  availability_zone = var.availability_zone2
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "a1" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "a2" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.rt.id
}

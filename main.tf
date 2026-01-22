resource "aws_vpc" "c_vpc" {
    cidr_block = var.infra.vpc_cidr
    tags = {
      Name = var.infra.vpc_name
    }
  
}
resource "aws_subnet" "c_sub" {
    vpc_id = aws_vpc.c_vpc.id
    count = length(var.infra.sub_info.sub_az)
    cidr_block = var.infra.sub_info.sub_cidr [count.index]
    availability_zone = var.infra.sub_info.sub_az [count.index]
    tags = {
        name = var.infra.sub_info.sub_name [count.index]
    }
  
}
resource "aws_internet_gateway" "c_igw" {
    vpc_id = aws_vpc.c_vpc.id
    tags = {
      Name = "my-igw"
    }
  
}
resource "aws_route_table" "c_rt" {
  count  = 3
  vpc_id = aws_vpc.c_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.c_igw.id
  }

  tags = {
    Name = "c-rt-${count.index + 1}"
  }
}
resource "aws_route_table_association" "c_assos" {
  count          = 3
  subnet_id      = aws_subnet.c_sub[count.index].id
  route_table_id = aws_route_table.c_rt[count.index].id
}
resource "aws_security_group" "c_sg1" {
  name        = "my-sg-1"
  description = "Security Group 1"
  vpc_id      = aws_vpc.c_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "c_sg2" {
  name        = "my-sg-2"
  description = "Security Group 2"
  vpc_id      = aws_vpc.c_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "c_sg3" {
  name        = "my-sg-3"
  description = "Security Group 3"
  vpc_id      = aws_vpc.c_vpc.id

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
}

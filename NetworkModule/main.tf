#vpc
resource "aws_vpc" "Demo" {
  cidr_block       = var.vpc_cidr_block

  tags = {
    Name = var.vpc_name
    Environment = "TEST"
  }
}
#internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.Demo.id
  tags = {
    Name = "Demo"
  }
}
#subnet1
resource "aws_subnet" "sub1" {
  vpc_id     = aws_vpc.Demo.id
  cidr_block = var.subnet_cidr_block_1
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1a"

  tags = {
    Name = var.subnet_name1
  }
}

#subnet2
resource "aws_subnet" "sub2" {
  vpc_id     = aws_vpc.Demo.id
  cidr_block = var.subnet_cidr_block_2
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1b"

  tags = {
    Name = var.subnet_name2
  }
}

#subnet3
resource "aws_subnet" "sub3" {
  vpc_id     = aws_vpc.Demo.id
  cidr_block = var.subnet_cidr_block_3
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1c"

  tags = {
    Name = var.subnet_name3
  }
}


#route Table
resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.Demo.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "rtb"
  }
}

#associating route table and subnet1
resource "aws_route_table_association" "rta_sub1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.rtb.id
}

#associating route table and subnet2
resource "aws_route_table_association" "rta_sub2" {
  subnet_id      = aws_subnet.sub2.id
  route_table_id = aws_route_table.rtb.id
}

#associating route table and subnet3
resource "aws_route_table_association" "rta_sub3" {
  subnet_id      = aws_subnet.sub3.id
  route_table_id = aws_route_table.rtb.id
}

#security group
resource "aws_security_group" "sg" {
  name        = var.security_group_name
  vpc_id      = aws_vpc.Demo.id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 8084
    to_port          = 8084
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.security_group_name
  }
}

# data "aws_vpc" "data_vpc" {
#   id = var.vpc_name.id
# }

# data "aws_subnet" "datasub2" {
#   id = aws_subnet.sub2.id
# }

# data "aws_vpc" "data_vpc" {
#   id = module.Network.vpc_id
# }

# data "aws_subnet" "datasub2" {
#   filter {
#     name = "tag:Name"
#     values = ["sub2"]
#   }
#   depends_on = [ aws_subnet.sub2 ]
#   # vpc_id = module.Network.vpc_id
#   # tags = {
#   #   Name = "sub2"
#   # }
# }

# output "vpc_id" {
#   value = aws_vpc.Demo.id
# }
# output "subnet_ids" {
#   value = [ aws_subnet.sub1.id, aws_subnet.sub2.id, aws_subnet.sub3.id]
# }

# output "security_group_name" {
#   value =  aws_security_group.sg.id
# }


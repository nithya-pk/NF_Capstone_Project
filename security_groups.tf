# Security group to allow access to ALB
resource "aws_security_group" "allow_tcp_alb" {
 name = "allow_tcp_alb"
 description = "Allow traffic for ALB"
 vpc_id = aws_vpc.NK_VPC.id
  ingress {
   description      = "allow SSH"
   from_port        = 22
   to_port          = 22
   protocol         = "tcp"
   cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
   description      = "allow web http"
   from_port        = 80
   to_port          = 80
   protocol         = "tcp"
   cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
   description      = "allow web https"
   from_port        = 443
   to_port          = 443
   protocol         = "tcp"
   cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
   description      = "allow all traffic"
   from_port        = 0
   to_port          = 0
   protocol         = "-1"
   cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {Name = "allow_tcp_alb"}
}

# Security group to allow access to Back End EC2 instances
resource "aws_security_group" "allow_tcp_be" {
 name = "allow_tcp_be"
 description = "Allow traffic for EC2 BE"
 vpc_id = aws_vpc.NK_VPC.id
  ingress {
   description      = "allow SSH"
   from_port        = 22
   to_port          = 22
   protocol         = "tcp"
   cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
   description      = "allow web http"
   from_port        = 3306
   to_port          = 3306
   protocol         = "tcp"
   cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
   description      = "allow all traffic"
   from_port        = 0
   to_port          = 0
   protocol         = "-1"
   cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {Name = "allow_tcp_be"}
}

resource "aws_security_group" "db_sg" {
 name = "db_sg"
 description = "Allow 3306 for DB"
 vpc_id = aws_vpc.NK_VPC.id
 ingress {
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
 }
 egress {
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
 }
 tags = {Name = "allow_3306_db"}
}

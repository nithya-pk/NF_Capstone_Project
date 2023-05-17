# Security group to allow access to Bastion host
resource "aws_security_group" "allow_tcp_bastionhost" {
 name = "allow_access_to_host"
 description = "Allow traffic for Bastion host"
 vpc_id = aws_vpc.NK_VPC.id
  ingress {
   description      = "allow SSH"
   from_port        = 22
   to_port          = 22
   protocol         = "tcp"
   cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
   description = "allow all traffic to backend instances"
   from_port = 0
   to_port = 0
   protocol = "-1"
  }
  egress {
   description      = "allow all traffic"
   from_port        = 0
   to_port          = 0
   protocol         = "-1"
   cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {Name = "allow_tcp_bastionhost"}
}


resource "aws_instance" "bastion_host" {
 ami = var.ami_ver
 instance_type = var.ec2_type
 key_name = var.ssh_key_pair
 subnet_id = aws_subnet.public_subnets[0].id
 vpc_security_group_ids = [aws_security_group.allow_tcp_bastionhost.id]
 associate_public_ip_address = true
 iam_instance_profile = var.instance_profile
 tags = {Name = "bastion_host"}
}

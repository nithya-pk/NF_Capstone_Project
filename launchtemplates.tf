 # launch template for front end server
 resource "aws_launch_template" "fe_server" {
  name_prefix = "fe_server"
  image_id = "${var.ami_ver}"
  instance_type = "${var.ec2_type}"
  key_name = var.ssh_key_pair
  user_data = base64encode(file("./scripts/installfe.sh"))
  iam_instance_profile {name = var.instance_profile}
  # Network interfaces for the instances
  network_interfaces {
   device_index = 0
   # subnet_id = aws_subnet.public_subnets[0].id
   security_groups = [aws_security_group.allow_tcp_be.id]
  }
  tag_specifications {
   resource_type = "instance"
   tags = {Name = "front end"}
  }
 }

# launch template for backend server
resource "aws_launch_template" "be_server" {
 name_prefix = "be_server"
 image_id = "${var.ami_ver}"
 instance_type = "${var.ec2_type}"
 key_name = var.ssh_key_pair
 depends_on = [aws_rds_cluster.db_cluster,]
 user_data = base64encode(file("./scripts/installbe.sh"))
 iam_instance_profile {name = var.instance_profile}
 # Network interfaces for the instances
 network_interfaces {
  device_index = 0
  # subnet_id = aws_subnet.private_subnets[*].id
  security_groups = [aws_security_group.allow_tcp_be.id, aws_security_group.db_sg.id]
 }
 tag_specifications {
  resource_type = "instance"
  tags = {Name = "back end"}
 }
}
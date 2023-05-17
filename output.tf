output "VPCName" {
 value = aws_vpc.NK_VPC.id
 description = "Name of the VPC"
}

output "PrivateSubnetsFE"{
 value = [aws_subnet.private_subnets_fe[0].id, aws_subnet.private_subnets_fe[1].id]
 description = "Subnets for FEs"
}

output "PrivateSubnetsBE_DB"{
 value = [aws_subnet.private_subnets_be_db[0].id, aws_subnet.private_subnets_be_db[1].id]
 description = "Subnets for BEs and DB"
}

output "BastionIP" {
 value = aws_instance.bastion_host.public_ip
 description = "Bastion Host IP Address"
}

output "app_lb_name" {
 value = aws_alb.FEalb.id
 description = "FE ALB Name"
}

 output "alb_arn" {
  value = aws_alb.FEalb.arn
  description = "ARN of FE ALB"
}


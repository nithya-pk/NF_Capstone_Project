# VPC named "NK_VPC" with CIDR mentioned in tfvars file
resource "aws_vpc" "NK_VPC" {
 cidr_block = var.NK_VPC_cidr
 instance_tenancy = "default"
 tags = {Name = "NK_VPC"}
}

# Internet Gateway and attach it to NK_VPC
resource "aws_internet_gateway" "IGW" {
#  vpc_id =  aws_vpc.NK_VPC.id
 tags = {Name = "NK_VPC_IGW"}
}

resource "aws_internet_gateway_attachment" "IGWattachment" {
 internet_gateway_id = aws_internet_gateway.IGW.id
 vpc_id =  aws_vpc.NK_VPC.id
}

# private subnets for FEs with CIDRs mentioned in vars file
resource "aws_subnet" "public_subnets" {
 count = length(var.public_subnets)
 vpc_id =  aws_vpc.NK_VPC.id
 cidr_block = element(var.public_subnets, count.index)
 availability_zone = element(var.az, count.index)
 tags = {Name = "NK_VPC_PubSub${count.index + 1}"}
}


# private subnets for FEs with CIDRs mentioned in vars file
resource "aws_subnet" "private_subnets_fe" {
 count = length(var.private_subnets_fe)
 vpc_id =  aws_vpc.NK_VPC.id
 cidr_block = element(var.private_subnets_fe, count.index)
 availability_zone = element(var.az, count.index)
 tags = {Name = "NK_VPC_PrvSubFE${count.index + 1}"}
}

# private subnets for BEs and DBs with CIDRs mentioned in vars file
resource "aws_subnet" "private_subnets_be_db" {
 count = length(var.private_subnets_be_db)
 vpc_id =  aws_vpc.NK_VPC.id
 cidr_block = element(var.private_subnets_be_db, count.index)
 availability_zone = element(var.az, count.index)
 tags = {Name = "NK_VPC_PriSubBE_DB${count.index + 1}"}
}

# Assign EIP for NAT gateway
resource "aws_eip" "nat_eip" {
 count = length(var.public_subnets)
 vpc = true
}

# NAT gateway with publicsubnets and elastic IP
resource "aws_nat_gateway" "nat_gw" {
  count = length(var.public_subnets)
  subnet_id = aws_subnet.public_subnets[count.index].id
  allocation_id = aws_eip.nat_eip[count.index].id
  tags = {
    Name = "NK_NAT_Gateway${count.index + 1}"
  }
}

# Route table for publicsubnets. Traffic from public subnets reaches internet via IGW
resource "aws_route_table" "PublicRT" {
 vpc_id =  aws_vpc.NK_VPC.id
 depends_on = [aws_internet_gateway.IGW]
  route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.IGW.id
  }
 tags = {Name = "NK_VPC_PublicRT"} 
}

# Route table for privatesubnets. Traffic from private subnets reaches internet via NAT
resource "aws_route_table" "PrivateRT" {
 count = length(var.private_subnets_fe)
 vpc_id = aws_vpc.NK_VPC.id
 tags = {Name = "NK_VPC_PrivateRT${count.index + 1}"}
 route {
  cidr_block     = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gw[count.index].id
  }
}

# Route table association with publicsubnets
resource "aws_route_table_association" "PublicRTassociation" {
 count = length(var.public_subnets)
 subnet_id = element(aws_subnet.public_subnets[*].id, count.index)
 route_table_id = aws_route_table.PublicRT.id
}

# # Route table association with privatesubnets
# resource "aws_route_table_association" "PrivateRTassociation" {
#  count = length(var.private_subnets_fe)
#  subnet_id = element(aws_subnet.private_subnets_fe[*].id, count.index)
#  route_table_id = aws_route_table.PrivateRT[count.index].id
# }

# Route table association with private subnets
resource "aws_route_table_association" "PrivateRTassociation" {
  count          = length(concat(var.private_subnets_fe, var.private_subnets_be_db))
  subnet_id      = element(concat(aws_subnet.private_subnets_fe[*].id, aws_subnet.private_subnets_be_db[*].id), count.index)
  route_table_id = aws_route_table.PrivateRT[count.index % length(aws_route_table.PrivateRT)].id
}

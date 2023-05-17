variable "NK_VPC_cidr" {
 type = string
 description = "CIDR for VPC"
 default = "10.0.0.0/16"
}

variable "az" {
 description = "Availability Zones"
 default = ["us-west-2a", "us-west-2b"]
}

variable "public_subnets" {
 type = list(string)
 description = "CIDRs of Subnets for FEs"
 default = ["10.0.5.0/24", "10.0.6.0/24"]
}

variable "private_subnets_fe" {
 type = list(string)
 description = "CIDRs of Subnets for FEs"
 default = ["10.0.0.0/24", "10.0.2.0/24"]
}

variable "private_subnets_be_db" {
 type = list(string)
 description = "CIDRs of Subnets for BEs and DBs"
 default = ["10.0.1.0/24", "10.0.3.0/24"]
}

variable "ami_ver" {
 type = string
 description = "Version for EC2 AMI"
 default = "ami-0ac64ad8517166fb1"
}

variable "ec2_type" {
 type = string
 description = "Tier for EC2"  
 default = "t3.micro"
}

variable "ssh_key_pair" {
 type = string
 description = "SSH key pair to be provisioned on the instance"
 default = "vockey"
}

variable "instance_profile" {
 type = string
 description = "IAM role for Session Manager of instances"
 default = "LabInstanceProfile"
}

variable "dbpassword"{
 default = "admin123"
}

variable "dbusername"{
 default = "root"
}


# variable "dbusername" {
#  type = string
#  description = "Username for the database. Should be between 3 and 10 characters long, ca contain only lowercase letters and numbers."
#  validation {
#   condition = length(var.dbusername) >= 3 && length(var.dbusername) <= 10 && regexall("^[a-z0-9]+$", var.dbusername) == true
#   error_message = "Username must be between 3 and 10 characters long and should contain only lowercase letters and numbers."
#  }
# }

# variable "dbpassword" {
#  type = string
#  description = "Aurora database password. Must be 8 characters long and contain alphanumeric characters and hyphens."
#  sensitive = true
#  validation {
#   condition = length(var.dbpassword) >= 8 && regexall("^[a-zA-Z0-9-]+$", var.dbpassword) == true
#   error_message = "Aurora database password must be 8 characters long, can contain alphanumeric characters and hyphens only"
#  }
# }


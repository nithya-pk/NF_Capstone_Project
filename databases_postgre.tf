# Create subnet group for Aurora cluster
resource "aws_db_subnet_group" "db_subnet_group" {
 name = "db_subnet_group"
 subnet_ids = aws_subnet.private_subnets_be_db.*.id
}

# Create Aurora DB cluster
resource "aws_rds_cluster" "db_cluster" {
 engine = "aurora-postgresql"
 engine_version = "14.6"
 cluster_identifier = "auroracluster"
 database_name = "auroradbcluster"
 master_username = var.dbusername
 master_password = var.dbpassword
 db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
 vpc_security_group_ids = [aws_security_group.db_sg.id]
 skip_final_snapshot = true
 final_snapshot_identifier = "aurora-final-snapshot"
#  scaling_configuration {
#   auto_pause = true
#   max_capacity = 2
#   min_capacity = 2
#   seconds_until_auto_pause = 300
#  }
 lifecycle {
  ignore_changes = [scaling_configuration]
 }
 depends_on = [aws_security_group.db_sg]
 tags = {Name = "db_cluster"}
}

# Create Aurora writer instance
resource "aws_rds_cluster_instance" "dbinstance" {
 count = 2
 identifier = "clusterinstance-${count.index}"
 cluster_identifier = aws_rds_cluster.db_cluster.id
 instance_class = "db.t3.medium"
 engine = "aurora-postgresql"
 publicly_accessible  = false
 db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
 availability_zone = element(var.az, count.index % length(var.az))
 depends_on = [aws_rds_cluster.db_cluster,]
 tags = {
  Name = "auroracluster-db-instance${count.index + 1}"
  Environment = "Dev/Test"
 }
}



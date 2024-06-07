variable "private_subnets" {
  description = "List of private subnets"
  type        = list(string)
}

variable "rds_sg_id" {
  description = "Security Group ID for RDS"
  type        = string
}

resource "aws_db_subnet_group" "default" {
  name       = "my-db-subnet-group"
  subnet_ids = var.private_subnets

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage         = 20
  engine                    = "postgres"
  instance_class            = "db.t4g.micro"
  username                  = "postgres"
  password                  = "password1234"
  vpc_security_group_ids    = [var.rds_sg_id]
  db_subnet_group_name      = aws_db_subnet_group.default.name
  skip_final_snapshot       = false
  final_snapshot_identifier = "my-final-snapshot-${timestamp()}"
}

output "db_instance_address" {
  value = aws_db_instance.default.address
}

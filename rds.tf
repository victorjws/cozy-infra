resource "aws_db_instance" "postgres" {
  allocated_storage      = 20
  db_name                = "cozy"
  engine                 = "postgres"
  engine_version         = "16"
  instance_class         = "db.t3.micro"
  username               = var.rds_username
  password               = var.rds_password
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.rds.name
}


# S3 Bucket for Infrastructure Data
resource "aws_s3_bucket" "data_rds_data" {
  bucket = "data-rds-data"

  tags = {
    Name        = "database_group"
    Environment = "infrastructure"
  }
}

# VPC
resource "aws_vpc" "data_rds" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "database_group"
    Environment = "infrastructure"
  }
}


data "aws_availability_zones" "available" {}


# Subnets(public and private)
resource "aws_subnet" "rds_subnet_public" {
  vpc_id            = aws_vpc.data_rds.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name        = "database_group"
    Environment = "infrastructure"
  }
}

resource "aws_subnet" "rds_subnet_private" {
  vpc_id            = aws_vpc.data_rds.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name        = "database_group"
    Environment = "infrastructure"
  }
}

# subnet group
resource "aws_db_subnet_group" "rds_subnet_group" {
  name = "rds_subnet_group"
  subnet_ids = [
    aws_subnet.rds_subnet_public.id,
    aws_subnet.rds_subnet_private.id
  ]

  tags = {
    Name = "rds_subnet_group"
  }
}

# Internet Gateway & Routing
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.data_rds.id

  tags = {
    Name = "rds-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.data_rds.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.rds_subnet_public.id
  route_table_id = aws_route_table.public_rt.id
}

# Security Group

resource "aws_security_group" "chiz_tls" {
  name        = "chiz_tls"
  description = "Allow MySQL inbound and all outbound traffic"
  vpc_id      = aws_vpc.data_rds.id

  tags = {
    Name        = "database_group"
    Environment = "infrastructure"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_mysql" {
  security_group_id = aws_security_group.chiz_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 3306
  to_port           = 3306
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_egress" {
  security_group_id = aws_security_group.chiz_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}


# RDS Instance
data "aws_ssm_parameter" "rds_data" {
  name            = "rds_data"
  with_decryption = true
}

resource "aws_db_instance" "rds_data" {
  allocated_storage      = 10
  db_name                = "database_rds"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = "rds_data"
  password               = data.aws_ssm_parameter.rds_data.value
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  publicly_accessible    = true
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.chiz_tls.id]

  tags = {
    Name        = "database_group"
    Environment = "infrastructure"
  }
}

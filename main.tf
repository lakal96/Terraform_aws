#Terraform to build AWS Solution-Lalindra

# Define the AWS provider
provider "aws" {
  region = "ap-south-1"  # Change to your desired region
}

# Creating a VPC
resource "aws_vpc" "VPC-NV-MSD-SDB-PROD-VPC-1" {
  cidr_block = "192.168.0.0/16"
  tags = {
    Name = "VPC-NV-MSD-SDB-PROD-VPC-1"
    ApplicationName = "StudentDB"
    AppOwner = "MIT-MSD"
    CostCenter = "MSD"
  }
}

# Creating subnets in Availability Zone 1a
resource "aws_subnet" "SN-NV-MSD-SDB-PROD-PUBLIC-1a" {
  vpc_id                  = aws_vpc.VPC-NV-MSD-SDB-PROD-VPC-1.id
  cidr_block              = "192.168.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "SN-NV-MSD-SDB-PROD-PUBLIC-1a"
    ApplicationName = "StudentDB"
    AppOwner = "MIT-MSD"
    CostCenter = "MSD"
  }
}

resource "aws_subnet" "SN-NV-MSD-SDB-PROD-PRIVATE-1a" {
  vpc_id                  = aws_vpc.VPC-NV-MSD-SDB-PROD-VPC-1.id
  cidr_block              = "192.168.2.0/24"
  availability_zone       = "ap-south-1a"
  tags = {
    Name = "SN-NV-MSD-SDB-PROD-PRIVATE-1a"
    ApplicationName = "StudentDB"
    AppOwner = "MIT-MSD"
    CostCenter = "MSD"
  }
}

resource "aws_subnet" "SN-NV-MSD-SDB-PROD-DB-1a" {
  vpc_id                  = aws_vpc.VPC-NV-MSD-SDB-PROD-VPC-1.id
  cidr_block              = "192.168.3.0/24"
  availability_zone       = "ap-south-1a"
  tags = {
    Name = "SN-NV-MSD-SDB-PROD-DB-1a"
    ApplicationName = "StudentDB"
    AppOwner = "MIT-MSD"
    CostCenter = "MSD"
  }
}

# Creating subnets in Availability Zone 1b

resource "aws_subnet" "SN-NV-MSD-SDB-PROD-PUBLIC-1b" {
  vpc_id                  = aws_vpc.VPC-NV-MSD-SDB-PROD-VPC-1.id
  cidr_block              = "192.168.4.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "SN-NV-MSD-SDB-PROD-PUBLIC-1b"
    ApplicationName = "StudentDB"
    AppOwner = "MIT-MSD"
    CostCenter = "MSD"
  }
}

resource "aws_subnet" "SN-NV-MSD-SDB-PROD-PRIVATE-1b" {
  vpc_id                  = aws_vpc.VPC-NV-MSD-SDB-PROD-VPC-1.id
  cidr_block              = "192.168.5.0/24"
  availability_zone       = "ap-south-1b"
  tags = {
    Name = "SN-NV-MSD-SDB-PROD-PRIVATE-1b"
    ApplicationName = "StudentDB"
    AppOwner = "MIT-MSD"
    CostCenter = "MSD"
  }
}

resource "aws_subnet" "SN-NV-MSD-SDB-PROD-DB-1b" {
  vpc_id                  = aws_vpc.VPC-NV-MSD-SDB-PROD-VPC-1.id
  cidr_block              = "192.168.6.0/24"
  availability_zone       = "ap-south-1b"
  tags = {
    Name = "SN-NV-MSD-SDB-PROD-DB-1b"
    ApplicationName = "StudentDB"
    AppOwner = "MIT-MSD"
    CostCenter = "MSD"
  }
}

# Creating an Internet Gateway

resource "aws_internet_gateway" "SN-NV-MSD-SDB-PROD-IGW-GATEWAY" {
  vpc_id = aws_vpc.VPC-NV-MSD-SDB-PROD-VPC-1.id
}

# Creating a route table for public subnets

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.VPC-NV-MSD-SDB-PROD-VPC-1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.SN-NV-MSD-SDB-PROD-IGW-GATEWAY.id
  }
  tags = {
    Name = "VPC-NV-MSD-SDB-PROD-VPC-1"
    ApplicationName = "StudentDB"
    AppOwner = "MIT-MSD"
    CostCenter = "MSD"
  }
}

# Associate the public route table with the public subnets

resource "aws_route_table_association" "public_subnet_assoc" {
  subnet_id      = aws_subnet.SN-NV-MSD-SDB-PROD-PUBLIC-1a.id
  route_table_id = aws_route_table.public_rt.id
}

# Creating security groups for EC2 instances

resource "aws_security_group" "SG-NV-MSD-SDB-PROD-public" {
  vpc_id = aws_vpc.VPC-NV-MSD-SDB-PROD-VPC-1.id

  # inbound and outbound rules

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH access from anywhere (for demonstration purposes)
  }

  # outbound rules 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Other security group settings...

  name = "SG-NV-MSD-SDB-PROD-public"
}
resource "aws_security_group" "SG-NV-MSD-SDB-PROD-private" {
  vpc_id = aws_vpc.VPC-NV-MSD-SDB-PROD-VPC-1.id

  # inbound and outbound rules

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH access from anywhere (for demonstration purposes)
  }

  # outbound rules 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Other security group settings...

  name = "SG-NV-MSD-SDB-PROD-private"
}

resource "aws_security_group" "SG-NV-MSD-SDB-PROD-db" {
  vpc_id = aws_vpc.VPC-NV-MSD-SDB-PROD-VPC-1.id

  # inbound and outbound rules

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH access from anywhere (for demonstration purposes)
  }

  # outbound rules 

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Other security group settings...

  name = "SG-NV-MSD-SDB-PROD-db"
}

resource "tls_private_key" "my_key_pair" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "public_key_pair" {
  key_name   = "public_key_pair"
  public_key = tls_private_key.my_key_pair.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.my_key_pair.private_key_pem
  filename = "/home/cloudshell-user/private_key.pem"
}

resource "aws_instance" "EC2-NV-MSD-SDB-PROD-NAT" {
  instance_type  = "t2.micro"
  ami            = "ami-04e5276ebb8451442"
  subnet_id      = aws_subnet.SN-NV-MSD-SDB-PROD-PUBLIC-1a.id
  security_groups = [aws_security_group.SG-NV-MSD-SDB-PROD-public.id]
  key_name       = aws_key_pair.public_key_pair.key_name // Use the key pair created above
    tags = {
    Name = "EC2-NV-MSD-SDB-PROD-NAT"
    ApplicationName = "StudentDB"
    AppOwner = "MIT-MSD"
    CostCenter = "MSD"

}
}

resource "tls_private_key" "my_key_pair_app" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "public_key_pair_app" {
  key_name   = "public_key_pair_app"
  public_key = tls_private_key.my_key_pair_app.public_key_openssh
}

resource "local_file" "private_key_app" {
  content  = tls_private_key.my_key_pair_app.private_key_pem
  filename = "/home/cloudshell-user/private_key_app.pem"
}
resource "aws_instance" "SG-NV-MSD-SDB-PROD-APP" {
  instance_type  = "t2.micro"
  ami  = "ami-04e5276ebb8451442"
  subnet_id      = aws_subnet.SN-NV-MSD-SDB-PROD-PRIVATE-1a.id
  security_groups = [aws_security_group.SG-NV-MSD-SDB-PROD-private.id]
  key_name       = aws_key_pair.public_key_pair_app.key_name
  # Other instance configuration as needed
      tags = {
    Name = "SG-NV-MSD-SDB-PROD-APP"
    ApplicationName = "StudentDB"
    AppOwner = "MIT-MSD"
    CostCenter = "MSD"

}
}


# Create a New Subnet Group

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "app_db-subnet-group"
  subnet_ids = [aws_subnet.SN-NV-MSD-SDB-PROD-PRIVATE-1a.id, aws_subnet.SN-NV-MSD-SDB-PROD-PRIVATE-1b.id]
}

# Creating RDS instance

resource "aws_db_instance" "DB-NV-MSD-SDB-PROD-APP_DB" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "15.6"     
  instance_class       = "db.t2.micro"
  username             = "admin"
  password             = "admin11223344"
  parameter_group_name = "default.postgres12" 

  vpc_security_group_ids = [aws_security_group.SG-NV-MSD-SDB-PROD-db.id]
}


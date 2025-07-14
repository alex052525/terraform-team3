# VPC
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}

# Subnet
locals {
  public_subnet_length     = length(var.public_subnets_cidr)
  private_subnet_length    = length(var.private_subnets_cidr)
  availability_zone_length = length(var.availability_zones)
}

resource "aws_subnet" "public" {
  count = local.public_subnet_length

  vpc_id     = aws_vpc.this.id
  cidr_block = var.public_subnets_cidr[count.index]

  map_public_ip_on_launch = true 
  availability_zone       = var.availability_zones[count.index % local.availability_zone_length]

  tags = {
    Name        = "team3-public-subnet-${count.index + 1}"
    NetworkType = "Public"
  }
}

resource "aws_subnet" "private" {
  count = local.private_subnet_length

  vpc_id     = aws_vpc.this.id
  cidr_block = var.private_subnets_cidr[count.index]

  availability_zone = var.availability_zones[count.index % local.availability_zone_length]

  tags = {
    Name        = "team3-private-subnet-${count.index + 1}"
    NetworkType = "Private"
  }
}

# Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "team3-public-route-table"
    NetworkType = "Public"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "team3-igw"  # ← AWS 콘솔에서 보일 이름!
  }
}

# Route
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  count = local.public_subnet_length

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "team3-private-route-table"
    NetworkType = "Private"
  }
}

resource "aws_route_table_association" "private" {
  count = local.private_subnet_length

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}


# --- Elastic IP for NAT Gateway ---
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "team3-nat-eip"
  }
}

# --- NAT Gateway ---
resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.public[0].id # 첫 번째 public subnet에 생성

  tags = {
    Name = "team3-nat-gw"
  }
}

# --- Private Route Table → NAT Gateway Route 추가 ---
resource "aws_route" "private_internet_access" {
  route_table_id = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.this.id
}
  



# sg
resource "aws_security_group" "bastion" {
  name        = "bastion-sg"
  description = "Allow SSH from anywhere"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # 개발용. 실무에서는 제한 필요
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-sg"
  }
}

# worker node SG 
resource "aws_security_group" "worker" {
  name   = "eks-worker-sg"
  vpc_id = aws_vpc.this.id

  # Bastion SG 로부터의 SSH 허용
  ingress {
    description      = "SSH from bastion"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups  = [ aws_security_group.bastion.id ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-worker-sg"
  }
}
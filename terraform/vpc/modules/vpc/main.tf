# Rosource-1: VPC

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = merge(var.tags, { Name : "${var.environment_name}-vpc" })
  lifecycle {
    prevent_destroy = false
  }
}

# Rosource-2: Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { Name : "${var.environment_name}-igw" })
}

# Resource-3: Public Subnet
resource "aws_subnet" "public" {
  for_each                = { for idx, az in local.azs : az => local.public_subnets[idx] }
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true
  tags                    = merge(var.tags, { Name : "${var.environment_name}-public-${each.key}" })
}

# Rsource-4: Private Subnet
resource "aws_subnet" "private" {
  for_each          = { for idx, az in local.azs : az => local.private_subnets[idx] }
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = each.key
  tags              = merge(var.tags, { Name : "${var.environment_name}-private-${each.key}" })
}

# Resource-5: Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  tags = merge(var.tags, { Name : "${var.environment_name}-nat-eip" })
}

# Resource-6 NAT Gateway
resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = values(aws_subnet.public)[0].id
  tags          = merge(var.tags, { Name : "${var.environment_name}-gw-NAT" })
  depends_on    = [aws_internet_gateway.igw]
}

# Resource-7: Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(var.tags, { Name : "${var.environment_name}-public_rt" })
}


# Resource-8: Public Route Table Association to Public Subnet
resource "aws_route_table_association" "public_rt_assoc" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}

# Resource-9: Private Route Table 
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgw.id
  }
  tags = merge(var.tags, { Name : "${var.environment_name}-private_rt" })
}

# Resource-10: private Route Table Association to Private Subnet
resource "aws_route_table_association" "private_rt_assoc" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rt.id
}

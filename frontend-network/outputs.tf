output "vpc_id" {
  description = "The ID of the frontend VPC"
  value       = aws_vpc.frontend_vpc.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the frontend VPC"
  value       = aws_vpc.frontend_vpc.cidr_block
}

# --- Public Subnets ---
output "public_subnet_ids" {
  description = "List of IDs of the public subnets"
  value = [
    aws_subnet.frontend_public_subnet01.id,
    aws_subnet.frontend_public_subnet02.id,
    aws_subnet.frontend_public_subnet03.id
  ]
}

output "public_subnet_01_id" {
  description = "ID of public subnet 01"
  value       = aws_subnet.frontend_public_subnet01.id
}

# --- Private Subnets ---
output "private_subnet_ids" {
  description = "List of IDs of the private subnets"
  value = [
    aws_subnet.frontend_private_subnet01.id,
    aws_subnet.frontend_private_subnet02.id,
    aws_subnet.frontend_private_subnet03.id
  ]
}

output "private_subnet_01_id" {
  description = "ID of private subnet 01"
  value       = aws_subnet.frontend_private_subnet01.id
}

output "private_subnet_02_id" {
  description = "ID of private subnet 02"
  value       = aws_subnet.frontend_private_subnet02.id
}

output "private_subnet_03_id" {
  description = "ID of private subnet 03"
  value       = aws_subnet.frontend_private_subnet03.id
}

# --- Gateways ---
output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.frontend_igw.id
}

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = aws_nat_gateway.frontend_ngw.id
}
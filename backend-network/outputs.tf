output "vpc_id" {
  description = "The ID of the backend VPC"
  value       = aws_vpc.backend_vpc.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the backend VPC"
  value       = aws_vpc.backend_vpc.cidr_block
}

output "private_rtb_02_id" {
  description = "ID of backend private route table 02"
  value       = aws_route_table.backend_private_rtb02.id
}

output "private_rtb_03_id" {
  description = "ID of backend private route table 03"
  value       = aws_route_table.backend_private_rtb03.id
}

# --- Public Subnets ---
output "public_subnet_ids" {
  description = "List of IDs of the backend public subnets"
  value = [
    aws_subnet.backend_public_subnet01.id,
    aws_subnet.backend_public_subnet02.id,
    aws_subnet.backend_public_subnet03.id
  ]
}

output "public_subnet_01_id" {
  description = "ID of backend public subnet 01"
  value       = aws_subnet.backend_public_subnet01.id
}

output "public_subnet_02_id" {
  description = "ID of backend public subnet 02"
  value       = aws_subnet.backend_public_subnet02.id
}

output "public_subnet_03_id" {
  description = "ID of backend public subnet 03"
  value       = aws_subnet.backend_public_subnet03.id
}

# --- Private Subnets ---
output "private_subnet_ids" {
  description = "List of IDs of the backend private subnets"
  value = [
    aws_subnet.backend_private_subnet01.id,
    aws_subnet.backend_private_subnet02.id,
    aws_subnet.backend_private_subnet03.id
  ]
}

output "private_subnet_01_id" {
  description = "ID of backend private subnet 01"
  value       = aws_subnet.backend_private_subnet01.id
}

output "private_subnet_02_id" {
  description = "ID of backend private subnet 02"
  value       = aws_subnet.backend_private_subnet02.id
}

output "private_subnet_03_id" {
  description = "ID of backend private subnet 03"
  value       = aws_subnet.backend_private_subnet03.id
}

# --- Gateways ---
output "internet_gateway_id" {
  description = "The ID of the backend Internet Gateway"
  value       = aws_internet_gateway.backend_igw.id
}

output "nat_gateway_id" {
  description = "The ID of the backend NAT Gateway"
  value       = aws_nat_gateway.backend_ngw.id
}
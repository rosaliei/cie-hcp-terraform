# --- Key Pairs ---
output "fe_key_name" {
  description = "The name of the frontend key pair"
  value       = aws_key_pair.fe_keypair.key_name
}

# --- Frontend Private Instances ---
output "frontend_private_instance01_id" {
  description = "The ID of frontend private instance 01"
  value       = aws_instance.frontend_private_instance01.id
}

output "frontend_private_instance01_ip" {
  description = "The private IP address of frontend private instance 01"
  value       = aws_instance.frontend_private_instance01.private_ip
}

output "frontend_private_instance02_id" {
  description = "The ID of frontend private instance 02"
  value       = aws_instance.frontend_private_instance02.id
}

output "frontend_private_instance02_ip" {
  description = "The private IP address of frontend private instance 02"
  value       = aws_instance.frontend_private_instance02.private_ip
}

output "frontend_private_instance03_id" {
  description = "The ID of frontend private instance 03"
  value       = aws_instance.frontend_private_instance03.id
}

output "frontend_private_instance03_ip" {
  description = "The private IP address of frontend private instance 03"
  value       = aws_instance.frontend_private_instance03.private_ip
}

# --- Grouped Lists for Convenience ---
output "frontend_private_instance_ids" {
  description = "List of all frontend private instance IDs"
  value = [
    aws_instance.frontend_private_instance01.id,
    aws_instance.frontend_private_instance02.id,
    aws_instance.frontend_private_instance03.id
  ]
}

output "frontend_private_instance_ips" {
  description = "List of all frontend private instance private IPs"
  value = [
    aws_instance.frontend_private_instance01.private_ip,
    aws_instance.frontend_private_instance02.private_ip,
    aws_instance.frontend_private_instance03.private_ip
  ]
}
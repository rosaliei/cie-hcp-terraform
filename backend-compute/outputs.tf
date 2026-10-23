# --- Key Pairs ---
output "be_key_name" {
  description = "The name of the backend key pair"
  value       = aws_key_pair.be_keypair.key_name
}

# --- Backend Public Instance ---
output "backend_public_instance01_id" {
  description = "The ID of backend public instance 01"
  value       = aws_instance.backend_public_instance01.id
}

output "backend_public_instance01_ip" {
  description = "The public IP address (via Elastic IP) of backend public instance 01"
  value       = aws_eip.backend_public_instance_eip.public_ip
}

# --- Backend Private Instances ---
output "backend_private_instance01_id" {
  description = "The ID of backend private instance 01"
  value       = aws_instance.backend_private_instance01.id
}

output "backend_private_instance01_ip" {
  description = "The private IP address of backend private instance 01"
  value       = aws_instance.backend_private_instance01.private_ip
}

output "backend_private_instance02_id" {
  description = "The ID of backend private instance 02"
  value       = aws_instance.backend_private_instance02.id
}

output "backend_private_instance02_ip" {
  description = "The private IP address of backend private instance 02"
  value       = aws_instance.backend_private_instance02.private_ip
}

output "backend_private_instance03_id" {
  description = "The ID of backend private instance 03"
  value       = aws_instance.backend_private_instance03.id
}

output "backend_private_instance03_ip" {
  description = "The private IP address of backend private instance 03"
  value       = aws_instance.backend_private_instance03.private_ip
}

# --- Grouped Lists for Convenience ---
output "backend_private_instance_ids" {
  description = "List of all backend private instance IDs"
  value = [
    aws_instance.backend_private_instance01.id,
    aws_instance.backend_private_instance02.id,
    aws_instance.backend_private_instance03.id
  ]
}

output "backend_private_instance_ips" {
  description = "List of all backend private instance private IPs"
  value = [
    aws_instance.backend_private_instance01.private_ip,
    aws_instance.backend_private_instance02.private_ip,
    aws_instance.backend_private_instance03.private_ip
  ]
}
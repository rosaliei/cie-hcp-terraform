# --- Security Group IDs ---

output "fe_public_sg01_id" {
  description = "The ID of the frontend public security group 01"
  value       = aws_security_group.fe_public_sg01.id
}

output "fe_private_sg01_id" {
  description = "The ID of the frontend private security group 01"
  value       = aws_security_group.fe_private_sg01.id
}

output "fe_private_sg02_id" {
  description = "The ID of the frontend private security group 02"
  value       = aws_security_group.fe_private_sg02.id
}

output "fe_private_sg03_id" {
  description = "The ID of the frontend private security group 03"
  value       = aws_security_group.fe_private_sg03.id
}

# --- Grouped Output for Convenience ---
output "fe_security_group_ids" {
  description = "A map of all frontend security group IDs"
  value = {
    public_01  = aws_security_group.fe_public_sg01.id
    private_01 = aws_security_group.fe_private_sg01.id
    private_02 = aws_security_group.fe_private_sg02.id
    private_03 = aws_security_group.fe_private_sg03.id
  }
}
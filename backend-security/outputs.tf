output "be_public_sg01_id" {
  description = "The ID of the backend public security group 01"
  value       = aws_security_group.be_public_sg01.id
}

output "be_private_sg01_id" {
  description = "The ID of the backend private security group 01"
  value       = aws_security_group.be_private_sg01.id
}

output "be_private_sg02_id" {
  description = "The ID of the backend private security group 02"
  value       = aws_security_group.be_private_sg02.id
}

output "be_private_sg03_id" {
  description = "The ID of the backend private security group 03"
  value       = aws_security_group.be_private_sg03.id
}

# --- Grouped Map for Convenience ---
output "be_security_group_ids" {
  description = "A map of all backend security group IDs"
  value = {
    public_01  = aws_security_group.be_public_sg01.id
    private_01 = aws_security_group.be_private_sg01.id
    private_02 = aws_security_group.be_private_sg02.id
    private_03 = aws_security_group.be_private_sg03.id
  }
}
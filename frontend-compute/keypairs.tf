locals {
  fe_private_key_filename = "${var.frontend_prefix}-ssh-key.pem"
}

resource "tls_private_key" "fe_keypair" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "fe_keypair" {
  key_name   = local.fe_private_key_filename
  public_key = tls_private_key.fe_keypair.public_key_openssh
}

# Automatically save the private key locally for frontend instances
resource "local_file" "fe_private_key_pem" {
  content  = tls_private_key.fe_keypair.private_key_pem
  filename = "${path.module}/${local.fe_private_key_filename}"
  # file_permission      = "0400" # Secure file permissions required for SSH keys
  # directory_permission = "0700"
}
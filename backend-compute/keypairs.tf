locals {
  be_private_key_filename = "${var.backend_prefix}-ssh-key.pem"
}

resource "tls_private_key" "be_keypair" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "be_keypair" {
  key_name   = local.be_private_key_filename
  public_key = tls_private_key.be_keypair.public_key_openssh
}

# Automatically save the private key locally
resource "local_file" "be_private_key_pem" {
  content  = tls_private_key.be_keypair.private_key_pem
  filename = "${path.module}/${local.be_private_key_filename}"
  # file_permission      = "0400" # Secure file permissions required for SSH keys
  # directory_permission = "0700"
}
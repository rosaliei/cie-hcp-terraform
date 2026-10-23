locals {
  # Option A: the key pair is created outside Terraform (ssh-keygen).
  # Terraform only gets the PUBLIC half; the PRIVATE half lives in Secrets Manager.
  fe_key_name = "${var.frontend_prefix}-ssh-key-a"
}

resource "aws_key_pair" "fe_keypair" {
  key_name   = local.fe_key_name
  public_key = var.fe_public_key
}

# Read the private key for the provisioners' connection blocks without ever
# persisting it to plan or state (ephemeral resources need Terraform >= 1.10)
ephemeral "aws_secretsmanager_secret_version" "fe_private_key" {
  secret_id = var.fe_private_key_secret_id
}

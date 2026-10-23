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

# Option B: no local_file. With HCP remote execution it would write the key
# on the disposable agent. Retrieve it instead with:
#   terraform output -raw fe_private_key_openssh > frontend-ssh-key.pem && chmod 400 frontend-ssh-key.pem
# (see outputs.tf)
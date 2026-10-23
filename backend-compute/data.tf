# Read state from the HCP Terraform remote workspace instead of a local file path
data "terraform_remote_state" "network" {
  backend = "remote"

  # config = {
  #   # Adjust this relative path based on your actual folder structure.
  #   # Assuming fe-compute and backend-network are side-by-side in the same parent directory:
  #   path = "${path.module}/../backend-network/terraform.tfstate"
  # }
  config = {
    organization = "HelloCloud_learning"
    workspaces = {
      name = "backend-network-ws"
    }
  }
}

# Read state from the HCP Terraform remote workspace instead of a local file path
data "terraform_remote_state" "security" {
  backend = "remote"

  # config = {
  #   path = "${path.module}/../backend-security/terraform.tfstate"
  # }
  config = {
    organization = "HelloCloud_learning"
    workspaces = {
      name = "backend-security-ws"
    }
  }
}

# Read state from the HCP Terraform remote workspace instead of a local file path
data "terraform_remote_state" "network" {
  backend = "remote"

  # config = {
  #   # Adjust this relative path based on your actual folder structure.
  #   # Assuming fe-compute and frontend-network are side-by-side in the same parent directory:
  #   path = "${path.module}/../frontend-network/terraform.tfstate"
  # }
  config = {
    organization = "HelloCloud_learning"
    workspaces = {
      name = "frontend-network-ws"
    }
  }
}

# Read state from the local backend-security folder
# data "terraform_remote_state" "backend_security" {
#   backend = "local"

#   config = {
#     path = "${path.module}/../backend-security/terraform.tfstate"
#   }
# }
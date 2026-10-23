terraform {
  required_version = ">= 1.16"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  # Connect to your HCP Terraform Organization and specific workspace
  cloud {
    organization = "HelloCloud_learning"

    workspaces {
      name = "frontend-network-ws" # Match this to the exact workspace name for each folder!
    }
  }
}



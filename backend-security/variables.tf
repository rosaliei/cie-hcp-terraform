variable "region" {
  description = "The region where the resources are created."
  default     = "ap-southeast-1"
}

variable "backend_prefix" {
  description = "The prefix for the backend resources."
  default     = "backend"
}
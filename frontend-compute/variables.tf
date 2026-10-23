variable "region" {
  description = "The region where the resources are created."
  default     = "ap-southeast-1"
}

variable "frontend_prefix" {
  description = "The prefix for the frontend resources."
  default     = "frontend"
}

variable "frontend_environment" {
  description = "The environment for the frontend resources."
  default     = "dev"
}

variable "backend_prefix" {
  description = "The prefix for the backend resources."
  default     = "backend"
}

variable "fe_instance_type" {
  description = "Specifies the AWS instance type."
  default     = "t3.micro"
}

variable "fe_public_key" {
  description = "Public half of the frontend SSH key (OpenSSH format). Not a secret: set it as a normal HCP workspace variable."
  type        = string
}

variable "fe_private_key_secret_id" {
  description = "Secrets Manager secret that holds the private half of the frontend SSH key."
  default     = "/frontend/ssh/private-key"
}

#############################################################
# App Variables
#############################################################

variable "fe_placeholder" {
  default     = "placedog.net"
  description = "Image-as-a-service URL. Some other fun ones to try are fillmurray.com, placecage.com, placebeard.it, loremflickr.com, baconmockup.com, placeimg.com, placebear.com, placeskull.com, stevensegallery.com, placedog.net"
}

variable "placeholder_id" {
  default     = "2"
  description = "Image-as-a-service URL. Some other fun ones to try are fillmurray.com, placecage.com, placebeard.it, loremflickr.com, baconmockup.com, placeimg.com, placebear.com, placeskull.com, stevensegallery.com, placedog.net"
}

variable "width" {
  default     = "600"
  description = "Image width in pixels."
}

variable "height" {
  default     = "400"
  description = "Image height in pixels."
}
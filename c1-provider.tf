terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

#Set personal access token as found in Digital Ocean
variable "do_token" {
  description = "personal access token for digital ocean"
  type        = string
  default     = "REPLACE THIS SENTENCE WITH YOUR DIGITAL OCEAN ACCESS TOKEN"
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}


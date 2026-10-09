
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

variable "do_token" {
  description = "Token de acceso a DigitalOcean"
  type        = string
  sensitive   = true
}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_droplet" "backend" {
  name   = "evaluacion-backend"
  region = "nyc1"
  size   = "s-1vcpu-1gb"
  image  = "ubuntu-24-04-x64"

  tags = ["evaluacion", "devops", "backend"]
}

output "backend_ip" {
  description = "Direccion IP publica del servidor"
  value       = digitalocean_droplet.backend.ipv4_address
}

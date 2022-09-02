terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.20.0"
    }
  }
}

provider "docker" {

}

resource "docker_image" "nodered_image" {
  name = "nodered/node-red:latest"
}

resource "random_string" "random" {
  count = 1
  length  = 4
  special = false
  upper   = false
}

resource "docker_container" "nodered_container" {
  name  = join("-", ["nodered", random_string.random[count.index].result])
  image = docker_image.nodered_image.repo_digest
  count = 1
  ports {
    internal = 1880
    #external = 1880
  }
}

output "IPAddress" {
  value       = [for i in docker_container.nodered_container[*]: join(":", [i.network_data[0].ip_address, i.ports[0].external])]
  description = "IP Address of the container"
}

output "container-name" {
  value       = docker_container.nodered_container[*].name
  description = "Name of the container"
}

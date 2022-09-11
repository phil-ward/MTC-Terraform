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

resource "null_resource" "dockervol" {
  provisioner "local-exec" {
    command = "mkdir noderedvol/ || true && sudo chown -R 1000:1000 noderedvol/ && sudo chmod 777 noderedvol/"
  }
}

resource "docker_image" "nodered_image" {
  name = lookup(var.image, var.env)
}

resource "random_string" "random" {
  count   = local.container_count
  length  = 4
  special = false
  upper   = false
}

resource "docker_container" "nodered_container" {
  name  = join("-", ["nodered", random_string.random[count.index].result])
  image = docker_image.nodered_image.repo_digest
  count = local.container_count
  ports {
    internal = var.int_port
    external = lookup(var.ext_port, var.env)[count.index]
  }
  volumes {
    container_path = "/data"
    host_path = "${path.cwd}/noderedvol"
  }
}

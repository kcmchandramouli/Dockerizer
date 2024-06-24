#Required Plugins
packer {
  required_plugins {
    ## Docker Plugin
    docker = {
      version = ">= 0.0.7"
      source  = "github.com/hashicorp/docker"
    }
    ## Ansible Plugin
    ansible = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

#Source
source "docker" "ubuntu" {
  image  = "ubuntu:20.04"
  commit = true
}

#Build 
build {
  sources = ["source.docker.ubuntu"]

  ## provisioner used to install something 
  provisioner "shell" {
    inline = [
      "apt-get update",
      "apt-get install -y sudo python3",
      "echo 'Vim has been installed!' > /root/install-log.txt"
    ]
  }

  provisioner "ansible" {
    playbook_file = "./playbook.yml"
    extra_arguments = ["--become"]
  }

  ## post-processor is for doing somethingafter after build. Here we are creating name & tage for the created docker image.
  post-processor "docker-tag" {
    repository = "my-docker-vim-image"
    tags       = ["latest"]
  }
}

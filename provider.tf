terraform {
    required_providers {
        docker = {
            source  = "kreuzwerker/docker"
            version = "3.0.2"
        }

        digitalocean = {
            source  = "digitalocean/digitalocean"
            version = "2.26.0"
        }

        local = {
            source  = "hashicorp/local"
            version = "2.4.0"
        }
    }
}

provider "docker" {
    host = "tcp://your-host-ip:2376/"
    cert_path = pathexpand("~/.docker")
}

provider "digitalocean" {
    token = var.do_token
}

provider local { }
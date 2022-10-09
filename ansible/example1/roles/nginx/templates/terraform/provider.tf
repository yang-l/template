terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.22.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

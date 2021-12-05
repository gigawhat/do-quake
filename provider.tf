terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "3.4.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "2.1.0"
    }
  }
  backend "remote" {
    hostname     = "keife-lab.scalr.io"
    organization = "env-tngeqhukniectbg"
    workspaces {
      name = "do-quake"
    }
  }
}

provider "digitalocean" {}

provider "random" {}

provider "cloudflare" {}

provider "http" {}

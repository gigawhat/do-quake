locals {
  # home_ip      = jsondecode(data.http.ip.body).origin
  cf_zone_name = "keife.org"
  inbound_rules = {
    http = {
      port_range       = "8080"
      protocol         = "tcp"
      source_addresses = ["0.0.0.0/0", "::/0"]
    }
  }
  outbound_rules = {
    icmp = {}
    tcp = {
      port_range = "all"
    }
    udp = {
      port_range = "all"
    }
  }
}

data "cloudflare_zones" "this" {
  filter {
    name = local.cf_zone_name
  }
}

# data "http" "ip" {
#   url = "http://httpbin.org/ip"
#   request_headers = {
#     Accept = "application/json"
#   }
# }

resource "random_pet" "this" {}

resource "digitalocean_firewall" "this" {
  name = "quaky"
  tags = ["quaky"]

  dynamic "inbound_rule" {
    for_each = local.inbound_rules
    content {
      protocol         = inbound_rule.value["protocol"]
      port_range       = inbound_rule.value["port_range"]
      source_addresses = inbound_rule.value["source_addresses"]
    }
  }

  dynamic "outbound_rule" {
    for_each = local.outbound_rules
    content {
      protocol              = outbound_rule.key
      port_range            = try(outbound_rule.value["port_range"], null)
      destination_addresses = try(outbound_rule.value["destination_addresses"], ["0.0.0.0/0", "::/0"])
    }
  }
}

resource "digitalocean_droplet" "this" {
  image     = "ubuntu-20-04-x64"
  name      = random_pet.this.id
  region    = "sfo3"
  size      = "s-1vcpu-1gb"
  tags      = ["quaky", "ssh"]
  ssh_keys  = [24072603]
  user_data = file("${path.module}/files/user-data.yaml")
}

resource "cloudflare_record" "this" {
  zone_id = lookup(data.cloudflare_zones.this.zones[0], "id")
  name    = "quake"
  value   = digitalocean_droplet.this.ipv4_address
  type    = "A"
  proxied = false
  ttl     = 60
}

output "droplet_ip" {
  value = digitalocean_droplet.this.ipv4_address
}

# output "home_ip" {
#   value = local.home_ip
# }

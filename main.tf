module "do_quake" {
  source               = "github.com/gigawhat/terraform-digitalocean-quake?ref=v1.0.0"
  cloudflare_zone_name = "keife.org"
}

output "quake_url" {
  value = module.do_quake.quake_url
}

module "do_quake" {
  source               = "git@github.com:gigawhat/terraform-digitalocean-quake.git?ref=v1.0.0"
  cloudflare_zone_name = "keife.org"
}

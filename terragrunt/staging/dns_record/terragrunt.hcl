include "root" {
  path = find_in_parent_folders()
}

locals {
    env_vars = read_terragrunt_config(find_in_parent_folders("environment_specific.hcl"))
    repo_vars = read_terragrunt_config(find_in_parent_folders("repo_specific.hcl"))
}

dependency "dns_zone" {
  config_path = "../dns_zone"
}

terraform {
  source = "git::https://github.com/InWithTheNew/terraform_modules.git//dns_record?ref=v0.0.1"
}

inputs = {
    rg_name = dependency.dns_zone.outputs.primary_dns_resource_group
    name = "testing"
    domain_name = dependency.dns_zone.outputs.primary_dns_zone_name
    target = "google.com"
    tags = {
        repository = "${local.repo_vars.locals.repository_url}"
        environment = "${local.env_vars.locals.environment_name}"
        path = "${get_path_from_repo_root()}"
        production = "${local.env_vars.locals.is_production}"
    }
}
include "root" {
  path = find_in_parent_folders()
}

locals {
    env_vars = read_terragrunt_config(find_in_parent_folders("environment_specific.hcl"))
    repo_vars = read_terragrunt_config(find_in_parent_folders("repo_specific.hcl"))
}

terraform {
  # source = "../../../../terraform_modules/kubernetes"
    source = "git::https://github.com/InWithTheNew/terraform_modules.git//kubernetes?ref=v0.0.2"
}

dependency "dns_zone" {
  config_path = "../dns_zone"
}

inputs = {
    name ="${local.env_vars.locals.environment_name}-cluster"
    dns_rg_name = dependency.dns_zone.outputs.primary_dns_resource_group
    kubernetes_rg_name = "${local.env_vars.locals.environment_name}-kubernetes-rsg"
    kubernetes_storage_rg_name = "${local.env_vars.locals.environment_name}-kubernetes-storage-rsg"
    location = "uksouth"
    namespaces = ["a", "b"]
    primary_domain_name = dependency.dns_zone.outputs.primary_dns_zone_name
    tags = {
        repository = "${local.repo_vars.locals.repository_url}"
        environment = "${local.env_vars.locals.environment_name}"
        path = "${get_path_from_repo_root()}"
        production = "${local.env_vars.locals.is_production}"
    }
}
include "root" {
  path = find_in_parent_folders()
}

locals {
    env_vars = read_terragrunt_config(find_in_parent_folders("environment_specific.hcl"))
    repo_vars = read_terragrunt_config(find_in_parent_folders("repo_specific.hcl"))
}

terraform {
  # source = "../../../../terraform_modules/dns_zone"
  source = "git::https://github.com/InWithTheNew/terraform_modules.git//dns_zone?ref=v0.0.1"
}

inputs = {
    rg_name = "${local.env_vars.locals.environment_name}-dns"
    domain_name = "${local.env_vars.locals.environment_name}.amand.dev"
    location = "uksouth"
    tags = {
        repository = "${local.repo_vars.locals.repository_url}"
        environment = "${local.env_vars.locals.environment_name}"
        path = "${get_path_from_repo_root()}"
        production = "${local.env_vars.locals.is_production}"
    }
}
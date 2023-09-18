locals {
    # Get Project Name
    env_config = read_terragrunt_config(find_in_parent_folders("environment_specific.hcl"))
    environment_name = local.env_config.locals.environment_name
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  cloud {
    organization = "adams-company"

    workspaces {
        name = "shared-services-${replace((get_path_from_repo_root()), "/", "-")}"
        # name = "shared-services-${local.environment_name}-${basename(dirname(get_original_terragrunt_dir()))}"
    }
  }
}

EOF
}

terraform {
#   source = "git::git@github.com:foo/modules.git//app?ref=v0.0.3"
}

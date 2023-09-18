locals {
    environment_name = "${basename((get_path_from_repo_root()))}"
    is_production = "${local.environment_name == "prod" ? "true" : "false"}"
}

dependency "secret-opsman" {
  config_path = "../../0_secrets/secret-opsman"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    opsman_password = "fake"

  }
}

dependency "paving" {
  config_path = "../../2_paving"
  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    ops_manager_dns = "fake"
    ops_manager_ssh_private_key = "fake"
    stable_config = "fake"

  }
}

dependencies {
  paths = ["../opsman-compute", "../opsman-setup-scripts"]
}


terraform {

  source = "git::git@github.com:abhinavrau/tanzify-infrastructure.git//opsman/opsman-install-configure"
  extra_arguments "vars" {
    commands  = get_terraform_commands_that_need_vars()

    optional_var_files = [
      "${get_terragrunt_dir()}/terraform.tfvars",
      "${get_terragrunt_dir()}/../../env.tfvars",
      "${get_terragrunt_dir()}/../../../region.tfvars",
      "${get_terragrunt_dir()}/../../../../_global/terraform.tfvars"
    ]
  }
}

inputs = {

  opsman_password = dependency.secret-opsman.outputs.opsman_password

  ops_manager_dns = dependency.paving.outputs.ops_manager_dns
  ops_manager_ssh_private_key = dependency.paving.outputs.ops_manager_ssh_private_key
  opsman_configuration_values = dependency.paving.outputs.stable_config

  ssl_cert = dependency.paving.outputs.ssl_certificate
  ssl_private_key = dependency.paving.outputs.ssl_private_key

}
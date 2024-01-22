terraform {
  required_providers {
    prefect = {
      source = "prefecthq/prefect"
    }
  }
}

# By default, the provider points to Prefect Cloud
# and you can pass in your API key and account ID
# via variables or static inputs.
# provider "prefect" {
#   api_key    = var.prefect_api_key
#   account_id = var.prefect_account_id
# }

# You can also pass in your API key and account ID
# implicitly via environment variables, such as
# PREFECT_CLOUD_API_KEY and PREFECT_CLOUD_ACCOUNT_ID.
# provider "prefect" {}

# You also have the option to link the provider instance
# to your specific workspace, if this fits your use case.
provider "prefect" {
  api_key      = var.prefect_api_key
  account_id   = var.prefect_account_id
  workspace_id = var.prefect_workspace_id
}

resource "prefect_work_pool" "sample1" {
  description  = "Create work pool"
  name         = "sample1"
  type         = "prefect agent"
  paused       = false
  workspace_id = var.prefect_workspace_id
}

resource "prefect_work_pool" "sample2" {
  description  = "Create work pool then execute local script"
  name         = "sample2-"
  type         = "prefect agent"
  paused       = false
  workspace_id = var.prefect_workspace_id

  provisioner "local-exec" {
    command = "./sample.sh ${prefect_work_pool.sample2.id}"
  }
}

resource "prefect_work_pool" "sample3" {
  description  = "Create work pool then execute remote script"
  name         = "sample3"
  type         = "prefect agent"
  paused       = false
  workspace_id = var.prefect_workspace_id

  # scp local file to remote
  provisioner "file" {
    source      = "./sample-remote-script"
    destination = "/tmp/sample-remote-script"
    connection {
      type        = "ssh"
      user        = var.ssh_tunnel_user
      private_key = file(var.ssh_tunnel_key_file)
      host        = var.ssh_tunnel_host
    }
  }

  # Execute remote script
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/sample-remote-script",
      "/tmp/sample-remote-script ${var.prefect_cli_remote}"
    ]
    connection {
      type        = "ssh"
      user        = var.ssh_tunnel_user
      private_key = file(var.ssh_tunnel_key_file)
      host        = var.ssh_tunnel_host
    }
  }
}

# Finally, in rare occasions, you also have the option
# to point the provider to a locally running Prefect Server,
# with a limited set of functionality from the provider.
# provider "prefect" {
#   endpoint = "http://localhost:4200"
# }
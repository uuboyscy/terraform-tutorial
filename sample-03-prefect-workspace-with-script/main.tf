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
    source      = "./sample-remote-script.sh"
    destination = "/tmp/sample-remote-script.sh"
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
      "chmod +x /tmp/sample-remote-script.sh",
      "/tmp/sample-remote-script.sh ${var.prefect_cli_remote}"
    ]
    connection {
      type        = "ssh"
      user        = var.ssh_tunnel_user
      private_key = file(var.ssh_tunnel_key_file)
      host        = var.ssh_tunnel_host
    }
  }
}

resource "prefect_work_pool" "sample4" {
  description  = "Create work pool then create work queue via remote script"
  name         = "sample4"
  type         = "prefect agent"
  paused       = false
  workspace_id = var.prefect_workspace_id

  # scp local file to remote
  provisioner "file" {
    source      = "./create-work-queue.sh"
    destination = "/tmp/create-work-queue.sh"
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
      "chmod +x /tmp/create-work-queue.sh",
      "/tmp/create-work-queue.sh ${var.prefect_cli_remote} ${var.prefect_profile} ${self.name} docker"
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
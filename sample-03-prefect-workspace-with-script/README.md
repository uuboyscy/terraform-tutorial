## Using provisioner to execute commands

### What is provisioner
In Terraform, a provisioner is a configuration block that defines actions to take on a resource either during its creation, destruction, or after its creation. Provisioners are used for system setup, performing actions on the local machine or on a remote machine, or for triggering actions in external systems.

### Configuration

1. Execute single command on local machine\
    sample.sh would be executed locally after creation of resource 

    ```"prefect_work_pool" "sample2"```

    sample.sh
    ```shell
    #!/bin/sh
    echo "Work Pool $1 effected." 
    ```

    Example in main.tf
    ```hcl
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
    ```

2. Execute script on remote machine\
    sample-remote-script.sh would be copied to remote machine to be executed

    sample-remote-script.sh
    ```shell
    #!/bin/bash

    PREFECT_CLI=$1
    PREFECT_VERSION=$($PREFECT_CLI version)
    echo "$PREFECT_VERSION"
    echo "test"
    ```

    Example in main.tf
    ```hcl
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
    ```

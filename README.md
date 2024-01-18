# Install Terraform using Docker image

Using Docker to run Terraform can be a very flexible and clean way to manage your infrastructure as code, especially when dealing with multiple projects or different Terraform versions.

1. Pull the Terraform Docker Image\
    First, you need to pull the official Terraform Docker image from Docker Hub. Open your terminal and run:

    ```sh
    docker pull hashicorp/terraform:latest
    ```

    This command downloads the latest Terraform image.

2. Run Terraform with Docker\
    You can now run Terraform commands using this Docker image. To ensure that your Terraform configurations and state files are preserved, you should mount a local directory to the Docker container.

    For example, if you have a Terraform project in a directory called my-terraform-project on your local machine, you can run the terraform init command in that directory like this:

    ```sh
    docker run -v /var/run/docker.sock:/var/run/docker.sock -v $(pwd)/my-terraform-project:/terraform -w /terraform hashicorp/terraform:latest init
    ```

    This command mounts your my-terraform-project directory to /terraform in the container and sets the working directory to /terraform. The terraform init command is then executed in this context.

3. Alias for Convenience\
    To avoid typing long Docker commands every time, you can create an alias in your shell. For example, in bash, you can add the following line to your .bashrc or .bash_profile:

    ```sh
    alias terraform="docker run -it -v /var/run/docker.sock:/var/run/docker.sock -v $(pwd):/terraform -w /terraform hashicorp/terraform:latest"
    ```

    After adding this alias and reloading your shell configuration, you can simply use terraform init, terraform plan, terraform apply, etc., as if Terraform were installed locally.

4. Running Specific Terraform Commands\
    You can run any Terraform command using this method. Just replace init with the desired Terraform command in the Docker command. For example, to apply your configuration, you would use:

    ```sh
    terraform apply
    ```

5. Considerations
    - Version Control: If you need a specific version of Terraform, you can pull a specific tag from the Docker Hub instead of latest.
    - State Files and Credentials: Be cautious with sensitive data such as Terraform state files and cloud provider credentials. Ensure they are securely managed and not exposed.
    - File Permissions: Sometimes, files created by Docker (running as root by default) can have permissions that make them difficult to manage from your host machine. Adjust permissions as necessary.


# Test sample

1. [Basic example with NGINX](/sample-01-nginx/README.md)
2. [Manage variables](/sample-02-gcp-with-variables/README.md)

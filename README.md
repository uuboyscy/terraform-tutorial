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


# Test official sample

1. Initialize the project
    Which downloads a plugin called a provider that lets Terraform interact with Docker.

    ```sh
    terraform init
    ```

    Then you will see the following message:

    ```text
    Initializing the backend...

    Initializing provider plugins...
    - Finding kreuzwerker/docker versions matching "~> 3.0.1"...
    - Installing kreuzwerker/docker v3.0.2...
    - Installed kreuzwerker/docker v3.0.2 (self-signed, key ID BD080C4571C6104C)

    Partner and community providers are signed by their developers.
    If you'd like to know more about provider signing, you can read about it here:
    https://www.terraform.io/docs/cli/plugins/signing.html

    Terraform has created a lock file .terraform.lock.hcl to record the provider
    selections it made above. Include this file in your version control repository
    so that Terraform can guarantee to make the same selections by default when
    you run "terraform init" in the future.

    Terraform has been successfully initialized!

    You may now begin working with Terraform. Try running "terraform plan" to see
    any changes that are required for your infrastructure. All Terraform commands
    should now work.

    If you ever set or change modules or backend configuration for Terraform,
    rerun this command to reinitialize your working directory. If you forget, other
    commands will detect it and remind you to do so if necessary.
    ```

2. Procision the NGINX server via main.tf with ```apply```
    When Terraform asks you to confirm type ```yes``` and predd ```ENTER```.

    ```sh
    terraform apply
    ```
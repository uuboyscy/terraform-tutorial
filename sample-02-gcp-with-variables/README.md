1. Manage variable in ```terraform.auto.tfvars```\
    Variables can be managed in ```terraform.auto.tfvars``` file

    ```hcl
    # contents of terraform.auto.tfvars
    aws_region = "us-west-1`"
    project_name = "my_project"
    instance_type = "t2.micro"`
    ```

2. Create ```variables.tf```
    Variables defined in ```variables.tf``` would be automatically loaded when execute ```terraform plan``` or ```terraform apply```

    ```hcl
    variable "gcp_credential" {
        description = "gcp_credential"
    }
    variable "gcp_project" {
        description = "gcp_project"
    }
    variable "gcp_region" {
        description = "gcp_region"
    }
    variable "gcp_zone" {
        description = "gcp_zone"
    }
    ```
    

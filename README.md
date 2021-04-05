Description
=========

Provision an EKS Cluster (AWS)

Install Terraform before using: [terraform instalation](https://learn.hashicorp.com/terraform/getting-started/install.html)

Requirements
------------

Basic aws cli configuration:

- $ aws configure
- AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
- AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
- Default region name [None]: us-west-2
- Default output format [None]: json


Terraform Backend Configuration
----------------

Main.tf defines ussing AWS S3 Bucket as storage for terraform.tfstate
S3 bucket needs to be created before:

Run
----------------

- $ terraform init  - download plagins
- $ terraform plan  - launch a plan to see what actions will be performed
- $ terraform apply - directly creating the resources described in main.tf

Destroy
----------------

Before destroing aws_s3_bucket.tf_backend need to be removed from resources list:

#list all resources
- $ terraform state list

#remove that resource you don't want to destroy
#you can add more to be excluded if required
- $ terraform state rm <resource_to_be_deleted> 

#destroy the whole stack except above excluded resource(s)
- $ terraform destroy 

License
-------

BSD-3-Clause (default)

Author Information
------------------

Sample provisioning role created by Oleksandr Kyktenko. 

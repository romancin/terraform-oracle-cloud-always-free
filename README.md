terraform-oracle-cloud-always-free
==================================

This Terraform module provisions 2 OCI instances using Oracle Cloud's Always Free services: https://www.oracle.com/cloud/free/

Also, this repo now includes an Ansible playbook you optionally can use to install docker on both instances, including also portainer installation.

Variables
=========

region = Region where instances will be deployed ("eu-frankfurt-1" by default).

vcn_dns_label = The label you want to use for your DNS.

Most types of Oracle Cloud Infrastructure resources have an Oracle-assigned unique ID called an Oracle Cloud Identifier (OCID). It's included as part of the resource's information in both the Console and API.

Check the documentation to see how can you extract this values from your account: https://docs.cloud.oracle.com/en-us/iaas/Content/General/Concepts/identifiers.htm

tenancy_ocid = ""

compartment_ocid = ""

And for authentication objects: https://docs.cloud.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm

private_key_path = ""

user_ocid = ""

fingerprint = ""

Execution
=========

1.- ```terraform init```

2.- Take terraform.tfvars file in the repo and fill it with your own data

3.- ```terraform plan```

4.- ```terraform apply```

5.- To install docker with portainer on the provisioned instances, execute:

```
ansible-playbook -i inventory install-docker.yml
```

6.- To install only docker without portainer, execute:

```
ansible-playbook -i inventory install-docker.yml -e install_portainer=false
```
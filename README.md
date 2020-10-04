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

4.- Optional: If you are going to deploy traefik + portainer, it is time to take the Terraform outputs (Public IP of the instances) and create 2 DNS entries for each of them:
For example:
```
cloudserver1.mydomain.com. 0	A	1.1.1.1
cloudserver2.mydomain.com. 0	A	2.2.2.2
*.cloudserver1.mydomain.com. 0	CNAME	cloudserver1.mydomain.com.
*.cloudserver2.mydomain.com. 0	CNAME	cloudserver2.mydomain.com.
```
In my case, the main domain is pointing to another traefik, so I need to give an entire new subdomain to traefik running on the public cloud instances. This way, every host label under *.cloudserver1.mydomain.com will be exposed by traefik, and routed to the container where the service is running.

Feel free to adapt it to your own configuration.

5.- To install only docker, execute:

```
ansible-playbook -i inventory install-docker.yml -e install_traefik_and_portainer=false
```

6.- To install only docker with portainer, execute:

```
ansible-playbook -i inventory install-docker.yml -e install_portainer=true
```

7.- To install docker with traefik and portainer, execute:

```
ansible-playbook -i inventory install-docker.yml
```
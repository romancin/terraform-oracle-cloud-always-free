terraform {
  required_version = ">= 0.12.0"
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

locals  {
  images = {
    eu-frankfurt-1 =	"ocid1.image.oc1.eu-frankfurt-1.aaaaaaaawnnvmhojtfjvmsxuklektxhpmfhbofn4zunbv7waqmmf7z3oteba" # Ubuntu 20.04 image
  }
  
  instance_shape = "VM.Standard.E2.1.Micro"

  availability_domain = [for limit in data.oci_limits_limit_values.limit_values : limit.limit_values[0].availability_domain if limit.limit_values[0].value > 0 ]

  common_tags = {
    Reference = "Created with Terraform module for Oracle Cloud always-free tier"
  }

}
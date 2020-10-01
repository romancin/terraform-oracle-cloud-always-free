# Copyright (c) 2019 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 
variable "tenancy_ocid" {
  default = ""
}

variable "region" {
  default = "eu-frankfurt-1"
}

variable "compartment_ocid" {
  default = ""
}

variable "user_ocid" {
  default = ""
}

variable "fingerprint" {
  default = ""
}

variable "private_key_path" {
  default = ""
}

variable "vcn_dns_label" {
  default = ""
}

variable "instance_image" {
  default = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaawnnvmhojtfjvmsxuklektxhpmfhbofn4zunbv7waqmmf7z3oteba" # Ubuntu 20.04 image
}

variable "boot_volume_size_in_gbs" {
  default = 50
}
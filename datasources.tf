# Gets a list of Availability Domains
data "oci_identity_availability_domains" "ADs" {
  compartment_id = var.tenancy_ocid
}

data "oci_objectstorage_namespace" "user_namespace" {
  compartment_id = var.compartment_ocid
}

data "oci_limits_services" "limit_services" {
  compartment_id = var.tenancy_ocid

  filter {
    name   = "name"
    values = ["compute"]
  }
}

data "oci_limits_limit_values" "limit_values" {
  count          = length(data.oci_identity_availability_domains.ADs.availability_domains)
  compartment_id = var.tenancy_ocid
  service_name   = data.oci_limits_services.limit_services.services.0.name

  availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[count.index].name
  name                = "vm-standard-e2-1-micro-count"
  scope_type          = "AD"
}

# Network resources
resource "oci_core_vcn" "always-free-VCN" {
  cidr_block     = "10.1.0.0/16"
  compartment_id = var.compartment_ocid
  dns_label      = var.vcn_dns_label
  display_name   = "always-free-VCN"
  freeform_tags  = local.common_tags
}

resource "oci_core_subnet" "always-free-Subnet" {
  cidr_block        = "10.1.21.0/24"
  display_name      = "always-free-Subnet"
  dns_label         = var.vcn_dns_label
  security_list_ids = [oci_core_security_list.always-free-SecurityList.id]
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_vcn.always-free-VCN.id
  route_table_id    = oci_core_route_table.always-free-RT.id
  dhcp_options_id   = oci_core_vcn.always-free-VCN.default_dhcp_options_id
  freeform_tags     = local.common_tags
}

resource "oci_core_internet_gateway" "always-free-IG" {
  compartment_id = var.compartment_ocid
  display_name   = "always-free-IG"
  vcn_id         = oci_core_vcn.always-free-VCN.id
  freeform_tags  = local.common_tags
}

resource "oci_core_route_table" "always-free-RT" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.always-free-VCN.id
  display_name   = "always-free-Subnet-RT"
  freeform_tags  = local.common_tags

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.always-free-IG.id
  }
}

# Security lists
resource "oci_core_security_list" "always-free-SecurityList" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.always-free-VCN.id
  display_name   = "always-free-Subnet-SL"
  freeform_tags  = local.common_tags

  egress_security_rules {
      protocol    = "6"
      destination = "0.0.0.0/0"
    }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "80"
      min = "80"
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "443"
      min = "443"
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "9000"
      min = "9000"
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "22"
      min = "22"
    }
  }
}

# Create SSH keys
resource "tls_private_key" "oci-instances-ssh-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "oci-instances-ssh-key" { 
  filename = "${path.module}/oci-instances-ssh-key.pem"
  content = tls_private_key.oci-instances-ssh-key.private_key_pem
  file_permission = 0600
}

# Computing resources
resource "oci_core_instance" "oci-instance-1" {
  availability_domain = local.availability_domain[0]
  compartment_id      = var.compartment_ocid
  display_name        = "oci-instance-1"
  shape               = local.instance_shape
  freeform_tags       = local.common_tags

  create_vnic_details {
    subnet_id        = oci_core_subnet.always-free-Subnet.id
    display_name     = "primaryvnic"
    assign_public_ip = true
    hostname_label   = "oci-instance-1"
  }

  source_details {
    source_type = "image"
    source_id   = local.images[var.region]
    boot_volume_size_in_gbs = var.boot_volume_size_in_gbs
  }

  metadata = {
    ssh_authorized_keys = tls_private_key.oci-instances-ssh-key.public_key_openssh
  }
  
}

resource "oci_core_instance" "oci-instance-2" {
  availability_domain = local.availability_domain[0]
  compartment_id      = var.compartment_ocid
  display_name        = "oci-instance-2"
  shape               = local.instance_shape
  freeform_tags       = local.common_tags

  create_vnic_details {
    subnet_id        = oci_core_subnet.always-free-Subnet.id
    display_name     = "primaryvnic"
    assign_public_ip = true
    hostname_label   = "oci-instance-2"
  }

  source_details {
    source_type = "image"
    source_id   = local.images[var.region]
    boot_volume_size_in_gbs = var.boot_volume_size_in_gbs
  }

  metadata = {
    ssh_authorized_keys = tls_private_key.oci-instances-ssh-key.public_key_openssh
  }
  
}

resource "local_file" "AnsibleInventory" {
 content = templatefile("inventory.tmpl",
 {
  oci-instance-1-ip = oci_core_instance.oci-instance-1.public_ip,
  oci-instance-2-ip = oci_core_instance.oci-instance-2.public_ip
 }
 )
 filename = "inventory"
}

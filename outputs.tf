output "comment" {
  value = "Here you have the public IP addresses of the instances you have just created. Connect to them using ubuntu user and the SSH private key file called oci-instances-ssh-key.pem generated in the directory where you have your Terraform code."
}

output "sample-command" {
  value = "For example: ssh -i oci-instances-ssh-key.pem ubuntu@your-public-ip"
}

output "instance-1-public-ip" {
  value = oci_core_instance.oci-instance-1.*.public_ip
}

output "instance-2-public-ip" {
  value = oci_core_instance.oci-instance-2.*.public_ip
}

# Generate a local RSA key
resource "tls_private_key" "local-key" {
  algorithm = "RSA"
  rsa_bits = 4096
}

# Create key pair in AWS
resource "aws_key_pair" "aws-key-pair" {
  key_name = var.key-name
  public_key = tls_private_key.local-key.public_key_openssh

# You can save the key permanently (after terraform destroys the key_pair resource) using local-exec but that's useless because it's already destroyed.
#   provisioner "local-exec" {
#     command = "echo '${tls_private_key.pk.private_key_pem}' > ~/Desktop/Terraform/my-tf-key.pem"
#   }
}

# Save the private key to a file locally (will be destroyed with the key_pair resource)
resource "local_file" "private_key" {
  content  = tls_private_key.local-key.private_key_pem
  filename = "${path.cwd}/${var.key-name}.pem"
}

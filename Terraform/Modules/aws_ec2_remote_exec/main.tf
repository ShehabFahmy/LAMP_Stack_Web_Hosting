# Task 1
# Create a resource of type EC2 instance and
#   of name "aws-linux-instance"
resource "aws_instance" "aws-linux-instance" {
  ami                    = var.aws-linux-instance-ami
  instance_type          = var.instance-type
  key_name               = var.key-name
  subnet_id              = var.subnet-id
  vpc_security_group_ids = [var.secgrp-id]
  # Ensure the instance gets a public IP if it is public
  associate_public_ip_address = var.is-public
  
  # Remote-exec to install nginx
  provisioner "remote-exec" {
    inline = [var.remote-exec-inline]
    connection {
      type        = "ssh"
      user        = var.ssh-user
      private_key = file(var.private-key-path)
      host        = self.public_ip
    }
  }

  tags = var.tags
}

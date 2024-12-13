module "vpc" {
  source     = "./Modules/vpc"
  name       = "lamp-stack-vpc"
  cidr-block = "10.0.0.0/16"
  created-by = var.me
}

module "pb-subnet" {
  source            = "./Modules/subnet"
  name-and-cidr     = ["lamp-stack-pb-subnet", "10.0.0.0/24"]
  availability-zone = "us-east-1a"
  created-by        = var.me
  vpc-id            = module.vpc.id
}

module "igw" {
  source     = "./Modules/internet_gateway"
  name       = "lamp-stack-igw"
  created-by = var.me
  vpc-id     = module.vpc.id
}

module "pb-rtb" {
  source     = "./Modules/public_route_table"
  name       = "lamp-stack-pb-rtb"
  created-by = var.me
  vpc-id     = module.vpc.id
  igw-id     = module.igw.id
}

module "public-associations" {
  source     = "./Modules/route_table_association"
  subnet-ids = [module.pb-subnet.id]
  rtb-id     = module.pb-rtb.id
}

module "key-pair" {
  source   = "./Modules/key_pair"
  key-name = "lamp-stack-key-pair"
}

module "ec2-secgrp" {
  source      = "./Modules/security_group"
  secgrp-name = "lamp-stack-secgrp"
  created-by  = var.me
  # Ingress rules:
  # - Allow HTTP traffic on port 80 from anywhere.
  # - Allow SSH access on port 22 from my public IP only (for troubleshooting).
  ingress-data = [{ from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], security_groups = [] },
  { from_port = 22, to_port = 22, protocol = "tcp", cidr_blocks = ["${trimspace(data.http.my-public-ip.response_body)}/32"], security_groups = [] }]
  egress-data = [{ from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }]
  vpc-id      = module.vpc.id
}

module "ec2-web-server" {
  source                 = "./Modules/aws_ec2_remote_exec"
  aws-linux-instance-ami = "ami-0e2c8caa4b6378d8c"
  instance-type          = "t2.micro"
  key-name               = module.key-pair.key-name
  private-key-path       = module.key-pair.private-key-path
  is-public              = true
  subnet-id              = module.pb-subnet.id
  secgrp-id              = module.ec2-secgrp.id
  ssh-user               = "ubuntu"
  tags = {
    Name       = "php-web-server"
    Created_by = var.me
  }
  remote-exec-inline = <<-EOF
    #!/bin/bash

    sudo apt-get update
    sudo apt-get install apache2 mysql-server php libapache2-mod-php php-mysql -y

    echo -e "Y\n0\nY\nn\nY\nY\n" | sudo mysql_secure_installation

    DB_PASSWORD=${file("../Vagrant/Secrets/DB_PASSWORD.txt")}
    sudo mysql -e " \
    ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$DB_PASSWORD'; \
    FLUSH PRIVILEGES;"

    DB_USER_PASSWORD=${file("../Vagrant/Secrets/DB_USER_PASSWORD.txt")}
    sudo mysql -u root -p$DB_PASSWORD -e " \
    CREATE DATABASE web_db; \
    CREATE USER 'web_user'@'localhost' IDENTIFIED BY '$DB_USER_PASSWORD'; \
    GRANT ALL PRIVILEGES ON web_db.* TO 'web_user'@'localhost'; \
    FLUSH PRIVILEGES;"

    sudo mysql -u root -p$DB_PASSWORD web_db <<EOT
    ${file("../Vagrant/db_schema.sql")}
    EOT

    sudo rm /var/www/html/index.html

    # Copy index.php and change configuration file path
    sudo tee /var/www/html/index.php > /dev/null <<'EOT'
    ${file("../Vagrant/index.php")}
    EOT
    sudo sed -i "s|'/vagrant/Secrets/db_config.php'|'./db_config.php'|" /var/www/html/index.php

    # Copy db_config.php and change user's password file path
    sudo tee /var/www/html/db_config.php > /dev/null <<'EOT'
    ${file("../Vagrant/Secrets/db_config.php")}
    EOT
    sudo sed -i "s|'/vagrant/Secrets/DB_USER_PASSWORD.txt'|'./DB_USER_PASSWORD.txt'|" /var/www/html/db_config.php

    # Create a file that includes the user password, to be used in db_config.php
    echo $DB_USER_PASSWORD | sudo tee /var/www/html/DB_USER_PASSWORD.txt > /dev/null

    sudo systemctl restart apache2
  EOF
}

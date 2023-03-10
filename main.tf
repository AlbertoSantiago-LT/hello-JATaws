terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-0b752bf1df193a6c4"
  instance_type = "t2.micro"
  security_groups = [
    "sg-077c7042ad8a28b0e"
  ]
  subnet_id = "subnet-0683452f925bf774f"
  key_name  = "clave-lucatic"
  #1 user_data = file("init.sh")
  tags = {
    Name = "TerraformInstancia"
    APP  = "vue2048"
    # Name = var.instance_name
  }
  #  provisioner "local-exec" {
  #    working_dir = "ansible"
  #    command     = "ansible-playbook -i aws_ec2.yml httpd.yml"
  #   }
}

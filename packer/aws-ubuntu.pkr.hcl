packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "region" {
  type        = string
  description = "The AWS region to create resources in."
  default     = "us-west-2"
}
variable "instance_type" {}
variable "tag" {}
variable "environment" {}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "${var.tag}-${var.environment}-${local.timestamp}"
  instance_type = "${var.instance_type}"
  region        = "${var.region}"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
      architecture = "x86_64"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  name    = "${var.tag}-${var.environment}"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "shell" {
    environment_vars = [
     "FOO=hello world",
    ]
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y curl unzip",
      "sudo apt-get install -y systemd",
      "curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip",
      "unzip awscliv2.zip",
      "sudo ./aws/install"
    ]
  }

  provisioner "shell" {
    inline = [
      "########echo check aws",
      "aws --version"
      ]
  }
  provisioner "shell" {
    inline = [
      "########echo install nginx",
      "sudo apt-get install -y nginx ",
      "nginx -V"
      ]
  }
  provisioner "shell" {
    inline = [
      "echo ###################",
      "cat /etc/nginx/nginx.conf",
      "echo ###################"
      ]
  }
}



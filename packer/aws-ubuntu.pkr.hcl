packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "learn-packer-linux-aws3"
  instance_type = "t2.micro"
  region        = "us-west-2"
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
  name    = "learn-packer"
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



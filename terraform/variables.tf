variable "tag" {
  type        = string
  description = "prefix for AWS resources"
  default     = "bestseller"
}

variable "environment" {
  type        = string
  description = "prefix for AWS resources"
  default     = "prod"
}

variable "region" {
  type        = string
  description = "The AWS region to create resources in."
  default     = "us-west-2"
}

#network
variable "public_subnet_1_cidr" {
  description = "CIDR Block for Public Subnet 1"
  default     = "10.0.1.0/24"
}
variable "public_subnet_2_cidr" {
  description = "CIDR Block for Public Subnet 2"
  default     = "10.0.2.0/24"
}
variable "private_subnet_1_cidr" {
  description = "CIDR Block for Private Subnet 1"
  default     = "10.0.3.0/24"
}
variable "private_subnet_2_cidr" {
  description = "CIDR Block for Private Subnet 2"
  default     = "10.0.4.0/24"
}
variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b"]
}

# load balancer
variable "health_check_path" {
  description = "Health check path for the default target group"
  default     = "/"
}

#ec2 instance
variable "instance_type" {
  default = "t2.micro"
}

variable "instance_ami" {
  type        = string
  description = "Packer build ubuntu ami with nginx"
}

# auto scaling
variable "autoscale_min" {
  description = "Minimum autoscale (number of EC2)"
  default     = "1"
}
variable "autoscale_max" {
  description = "Maximum autoscale (number of EC2)"
  default     = "3"
}
variable "autoscale_desired" {
  description = "Desired autoscale (number of EC2)"
  default     = "1"
}

variable "ssh_pubkey_file" {
  description = "Path to an SSH public key"
  default     = "~/.ssh/id_rsa.pub"
}

variable "domain_name" {
  type    = string
  default = "bestseller"
}

variable "website_root" {
  type        = string
  description = "Path to the root of website content"
  default     = "../content"
}
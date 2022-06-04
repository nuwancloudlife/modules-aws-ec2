variable "region" {
  type        = string
  description = "Provide the AWS region Code"
  default     = "us-east-1"
  sensitive   = false
}

variable "az_code" {
  type        = string
  description = "Provide the AZ letter [a, b, c] etc"
  default     = "a"
  sensitive   = false
}


variable "redhat" {
  type        = bool
  default     = false
  description = "Choose RedHat OS"
  sensitive   = false
}

variable "ubuntu" {
  type        = bool
  default     = false
  description = "Choose Ubuntu OS"
  sensitive   = false
}

variable "amzlinux" {
  type        = bool
  default     = false
  description = "Choose Amazon Linux OS"
  sensitive   = false
}

variable "windows2019" {
  type        = bool
  default     = false
  description = "Choose Windows 2019 OS"
  sensitive   = false
}

variable "ebs_size" {
  type        = number
  description = "Mention the EBS size in GB"
  default     = 8
  sensitive   = false
}

variable "instance_type" {
  type        = string
  description = "Provide the EC2 Type"
  default     = "t2.micro"
  sensitive   = false
}

variable "ec2_name" {
  type        = string
  description = "Name of the instance"
  default     = "linux-bastian"
  sensitive   = false
}

variable "ec2_key" {
  type        = string
  description = "Name of the Key Pair"
  sensitive   = false
}

variable "project" {
  type        = string
  description = "Project Name"
  default     = "test"
  sensitive   = false
}

variable "ec2_vpc" {
  type        = string
  description = "VPC ID of the EC2"
  sensitive   = false
  nullable    = false
}

variable "ec2_subnet" {
  type        = string
  description = "Subnet ID of the EC2"
  sensitive   = false
  nullable    = false
}

variable "my_ip" {
  type        = string
  description = "IP of the Client machine"
  default     = "10.10.10.1/32"
  sensitive   = false
}

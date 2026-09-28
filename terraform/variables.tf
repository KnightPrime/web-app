variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "key_name" {
  type        = string
  description = "The name of your pre-existing AWS EC2 SSH key pair"
}


variable "name" {}
variable "aws_ami" {}
variable "account" {}
variable "private_subnet_ids" {}
variable "public_subnet_ids" {}
variable "vpc_id" {}

variable "instance_count" {}

variable "instance_type" {
   description = "EC2 instance type to use for the argo EC2 instances."
   default     = "t3.medium"
 }

variable "tags" {
   default = {}
 }

 variable "project_root_directory" { }

 variable "lb_security_group" {}

 variable "lb_target_group" {
   description = "ARN of target group to attach EC2 instance to"
 }
terraform {
   backend "s3" {
     bucket = "terraform-marriant"
     key    = "terraform/terraform.tfstate"
     region = "us-east-1"
   }
 }

 provider "aws" {
   region = "us-east-2"
   #profile = "default"
   
   default_tags {
     tags = local.tags
   }
 }
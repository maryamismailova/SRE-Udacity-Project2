terraform {
   backend "s3" {
     bucket = "udacity-project-maryam-uswest1"
     key    = "terraform/terraform.tfstate"
     region = "us-west-1"
   }
 }

 provider "aws" {
   region = "us-west-1"
  
   default_tags {
     tags = local.tags
   }
 }
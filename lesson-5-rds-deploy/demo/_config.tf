terraform {
  backend "s3" {
    bucket = "udacity-tf-lesson5-maryam"
    key    = "terraform/terraform.tfstate"
    region = "us-east-2"
  }
}

provider "aws" {
  region = "us-east-2"

}

provider "aws" {
  alias  = "usw1"
  region = "us-west-2"
}
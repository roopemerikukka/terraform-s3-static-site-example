terraform {

  # This needs to be commented out on initial run before backend module (tf-state) is created.
  backend "s3" {
    bucket         = "cr-devweekly-terraform-demo-bucket"
    key            = "terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "cr-devweekly-terraform-demo-table"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  required_version = "~> 1.3.7"
}

provider "aws" {
  region = "eu-central-1"
}

# This is needed once per environment.
module "tf_state_dev" {
  source       = "../../modules/tf-state"
  state_bucket = "cr-devweekly-terraform-demo-bucket"
  lock_table   = "cr-devweekly-terraform-demo-table"
}


# module "site_dev" {
#   source        = "../../modules/site"
#   domain_name   = "mysite.roope.dev"
#   r53_zone      = "roope.dev"
# }
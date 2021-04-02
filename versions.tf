
terraform {

  required_version = ">= 0.14.7"

  required_providers {
    
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.33.0"
    }

    aws = {
      source  = "hashicorp/null"
      version = "~> 3.1.0"
    }
  }
}

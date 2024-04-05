terraform {
  backend "s3" {
    bucket = "sftp-tf-s3"
    key    = "terraform/terraform.tfstate"
    region = "us-east-1"
  }
}

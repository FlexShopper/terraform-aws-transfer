
variable "transfer_server" { default = "" }
variable "transfer_username" { default = "" }
variable "transfer_user_role" { default = "" }
variable "transfer_user_policy" { default = "" }
variable "home_directory_type" { default = "" }
variable "entry" { default = "" }
variable "target" { default = "" }
variable "ssh_pub_key" { default = "" }

resource "aws_transfer_user" "this" {
  server_id = var.transfer_server
  user_name = var.transfer_username
  role      = var.transfer_user_role
  policy    = var.transfer_user_policy

  home_directory_type = var.home_directory_type

  home_directory_mappings {
    entry  = var.entry
    target = var.target
  }
}

resource "aws_transfer_ssh_key" "this" {
  server_id = var.transfer_server
  user_name = aws_transfer_user.this.arn
  body      = var.ssh_pub_key
}
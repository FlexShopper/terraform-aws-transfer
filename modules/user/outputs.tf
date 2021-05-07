
output "transfer_user_arn" {
  value = element(aws_transfer_user.this.*.arn, 0)
}


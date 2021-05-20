
# IAM
output "iam_role_arn" {
  value = element(aws_iam_role.this.*.arn, 0)
}

# S3
output "s3_bucket_id" {
  value = element(aws_s3_bucket.this.*.id, 0)
}

output "s3_bucket_arn" {
  value = element(aws_s3_bucket.this.*.arn, 0)
}

# Transfer Server
output "server_arn" {
  value = element(aws_transfer_server.sftp.*.id, 0)
}

output "server_id" {
  value = element(aws_transfer_server.sftp.*.id, 0)
}

output "server_endpoint" {
  value = element(aws_transfer_server.sftp.*.endpoint, 0)
}

output "host_key_fingerprint" {
  value = element(aws_transfer_server.sftp.*.host_key_fingerprint, 0)
}


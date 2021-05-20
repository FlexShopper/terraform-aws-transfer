
# IAM
output "iam_role_arn" {
  value = [aws_iam_role.this.*.arn]
}

# S3
output "s3_bucket_id" {
  value = [aws_s3_bucket.this.*.id]
}

# Transfer Server
output "server_arn" {
  value = [aws_transfer_server.sftp.*.id]
}

output "server_id" {
  value = [aws_transfer_server.sftp.*.id]
}

output "server_endpoint" {
  value = [aws_transfer_server.sftp.*.endpoint]
}

output "host_key_fingerprint" {
  value = [aws_transfer_server.sftp.*.host_key_fingerprint]
}


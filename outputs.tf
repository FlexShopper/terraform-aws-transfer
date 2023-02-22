output "sftp_server_cname" {
  description = "Add this DNS hostname as a CNAME to your var.custom_dns_hostname input"
  value       = aws_transfer_server.this.endpoint
}
output "s3_bucket_name" {
  description = "S3 Bucket Name used for Transfer Server Backend"
  value       = var.premade_s3_bucket ? module.sftp_storage_bucket[0].s3_bucket_id : var.s3_bucket_name
}


output "transfer_sftp_server_arn" {
  value = aws_transfer_server.sftp.*.arn
}

output "transfer_sftp_server_id" {
  value = aws_transfer_server.sftp.*.arn
}

output "transfer_sftp_server_endpoint" {
  value = aws_transfer_server.sftp.*.endpoint
}

output "transfer_sftp_host_key_fingerprint" {
  value = aws_transfer_server.sftp.*.host_key_fingerprint
}

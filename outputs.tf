
output "transfer_sftp_server_arn" {
  value = aws_transfer_server.sftp[count.index].arn
}

output "transfer_sftp_server_id" {
  value = aws_transfer_server.sftp[count.index].arn
}

output "transfer_sftp_server_endpoint" {
  value = aws_transfer_server.sftp[count.index].endpoint
}

output "transfer_sftp_host_key_fingerprint" {
  value = aws_transfer_server.sftp[count.index].host_key_fingerprint
}

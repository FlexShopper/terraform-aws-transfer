# Breaking this out to locals for readability
locals {
  s3_bucket_list                  = [var.premade_s3_bucket ? module.sftp_storage_bucket[0].s3_bucket_arn : "arn:aws:s3:::${var.s3_bucket_name}"]
  s3_bucket_home_directory_access = var.premade_s3_bucket ? "${module.sftp_storage_bucket[0].s3_bucket_arn}/*" : "arn:aws:s3:::${var.s3_bucket_name}/*"
}

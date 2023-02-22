# SFTP Storage Bucket Policy allowing access from AWS Transfer
data "aws_iam_policy_document" "aws_transfer_sftp_bucket_policy" {
  count = var.premade_s3_bucket == true ? 1 : 0

  statement {
    sid = "AWSTransferAccessToBucket"
    principals {
      type        = "Service"
      identifiers = ["transfer.amazonaws.com"]
    }

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      module.sftp_storage_bucket[0].s3_bucket_arn
    ]
  }
  statement {
    sid = "AWSTransferBucketPolicyAccessToObjects"
    principals {
      type        = "Service"
      identifiers = ["transfer.amazonaws.com"]
    }

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:DeleteObjectVersion"
    ]

    resources = [
      "${module.sftp_storage_bucket[0].s3_bucket_arn}/*" #tfsec:ignore:aws-iam-no-policy-wildcards ignore warning as prefixes aren't used here.
    ]
  }
}

module "sftp_storage_bucket" {
  #ts:skip=AC_AWS_0214 #Versioning is not needed for Transfer Family
  count = var.premade_s3_bucket == true ? 1 : 0

  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.0"

  bucket        = "${var.name}-sftp-storage"
  force_destroy = var.force_destroy

  # Bucket policies
  attach_policy                         = true
  policy                                = data.aws_iam_policy_document.aws_transfer_sftp_bucket_policy[0].json
  attach_deny_insecure_transport_policy = true
  attach_require_latest_tls_policy      = true

  # S3 bucket-level Public Access Block configuration
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  # S3 Encryption at rest
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning = {
    enabled = true
  }

  # Object Retention Rule
  lifecycle_rule = [
    {
      id      = "Object-Deletion"
      enabled = true
      noncurrent_version_expiration = {
        days = 90
      }
    }
  ]

  tags = local.tags
}

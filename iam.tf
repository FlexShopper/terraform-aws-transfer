# Role granting AWS Transfer access to the SFTP Storage bucket and Cloudwatch
resource "aws_iam_role" "aws_transfer_role" {
  name               = "${var.name}-aws-transfer-role"
  description        = "This role grants AWS Transfer Read/Write access to the SFTP storage bucket"
  assume_role_policy = data.aws_iam_policy_document.aws_transfer_assume_role_policy.json

  tags = local.tags
}

# AWS Transfer Assume Role policy
data "aws_iam_policy_document" "aws_transfer_assume_role_policy" {
  statement {
    sid     = "AWSTransferAssume"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["transfer.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }
}

# Policy granting AWS Transfer Read/Write permissions to SFTP storage bucket.
data "aws_iam_policy_document" "aws_transfer_policy" {
  statement {
    sid = "AllowBucketListing"
    actions = [
      "s3:ListBucket"
    ]
    resources = local.s3_bucket_list
  }

  statement {
    sid = "HomeDirectoryAccess"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:DeleteObject",
      "s3:DeleteObjectVersion",
    ]
    #tfsec:ignore:aws-iam-no-policy-wildcards
    resources = [
      local.s3_bucket_home_directory_access
    ]
  }
}

# Policy used by AWS Transfer Role for SFTP bucket access
resource "aws_iam_role_policy" "aws_transfer_role_policy" {
  name   = "${var.name}-aws-transfer-role-policy"
  role   = aws_iam_role.aws_transfer_role.id
  policy = data.aws_iam_policy_document.aws_transfer_policy.json
}

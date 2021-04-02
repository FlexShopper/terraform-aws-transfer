
# IAM - Cloudwatch Logs
resource "aws_iam_role" "this_logging_role" {
  count              = var.create_sftp_server ? 1 : 0
  name               = "${var.name_prefix}-${var.namespace}-cw-iam-role"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": "transfer.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
    ]
}
EOF

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-${var.namespace}-cloudwatch-iam-role"
    },
  )

}

resource "aws_iam_policy" "this_logging_role_policy" {
  count       = var.create_sftp_server ? 1 : 0
  description = "Access Policy for Cloudwatch Logs - AWS Transfer Family Service Role."
  name        = "${var.name_prefix}-${var.namespace}-cw-iam-policy"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Sid": "CloudWatchLogsAccess",
        "Effect": "Allow",
        "Action": [
            "logs:*"
        ],
        "Resource": "arn:aws:logs:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:log-group:/aws/transfer/${aws_transfer_server.sftp[count.index].id}"
        }
    ]
}
EOF

}

resource "aws_iam_role_policy_attachment" "this_logging_role" {
  count      = var.create_sftp_server ? 1 : 0
  role       = aws_iam_role.this_logging_role[count.index].name
  policy_arn = aws_iam_policy.this_logging_role_policy[count.index].arn
}

# IAM - S3
resource "aws_iam_role" "this_s3_role" {
  count              = var.create_sftp_server ? 1 : 0 || var.create_ftps_server ? 1 : 0
  name               = "${var.name_prefix}-${var.namespace}-s3-iam-role"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": "s3.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
    ]
}
EOF

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-${var.namespace}-s3-iam-role"
    },
  )

}

resource "aws_iam_policy" "this_s3_role_policy" {
  count       = var.create_sftp_server ? 1 : 0 || var.create_ftps_server ? 1 : 0
  description = "Access Policy for S3 - AWS Transfer Family Service Role."
  name        = "${var.name_prefix}-${var.namespace}-s3-iam-policy"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.this[count.index].id}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject",
        "s3:DeleteObjectVersion",
        "s3:GetObjectVersion",
        "s3:GetObjectACL",
        "s3:PutObjectACL"
      ],
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.this[count.index].id}/*"
      ]
    }
  ]
}
EOF

}

resource "aws_iam_role_policy_attachment" "this_s3_role" {
  count      = var.create_sftp_server ? 1 : 0 || var.create_ftps_server ? 1 : 0
  role       = aws_iam_role.this_s3_role[count.index].name
  policy_arn = aws_iam_policy.this_s3_role_policy[count.index].arn
}

# S3
resource "aws_s3_bucket" "this" {
  count  = var.create_sftp_server ? 1 : 0 || var.create_ftps_server ? 1 : 0
  bucket = "${var.name_prefix}-${data.aws_region.this.name}-${var.namespace}-bucket"
  acl    = var.s3_acl

  versioning {
    enabled = var.s3_versioning
  }

  tags = merge(map(
    "Name", "${var.name_prefix}-${data.aws_region.this.name}-${var.namespace}-bucket"
    ),
    var.tags
  )
}

resource "aws_s3_bucket_public_access_block" "this" {
  count  = var.create_sftp_server ? 1 : 0 || var.create_ftps_server ? 1 : 0
  bucket = aws_s3_bucket.this[count.index].id

  block_public_acls       = var.s3_disable_public_access
  block_public_policy     = var.s3_disable_public_access
  ignore_public_acls      = var.s3_disable_public_access
  restrict_public_buckets = var.s3_disable_public_access
}

# Transfer - SFTP
resource "aws_transfer_server" "sftp" {
  count                  = var.create_sftp_server ? 1 : 0
  endpoint_type          = var.endpoint_type
  host_key               = var.host_key
  identity_provider_type = var.identity_provider_type
  logging_role           = aws_iam_role.this_logging_role[count.index].arn
  force_destroy          = var.force_destroy

  tags = merge(map(
    "Name", "${var.name_prefix}-${var.namespace}"
    ),
    var.tags
  )

  # Adding this to mimic behavior from AWS Console.
  # Option currently not available as Terraform input.
  provisioner "local-exec" {
    command     = "aws transfer update-server --server-id ${aws_transfer_server.sftp[count.index].id} --security-policy-name ${var.security_policy_name}"
    interpreter = ["/bin/bash", "-c"]
  }

  # The Cloudwatch Group is automatically created by the creation of this resource so it isn't directly managed by Terraform.
  provisioner "local-exec" {
    command     = "aws logs put-retention-policy --log-group-name '/aws/transfer/${aws_transfer_server.sftp[count.index].id}' --retention-in-days ${var.log_retention}"
    interpreter = ["/bin/bash", "-c"]
  }
}

# Create Custom Hostname Route53 DNS Alias
resource "null_resource" "specify_sftp_route53_dns_alias" {
  count = var.custom_hostname_route53 != null ? 1 : 0
  provisioner "local-exec" {
    command = <<-EOF
      aws transfer tag-resource \
        --arn '${aws_transfer_server.sftp[count.index].arn}' \
        --tags 'Key=aws:transfer:customHostname,Value=${var.custom_hostname_route53}' \
        --tags 'Key=aws:transfer:route53HostedZoneId,Value=/hostedzone/${data.aws_route53_zone.this.zone_id}'
EOF
  }

  # This resource should only run if the following is true
  # - custom_hostname string is set
  # - sftp transfer server successfully created

  depends_on = [
    aws_transfer_server.sftp[0]
  ]
}

# Create Custom Hostname Other DNS
resource "null_resource" "specify_sftp_other_dns_hostname" {
  count = var.custom_hostname_other_dns != null ? 1 : 0
  provisioner "local-exec" {
    command = <<-EOF
      aws transfer tag-resource \
        --arn '${aws_transfer_server.sftp[count.index].arn}' \
        --tags 'Key=aws:transfer:customHostname,Value=${var.custom_hostname_other_dns}'
EOF
  }

  # This resource should only run if the following is true
  # - custom_hostname string is set
  # - sftp transfer server successfully created

  depends_on = [
    aws_transfer_server.sftp[0]
  ]
}

## Transfer - FTPS
resource "aws_transfer_server" "ftps" {
  count                  = var.create_ftps_server ? 1 : 0
  endpoint_type          = var.endpoint_type
  identity_provider_type = var.identity_provider_type
  invocation_role        = var.invocation_role
  url                    = var.url
  force_destroy          = var.force_destroy

  tags = merge(map(
    "Name", "${var.name_prefix}-${var.namespace}"
    ),
    var.tags
  )
}

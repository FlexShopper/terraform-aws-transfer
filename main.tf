
# Cloudwatch Log Group
resource "aws_cloudwatch_log_group" "this" {
  name = lookup(var.cloudwatch_log_group, "name")
  retention_in_days = lookup(var.cloudwatch_log_group, "retention")

  tags = merge(
    var.environment,
    map(
      "Name", concat(var.name_prefix, lookup(var.cloudwatch_log_group, "name"))
    ))
}

# IAM - Cloudwatch Log Role
resource "aws_iam_role" "this_logging_role" {
  name = concat(var.name_prefix, var.iam_cw_logging_role_name)
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

}

resource "aws_iam_policy" "this_logging_role_policy" {
  description = "Access Policy for Cloudwatch Logs."
  name = concat(var.name_prefix, var.iam_cw_logging_role_name)
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Sid": "CloudWatchLogsAccess",
        "Effect": "Allow",
        "Action": [
            "logs:*"
        ],
        "Resource": "arn:aws:logs:${data.aws_region.this}:${data.aws_caller_identity.this.account_id}:log-group:/${var.cloudwatch_log_group.name}"
        }
    ]
}
EOF

  tags = merge(
    var.environment,
    map(
      "Name", concat(var.name_prefix, var.iam_cw_logging_role_name)
    ))
}

resource "aws_iam_role_policy_attachment" "this_logging_role" {
  role       = aws_iam_role.this_logging_role.name
  policy_arn = aws_iam_policy.this_logging_role_policy.arn
}

## Transfer - SFTP
resource "aws_transfer_server" "sftp" {
  count = var.create_sftp_server ? 1 : 0
  endpoint_type           = var.endpoint_type
  host_key                = var.sftp_host_key
  identity_provider_type  = var.identity_provider_type
  logging_role            = var.logging_role
  force_destroy           = var.force_destroy

  tags = {
    Name = "${var.name_prefix}-sftp-${var.env_shortname}"
    environment  = var.env_longname
  }
}

## Transfer - FTPS
resource "aws_transfer_server" "ftps" {
  count = var.create_ftps_server ? 1 : 0
  endpoint_type           = var.endpoint_type
  identity_provider_type  = var.identity_provider_type
  invocation_role         = var.invocation_role
  url                     = var.url
  force_destroy           = var.force_destroy

  tags = {
    Name = "${var.name_prefix}-sftp-${var.env_shortname}"
    environment  = var.env_longname
  }
}
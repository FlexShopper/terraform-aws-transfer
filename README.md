# AWS SFTP Transfer-family Terraform module

Terraform module which creates SFTP Transfer-family resources on AWS.

## Terraform versions

Tested on Terraform 1.0.0 and newer. Submit pull-requests to `main` branch.

## Usage

### Transfer Server

SFTP Transfer Server with default actions:

```hcl
resource "aws_transfer_access" "this" {
  for_each = toset(var.transfer_access_sids)

  role           = aws_iam_role.aws_transfer_role.arn
  server_id      = aws_transfer_server.this.id
  home_directory = var.premade_s3_bucket == true ? "/${module.sftp_storage_bucket[0].s3_bucket_id}" : "/${var.s3_bucket_name}"
  external_id    = each.value
}
```

## Tested

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| aws | >= 3.33.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.33.0 |

## Modules

| [user](https://github.com/FlexShopper/terraform-aws-transfer) |

## Resources

| Name |
|------|
| [aws_cloudwatch_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) |
| [aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) |
| [aws_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) |
| [aws_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) |
| [aws_s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) |
| [aws_s3_bucket_public_access_block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) |
| [aws_transfer_server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/transfer_server) |
| [null_resource](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) |


## Authors

Module managed by [Kyle Vidmar](https://github.com/kyvidmar).



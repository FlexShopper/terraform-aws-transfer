# AWS SFTP User for Transfer Family Server

Terraform module which creates SFTP User Transfer-family resources on AWS.

These types of resources are supported:

* [Transfer SSH Key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/transfer_ssh_key)
* [Transfer User](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/transfer_user)

## Terraform versions

Terraform 0.14 and newer. Submit pull-requests to `main` branch.

## Usage

### Transfer Server

Create Transfer Server

```hcl

module "transfer_sftp" {
  source  = "https://github.com/FlexShopper/terraform-aws-transfer.git?ref=0.1.0"
  
  name_prefix   = "myorg-dev"
  namespace     = "server-01"
  host_key      = var.host_key

  custom_hostname_route53 = "sftp"
  route53_zone_name       = "example.com"

  tags = {
    environment = "development"
  }
}
```

Create SFTP Transfer User

```hcl
module "transfer_sftp_user_johndoe" {
  source  = "https://github.com/FlexShopper/terraform-aws-transfer.git?ref=0.1.0//modules/user"

  body                    = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDZTwfPTLQj47Dn4WOkwG61KZ+/raI50kbmHhLEckUnxEseTB5GAYlKcAhquSQhDsNRCY16YyxP/7mWAC9Y1CfjO5k2wk1ILykiTQAa0ejliv2rAqTGdO9cCzs7xXxemh2TE/nLNZPShDj+3GSs9sNBaPE6NV+8LPjJPuRVyseCiqptUXyLXa64IDwIo8n2j6u9PR87bYb3FesMcb+q4cPvFRKwgXZ8ZMz+5c+kl261HouoVt1bH/S8r/1qNw/OnJczqZbqa5w76qukQXxuX9ZOWAt8hPWAmwZRjz+WtVFUJOBa2/qPNpUPYwr3YxsnIFK1SayrvfV2qkQkdpJT49z1 johndoe@foobar.ec2.internal"
  home_directory          = "/${aws_s3_bucket.this.id}/${var.username}"
  home_directory_mappings = {
    entry = "/",
    target = "/${module.transfer_sftp.s3_bucket_id}/$${Transfer:UserName}"
  }

  ## See example of policy - https://docs.aws.amazon.com/transfer/latest/userguide/scope-down-policy.html
  policy    = file("${path.module}/transfer-user-policies/johndoe-iam-policy.json")

  role      = module.transfer_sftp.s3_role_arn
  server_id = module.transfer_sftp.server_id
  user_name = "johndoe"

  tags = {
    environment = "development"
  }
}
```

## Tested

| Name | Version |
|------|---------|
| terraform | >= 0.14.0 |
| aws | >= 3.33.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.33.0 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_transfer_ssh_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/transfer_ssh_key) |
| [aws_transfer_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/transfer_user) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| body | The public key portion of an SSH key pair. | `string` | `"null"` | yes |
| create\_user | Controls if the SFTP User should be created. | `bool` | `true` | no |
| home\_directory | The landing directory (folder) for a user when they log in to the server using their SFTP client. It should begin with a / . For example, /example-bucket-1234/username would set the home bucket to example-bucket-1234 and the home directory to username. | `string` | `"null"` | yes |
| home\_directory\_mappings | Logical directory mappings that specify what S3 paths and keys should be visible to your user and how you want to make them visible. | `map(string)` | `"null"` | yes |
| home\_directory\_type | The type of landing directory (folder) you mapped for your users' home directory. Valid values are PATH and LOGICAL. | `string` | `"LOGICAL"` | no |
| policy | An IAM JSON policy document that scopes down user access to portions of their Amazon S3 bucket. | `string` | `"See variable 'policy' defined in variables.tf"` | no |
| role | Amazon Resource Name (ARN) of an IAM role that allows the service to controls your user’s access to your Amazon S3 bucket. | `string` | `"null"` | yes |
| server\_id | The Server ID of the Transfer Server (e.g. s-12345678). | `string` | `"null"` | yes |
| user\_name | The name used for log in to your SFTP server. | `string` | `"null"` | yes |
| tags | A map of tags to assign to the resource. | `string` | `"null"` | no |

## Outputs

| Name | Description |
|------|-------------|
| user_arn | Amazon Resource Name (ARN) of the AWS Transfer User |

## Authors

Module managed by [Steven Almonte](https://github.com/salmonte-flexshopper).

## License

Apache 2 Licensed. See LICENSE for full details.



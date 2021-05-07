
variable "body" {
  description = "The public key portion of an SSH key pair."
  type = string
  default = null
}

variable "create_user" {
  description = "Controls if the SFTP User should be created."
  type        = bool
  default     = true
}

variable "home_directory" {
  description = "The landing directory (folder) for a user when they log in to the server using their SFTP client. It should begin with a / . For example, /example-bucket-1234/username would set the home bucket to example-bucket-1234 and the home directory to username."
  type = string
  default = null
}

variable "home_directory_mappings" {
  description = "Logical directory mappings that specify what S3 paths and keys should be visible to your user and how you want to make them visible."
  type = map(string)
  default = null
}

variable "home_directory_type" {
  description = "The type of landing directory (folder) you mapped for your users' home directory. Valid values are PATH and LOGICAL."
  type = string
  default = "LOGICAL"
}

variable "policy" {
  description = "An IAM JSON policy document that scopes down user access to portions of their Amazon S3 bucket."
  type = string
  default = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowListingOfUserFolder",
            "Action": [
                "s3:ListBucket"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::$${transfer:HomeBucket}"
            ],
            "Condition": {
                "StringLike": {
                    "s3:prefix": [
                        "$${transfer:HomeFolder}/*",
                        "$${transfer:HomeFolder}"
                    ]
                }
            }
        },
        {
            "Sid": "HomeDirObjectAccess",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:GetObjectVersion"
            ],
            "Resource": "arn:aws:s3:::$${transfer:HomeDirectory}*"
        }
    ]
}
EOF

}

variable "role" {
  description = "Amazon Resource Name (ARN) of an IAM role that allows the service to controls your user’s access to your Amazon S3 bucket."
  type = string
  default = null
}

variable "server_id" {
  description = "The Server ID of the Transfer Server (e.g. s-12345678)."
  type = string
  default = null
}

variable "user_name" {
  description = "The name used for log in to your SFTP server."
  type = string
  default = null
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type = map(string)
  default = null
}



resource "aws_transfer_user" "this" {
  server_id = var.aws_transfer_server
  user_name = var.aws_transfer_username
  role      = var.iam_transfer_user_role
  policy    = << EOF

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
              "arn:aws:s3:::${transfer:HomeBucket}"
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
              "s3:DeleteObjectVersion",
              "s3:DeleteObject",
              "s3:GetObjectVersion",
              "s3:GetObjectACL",
              "s3:PutObjectACL"
          ],
          "Resource": "arn:aws:s3:::$${transfer:HomeDirectory}*"
       }
  ]
}

EOF

  home_directory_type = var.home_directory_type

  home_directory_mappings {
    entry  = var.entry
    target = var.target
  }
}

resource "aws_transfer_ssh_key" "this" {
  server_id = var.aws_transfer_server
  user_name = aws_transfer_user.this.arn
  body      = var.ssh_pub_key
}
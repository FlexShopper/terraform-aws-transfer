variable "name" {
  description = "name to prepend to all resource names within module"
  type        = string
  default = "sftp-prod"
}

variable "input_tags" {
  description = "Map of tags to apply to resources"
  type        = map(string)
  default = {
    Developer   = "FlexShopper"
    Provisioner = "Terraform"
  }
}

variable "directory_id" {
  description = "AWS Managed AD Directory ID or AWS Directory Connector ID"
  type        = string
  default = "d-90671e7e92"
}

variable "premade_s3_bucket" {
  description = "Use the pre-made S3 bucket and policies included in the module, or use a custom S3 bucket."
  type        = bool
  default     = false
}

variable "s3_bucket_name" {
  description = "Bucket Name if premade_s3_bucket is set to FALSE"
  type        = string
  default     = "sftp-prod"
}

variable "force_destroy" {
  description = "Force Destroy Premade S3 Bucket if created"
  type        = bool
  default     = false

}

variable "transfer_access_sids" {
  description = "External SIDs allowed access to the Transfer Server"
  type        = list(string)
  default = ["S-1-5-21-1426789113-3690512563-3263562182-6868","S-1-5-21-1426789113-3690512563-3263562182-6870","S-1-5-21-1426789113-3690512563-3263562182-6869"]
}

variable "enable_custom_dns" {
  description = "Boolean to enable custom DNS for Transfer Family"
  type        = string
  default = "transfer"
}

variable "custom_dns_hostname" {
  description = "FQDN for custom DNS for SFTP Server"
  type        = string
  default     = "transfer.flexshopper.com"
}

variable "r53_hosted_zone_id" {
  description = "R53 Hosted Zone ID for Custom Hostname"
  type        = string
  default     = "Z3L2B6Q3Y247LZ"
}

variable "security_policy_name" {
  description = "Transfer Family Security Policy Name - https://docs.aws.amazon.com/transfer/latest/userguide/security-policies.html"
  type        = string
  default     = "TransferSecurityPolicy-2018-11"
}

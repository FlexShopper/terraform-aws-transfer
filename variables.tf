
# Tags
variable "environment" {
  description = "The environment tag value."
  type        = string
  default     = "development"
}

variable "name_prefix" {
  description = "Prefix name added to resources."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type = map(string)
  default = null
}

# Cloudwatch
variable "cloudwatch_log_group" {
  description = "Map of Cloudwatch Log Group settings for Transfer Server."
  type        = map(any)
  default     = {
    name = "/aws/transfer"
    retention = 30
  }
}

# IAM
variable "iam_cw_logging_role_name" {
  description = "Name of IAM Cloudwatch Logging role."
  type        = string
  default     = "transfer-logging-role"
}

# Transfer
variable "create_sftp_server" {
  description = "Controls if the SFTP Server should be created."
  type        = bool
  default     = true
}

variable "create_ftps_server" {
  description = "Controls if the FTPS Server should be created."
  type        = bool
  default     = false
}

variable "endpoint_details" {
  description = "Map of VPC endpoint settings that you want to configure for your SFTP server."
  type = map(any)
  default = null
}

variable "endpoint_type" {
  description = "The type of endpoint that you want your SFTP server connect to. If you connect to a VPC, your SFTP server isn't accessible over the public internet. If you want to connect your SFTP server via public internet, set PUBLIC. Defaults to PUBLIC."
  type = string
  default = "PUBLIC"
}

variable "identity_provider_type" {
  description = "The mode of authentication enabled for this service. The default value is SERVICE_MANAGED, which allows you to store and access SFTP user credentials within the service. API_GATEWAY indicates that user authentication requires a call to an API Gateway endpoint URL provided by you to integrate an identity provider of your choice."
  type = string
  default = "SERVICE_MANAGED"
}

variable "invocation_role" {
  description = "Amazon Resource Name (ARN) of the IAM role used to authenticate the user account with an identity_provider_type of API_GATEWAY."
  type = string
  default = null
}

variable "host_key" {
  description = "You can replace the default host key with a host key from another server. Do so only if you plan to move existing users from an existing SFTP-enabled server to your new SFTP-enabled server."
  type = string
  default = null
}

variable "url" {
  description = "URL of the service endpoint used to authenticate users with an identity_provider_type of API_GATEWAY"
  type = string
  default = null
}

variable "force_destroy" {
  description = "A boolean that indicates all users associated with the server should be deleted so that the Server can be destroyed without error. The default value is false."
  type = bool
  default = false
}
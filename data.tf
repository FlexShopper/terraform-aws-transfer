
data "aws_caller_identity" "this" {}
data "aws_region" "this" {}
data "aws_route53_zone" "this" {
  count = var.custom_hostname_route53 != null ? 1 : 0
  name = var.route53_zone_name
}


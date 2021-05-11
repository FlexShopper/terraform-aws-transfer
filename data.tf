
data "aws_caller_identity" "this" {}
data "aws_region" "this" {}
data "aws_route53_zone" "this" {
  count = var.route53_zone_name != null ? 1 : 0
  name = var.route53_zone_name
}

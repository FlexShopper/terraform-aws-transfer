
data "aws_caller_identity" "this" {}
data "aws_region" "this" {}
data "aws_route53_zone" "this" {
  name = var.route53_zone_name
}


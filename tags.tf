locals {
  tags = merge(var.input_tags, {
    "ModuleSourceRepo" = "github.com/FlexShopper/terraform-aws-transfer"
  })
}

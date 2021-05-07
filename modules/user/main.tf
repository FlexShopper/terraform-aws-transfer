
resource "aws_transfer_user" "this" {
  count                 = var.create_user ? 1 : 0
  server_id             = var.server_id
  user_name             = var.user_name
  role                  = var.role
  policy                = var.policy
  home_directory        = var.home_directory
  home_directory_type   = var.home_directory_type

  home_directory_mappings {
    entry  = lookup(var.home_directory_mappings, "entry", "ERROR: Set 'entry' value")
    target = lookup(var.home_directory_mappings, "target", "ERROR : Set 'target' value")
  }

  tags = merge(
    var.tags,
    {
      Name = var.user_name
    },
  )
}

resource "aws_transfer_ssh_key" "this" {
  count     = var.create_user ? 1 : 0
  server_id = var.server_id
  user_name = aws_transfer_user.this[count.index].user_name
  body      = var.body
}


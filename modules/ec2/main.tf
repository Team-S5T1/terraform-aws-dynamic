resource "aws_instance" "this" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = var.security_group_ids
  subnet_id              = var.subnet_id

  tags = {
    Name = var.instance_name
  }

  source_dest_check    = var.source_dest_check
  user_data            = var.user_data
  iam_instance_profile = aws_iam_instance_profile.this.name
}

resource "aws_iam_instance_profile" "this" {
  name = var.instance_profile_name
  role = var.instance_profile_role_name
}
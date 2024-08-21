resource "aws_launch_template" "this" {
  name_prefix   = var.template_name
  image_id      = var.image_id
  instance_type = var.instance_type
  user_data     = base64encode(var.user_data)
  # key_name      = var.key_name

  #인스턴스 타입설정(spot or ondemand)
  instance_market_options {
    market_type = var.market_type
  }
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = var.security_groups
  }
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = var.instance_name
    }
  }

}
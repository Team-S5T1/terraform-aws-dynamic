variable "template_name" {
  description = "template name for start template"
  type        = string
}

variable "image_id" {
  description = "image id for start template"
  type        = string
}

variable "instance_type" {
  description = "instance type for start template"
  type        = string
}

variable "market_type" {
  description = "select type for start template"
  type        = string
}

variable "user_data" {
  description = "userdata for start template"
  type        = string
}

variable "security_groups" {
  description = "sg for template"
  type        = list(string)
}

variable "instance_name" {
  description = "instance_name"
  type        = string
}

# variable "key_name" {
#   description = "keyname for ec2 instance"
#   type        = string
# }
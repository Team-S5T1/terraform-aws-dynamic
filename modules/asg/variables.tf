variable "subnet_ids" {
  description = "A list of subnet IDs for the auto scaling group"
  type        = list(string)
}

variable "desired_capacity" {
  description = "desired_capacity"
  type        = string
}
variable "max_size" {
  description = "maxsize for ec2 instance"
  type        = string
}

variable "min_size" {
  description = "minsize for ec2 instance"
  type        = string
}

variable "instance_name" {
  description = "name for asg"
  type        = string
}

variable "launch_template_id" {
  description = "id for launch_template"
  type        = string
}

variable "asg_name" {
  description = "name for asg"
  type        = string
}
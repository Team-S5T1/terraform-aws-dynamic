variable "ami" {
  description = "The AMI to use for the instance."
  type        = string
}

variable "instance_type" {
  description = "The type of instance to create."
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "The key name to use for the instance."
  type        = string
}

variable "security_group_ids" {
  description = "The security groups to associate with the instance."
  type        = list(string)
}

variable "subnet_id" {
  description = "The subnet ID to launch the instance in."
  type        = string
}

variable "instance_name" {
  description = "The name tag for the instance."
  type        = string
  default     = "example-instance"
}

variable "source_dest_check" {
  description = "The source destination check for the instance."
  type        = bool
  default     = true
}

variable "user_data" {
  description = "The user data for the instance."
  type        = string
  default     = ""
}
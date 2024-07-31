output "instance_id" {
  description = "The ID of the EC2 instance."
  value       = aws_instance.this.id
}

output "public_ip" {
  description = "The public IP of the EC2 instance."
  value       = aws_instance.this.public_ip
}

output "private_ip" {
  description = "The private IP of the EC2 instance."
  value       = aws_instance.this.private_ip
}

output "network_interface_id" {
  description = "The ID of the network interface."
  value = aws_instance.this.primary_network_interface_id
}
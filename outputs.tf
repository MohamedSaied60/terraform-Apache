output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_eip.ubuntu_eip.public_ip
}

output "private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.ubuntu_server.private_ip
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.ubuntu_server.id
}

output "website_url" {
  description = "URL to access the website"
  value       = "http://${aws_eip.ubuntu_eip.public_ip}"
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh ec2-user@${aws_eip.ubuntu_eip.public_ip}"
}

output "your_name_display" {
  description = "Your name as configured"
  value       = var.your_name
}
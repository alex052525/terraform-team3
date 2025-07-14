output "bastion_public_ip" {
  description = "Public IP of bastion EC2 instance"
  value       = aws_instance.bastion.public_ip
}

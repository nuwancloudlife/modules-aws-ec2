output "ec2_id" {
  value       = aws_instance.primary.id
  description = "EC2 Instance ID"
}

output "ec2_sg_id" {
  value       = aws_security_group.ec2_sec_grp.id
  description = "EC2 Instance ID"
}
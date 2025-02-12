output "vpc_id" {
  value       = aws_vpc.main.id
  description = "VPC ID"
}

output "private_subnet_ids" {
  value       = [aws_subnet.private_zone1.id, aws_subnet.private_zone2.id]
  description = "List of private subnet IDs"
}

output "public_subnet_ids" {
  value       = [aws_subnet.public_zone1.id, aws_subnet.public_zone2.id]
  description = "List of public subnet IDs"
}

output "nat_gateway_ip" {
  value       = aws_eip.nat.public_ip
  description = "Elastic IP address for NAT Gateway"
}

output "vpc_cidr" {
  value       = aws_vpc.main.cidr_block
  description = "CIDR block of the VPC"
}

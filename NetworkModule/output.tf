output "vpc_id" {
  value = aws_vpc.Demo.id
}

output "subnet_name1" {
  value = aws_subnet.sub1.id
}

output "subnet_name2" {
  value = aws_subnet.sub2.id
}

output "subnet_name3" {
  value = aws_subnet.sub3.id
}

output "security_group_id" {
  value = aws_security_group.sg.id
}
output "apache_public_ip" {
  value = aws_instance.my_apache_server[*].public_ip
}

#output "apache_key_pair_id" {
#  value = aws_key_pair.deployer.id 
#}

output "apache_security_group_id" {
  value = aws_security_group.sg_my_server.id  
}
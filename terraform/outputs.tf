# Output the private key content
output "docker_key" {
  sensitive = true
  value = tls_private_key.rsa.private_key_pem
}

output "docker_ip" {
    value = aws_instance.docker-instance.public_ip
}
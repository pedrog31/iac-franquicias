output "db_host" {
  description = "db_host"
  value       = aws_db_instance.franquicias_db.address
}
output "db_name" {
  description = "db_name"
  value       = aws_db_instance.franquicias_db.db_name
}
output "db_port" {
  description = "db_port"
  value       = aws_db_instance.franquicias_db.port
}
output "db_user" {
  description = "db_user"
  value       = aws_db_instance.franquicias_db.username
}
output "db_password" {
  description = "db_password"
  value       = random_password.password.result
}
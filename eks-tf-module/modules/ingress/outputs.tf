output "nginx_ingress_hostname" {
  value       = helm_release.external_nginx.status
  description = "Hostname of the NGINX ingress controller"
}

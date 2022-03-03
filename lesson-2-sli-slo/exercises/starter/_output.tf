output "account_id" {
   value = data.aws_caller_identity.current.account_id
 }

 output "caller_arn" {
   value = data.aws_caller_identity.current.arn
 }

 output "caller_user" {
   value = data.aws_caller_identity.current.user_id
 }

 output "grafana-url" {
  value = kubernetes_service.grafana-external.status.0.load_balancer.0.ingress[0].hostname
}


output "prometheus-url" {
  value = "${kubernetes_service.prometheus-external.status.0.load_balancer.0.ingress[0].hostname}:${kubernetes_service.prometheus-external.spec.0.port.0.port}"
}


output "grafana-creds" {
  sensitive = true  
  value = data.kubernetes_secret.grafana.data
}

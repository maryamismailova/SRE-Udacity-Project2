provider "helm" {
  kubernetes {
    host     =  data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)

    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.cluster.name]
      command     = "aws"
    }
  }
}

resource "kubernetes_secret" "scrape-config" {
  metadata {
    name = "additional-scrape-configs"
    namespace = kubernetes_namespace.monitoring.metadata.0.name
  }

  data = {
    "prometheus-additional.yaml" = file("${var.project_root_directory}/prometheus-additional.yaml")
  }


  depends_on = [
     module.project_eks, module.project_ec2, kubernetes_namespace.monitoring
   ]
}

resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace = kubernetes_namespace.monitoring.metadata.0.name

  cleanup_on_fail = true

  values = [
    file("${var.project_root_directory}/values.yaml")
  ]

  depends_on = [kubernetes_secret.scrape-config, module.project_eks]

}

# data "kubernetes_secret" "grafana" {
#   metadata {
#     name = "prometheus-grafana"
#     namespace = helm_release.prometheus.namespace
#   }

#   depends_on = [kubernetes_secret.scrape-config, module.project_eks]
# }
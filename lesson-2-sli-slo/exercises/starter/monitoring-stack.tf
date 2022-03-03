provider "helm" {
  kubernetes {
   config_path            = "~/.kube/config"
   host                   = data.aws_eks_cluster.cluster.endpoint
   cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
   token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

resource "kubernetes_secret" "additionals" {
  metadata {
    name = "additional-scrape-configs"
    namespace = "monitoring"
  }

  data = {
    "prometheus-additional.yaml" = "${file("${path.module}/prometheus-additional.yaml")}"
  }

}

resource "helm_release" "prometheus-stack" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = "monitoring"

  values = [
    "${file("values.yaml")}"
  ]

  depends_on = [kubernetes_secret.additionals]
}

data "kubernetes_secret" "grafana" {
  metadata {
    name = "prometheus-grafana"
    namespace = "monitoring"
  }
}

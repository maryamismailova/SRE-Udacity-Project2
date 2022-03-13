provider "kubernetes" {
   config_path            = "~/.kube/config"
   host                   = data.aws_eks_cluster.cluster.endpoint
   cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
   token                  = data.aws_eks_cluster_auth.cluster.token
 }

 data "aws_eks_cluster" "cluster" {
   name = module.project_eks.cluster_id
 }

 data "aws_eks_cluster_auth" "cluster" {
   name = module.project_eks.cluster_id
 }

 module "project_eks" {
   source             = "./modules/eks"
   name               = local.name
   account            = data.aws_caller_identity.current.account_id
   private_subnet_ids = module.vpc.private_subnet_ids
   ec2_sg             = module.project_ec2.ec2_sg
   vpc_id             = module.vpc.vpc_id
   nodes_desired_size = 2
   nodes_max_size     = 3
   nodes_min_size     = 1

   depends_on = [
    module.vpc,
   ]
 }

 resource "kubernetes_namespace" "udacity" {
   metadata {
     name = local.name
   }
   depends_on = [
     module.project_eks
   ]
 }

 resource "kubernetes_namespace" "monitoring" {
   metadata {
     name = "monitoring"
   }
   depends_on = [
     module.project_eks
   ]
 }

  resource "kubernetes_service" "grafana-external" {
  metadata {
    name      = "grafana-external"
    namespace = kubernetes_namespace.monitoring.metadata.0.name
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type"            = "nlb"
      "service.beta.kubernetes.io/aws-load-balancer-nlb-target-type" = "ip"
    }
  }
  spec {
    selector = {
      "app.kubernetes.io/name"="grafana"
    }

    port {
      port        = 80
      target_port = 3000
    }

    type = "LoadBalancer"
  }

  depends_on = [
    module.project_eks
  ]
}
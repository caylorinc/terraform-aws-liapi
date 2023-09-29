# This resource installs the argocd helm chart
# https://github.com/argoproj/argo-helm/tree/main/charts/argo-cd
# The ingress class is set to alb, and the ingress annotations are set to use the alb ingress controller
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.46.7"

#   set {
#     name  = "server.ingress.enabled"
#     value = "true"
#   }
#   set {
#     name  = "server.ingress.annotations.alb\\.ingress\\.kubernetes\\.io/scheme"
#     value = "internet-facing"
#   }
#   set {
#     name  = "server.ingress.annotations.alb\\.ingress\\.kubernetes\\.io/target-type"
#     value = "ip"
#   }
#   set {
#     name  = "server.ingress.annotations.kubernetes\\.io/ingress\\.class"
#     value = "alb"
#   }
#   set {
#     name  = "server.ingress.annotations.external-dns\\.alpha\\.kubernetes\\.io/hostname"
#     value = var.argocd_hostname
#   }
#   set {
#     name  = "server.ingress.annotations.alb\\.ingress\\.kubernetes\\.io/backend-protocol-version"
#     value = "HTTP2"
#   }
#   set {
#     name  = "server.ingress.annotations.alb\\.ingress\\.kubernetes\\.io/listen-ports[0].HTTPS"
#     value = 443
#   }
#     values = [yamlencode(
#         {
#             "server.ingress.annotations.alb\\.ingress\\.kubernetes\\.io/listen-ports" = [{"HTTPS" = 443}]
#         }
#     )]
#   set_list {
#     name  = "server.ingress.hosts"
#     value = [var.argocd_hostname]
#   }

  depends_on = [
    module.eks,
    helm_release.aws_load_balancer_controller,
    helm_release.cert_manager,
    helm_release.cluster_autoscaler,
    helm_release.external_dns_controller
  ]
}

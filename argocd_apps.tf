resource "helm_release" "argocd-liapi" {
  name       = "argocd-liapi"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-apps"
  version    = "1.4.1"
  depends_on = [
    module.eks,
    helm_release.argocd
  ]
  values = [
    yamlencode(
      { applications = [{
        name      = "liapi"
        namespace = "default"
        project   = "default"
        source = {
          repoURL        = "https://caylorinc.github.io/liapi-charts/"
          targetRevision = var.liapi_target_revision
          chart          = "liapi"
          helm = {
            valueFiles = ["values.yaml"]
            parameters = [
              {
                name  = "ingress.enabled"
                value = "true"
              },
              {
                name  = "ingress.hosts[0].host"
                value = var.liapi_hostname
              },
              {
                name  = "ingress.hosts[0].paths[0].path"
                value = "/*"
              },
              {
                name = "ingress.hosts[0].paths[0].pathType"
                value = "ImplementationSpecific"
              },
              {
                name  = "ingress.annotations.alb\\.ingress\\.kubernetes\\.io/scheme"
                value = "internet-facing"
              },
              {
                name  = "ingress.annotations.alb\\.ingress\\.kubernetes\\.io/target-type"
                value = "ip"
              },
              {
                name  = "ingress.annotations.kubernetes\\.io/ingress\\.class"
                value = "alb"
              },
              {
                name  = "server.ingress.annotations.external-dns\\.alpha\\.kubernetes\\.io/hostname"
                value = "${var.liapi_hostname}"
              }
            ]
          }
        }
        destination = {
          server    = "https://kubernetes.default.svc"
          namespace = "liapi"
        }
        syncPolicy = {
          automated = {}
          syncOptions = [
            "PrunePropagationPolicy=foreground",
            "CreateNamespace=true"
          ]
        }
      }] }
    )
  ]
}

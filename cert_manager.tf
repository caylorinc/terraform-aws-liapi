# This resource installs the cert-manager helm chart
# https://cert-manager.io/docs/installation/helm/
# https://github.com/cert-manager/cert-manager/tree/master/deploy/charts/cert-manager
resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "1.13.0"
  namespace        = "cert-manager"
  create_namespace = true

  set {
    name  = "rba.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.cert_manager_irsa_role.iam_role_arn
  }

  set {
    name  = "serviceAccount.name"
    value = "cert-manager"
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "installCRDs"
    value = "true"
  }

  set {
    name  = "securityContext.fsGroup"
    value = "1001"
  }
  depends_on = [
    module.eks
  ]
}

# This module creates the IAM role for the cert-manager
# It also handles updating the trust relationship to allow the cert-manager to assume the role
module "cert_manager_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name_prefix              = join("-", [module.eks.cluster_name, "cert-manager"])
  attach_cert_manager_policy    = true
  cert_manager_hosted_zone_arns = var.cert_manager_hosted_zone_arns

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["cert-manager:cert-manager"]
    }
  }

  tags = var.tags
}


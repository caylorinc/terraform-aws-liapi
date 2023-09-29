# This resource installs the external-dns helm chart
# 
resource "helm_release" "external_dns_controller" {
  name       = "external-dns"
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"
  version    = "1.13.1"
  namespace  = "kube-system"

  set {
    name  = "cluster-name"
    value = module.eks.cluster_name
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.external_dns_irsa_role.iam_role_arn
  }

  set {
    name  = "serviceAccount.name"
    value = "external-dns"
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }
  depends_on = [
    module.eks
  ]
}

# This module creates the IAM role for the external-dns
# It also handles updating the trust relationship to allow the external-dns to assume the role
module "external_dns_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name_prefix              = join("-", [module.eks.cluster_name, "external-dns"])
  attach_external_dns_policy    = true
  external_dns_hosted_zone_arns = var.external_dns_hosted_zone_arns

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:external-dns"]
    }
  }

  tags = var.tags
}

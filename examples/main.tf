module "liapi-cluster" {
  source                                   = "../"
  eks_cluster_name                         = "dev-liapi"
  eks_cluster_version                      = "1.27"
  eks_cluster_endpoint_public_access       = true
  eks_cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]
  eks_cluster_endpoint_private_access      = true
  eks_aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::000000000000:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_AdministratorAccess_ffffffffffffffff" # CHANGE ME
      username = "admin"
      groups   = ["system:masters"]
    },
  ]
  tags = {
    environment = "dev"
    project     = "liapi"
  }

  liapi_hostname = "liapi.mydomain.com" # CHANGE ME

  external_dns_hosted_zone_arns = ["arn:aws:route53:::hostedzone/XXXXXXXXXXXXX"] # CHANGE ME
  cert_manager_hosted_zone_arns = ["arn:aws:route53:::hostedzone/XXXXXXXXXXXXX"] # CHANGE ME

}

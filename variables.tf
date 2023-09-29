################################################################################
# EKS Cluster
################################################################################

variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "dev-liapi"
}

variable "eks_cluster_version" {
  description = "Kubernetes `<major>.<minor>` version to use for the EKS cluster (i.e.: `1.27`)"
  type        = string
  default     = "1.27"
}

variable "eks_cluster_endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled"
  type        = bool
  default     = false
}

variable "eks_cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks which can access the Amazon EKS public API server endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "eks_cluster_endpoint_private_access" {
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled"
  type        = bool
  default     = true
}

variable "eks_aws_auth_roles" {
  description = "List of maps of AWS IAM roles to add to the aws-auth ConfigMap"
  type        = list(any)
  default     = []
}

variable "eks_aws_auth_users" {
  description = "List of maps of AWS IAM users to add to the aws-auth ConfigMap"
  type        = list(any)
  default     = []
}

variable "tags" {
  description = "Map of tags to apply to supported resources"
  type        = map(string)
  default     = {}
}

################################################################################
# ArgoCD
################################################################################

# variable "argocd_hostname" {
#   description = "Hostname used for the ArgoCD ingress annotation. Would be used in conjunction with externaldns hosted zone"
#   type        = string
#   default     = null
# }

################################################################################
# Liapi
################################################################################

variable "liapi_hostname" {
  description = "Hostname used in the ingress annotation for the liapi deployment in ArgoCD. Would be used in conjunction with externaldns hosted zone"
  type        = string
  default     = null
}

variable "liapi_target_revision" {
  description = "Target revision of the liapi deployment in ArgoCD"
  type        = string
  default     = "0.1.*"
}


################################################################################
# ExternalDNS
################################################################################

variable "external_dns_hosted_zone_arns" {
  description = "A list of hosted zone ARNs to pass to the external-dns IRSA role policy"
  type        = list(string)
  default     = null
}

################################################################################
# CertManager
################################################################################

variable "cert_manager_hosted_zone_arns" {
  description = "A list of hosted zone ARNs to pass to the cert-manager IRSA role policy"
  type        = list(string)
  default     = null
}

################################################################################
# VPC
################################################################################

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

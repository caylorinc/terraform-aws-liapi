# terraform-aws-liapi

This Terraform module provisions a VPC and an Amazon EKS cluster within AWS, and deploys several controllers and applications to the created EKS cluster.

## Prerequisites

Before you begin, ensure you have met the following requirements:

- **Terraform Installed**: You should have Terraform installed on your local machine. You can download it from [Terraform Downloads](https://www.terraform.io/downloads.html).
- **AWS CLI Configured**: Ensure that the AWS CLI is installed and configured with the necessary access credentials. Follow the [AWS CLI User Guide](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html) for installation and configuration instructions.
- **AWS Account**: You need to have an AWS account with the necessary IAM permissions to create EKS clusters and associated resources.
- **kubectl Installed**: Ensure that you have `kubectl` installed for interacting with the EKS cluster. Follow the [kubectl installation guide](https://kubernetes.io/docs/tasks/tools/install-kubectl/) for more details.
- **Helm Installed**: If you'd like to interact with the cluster using helm as some of the components are installed with helm charts, make sure Helm is installed. Refer to the [Helm Installation Guide](https://helm.sh/docs/intro/install/) for details.

## Module Structure

This module consists of the following key components:

- **VPC**: Creates a Virtual Private Cloud (VPC) for hosting the EKS cluster.
- **EKS Cluster**: Provisions an Amazon Elastic Kubernetes Service (EKS) cluster within the created VPC.
- **Controllers**: Deploys specified controllers to the EKS cluster.
- **Applications**: Installs selected applications to the EKS cluster.

## Usage

To use this module in your Terraform environment, follow the example below:

```hcl
module "liapi" {
  source = "github.com/caylorinc/terraform-aws-liapi"
  // Define your inputs here
}
```

> **_NOTE:_**  Please use the example provider configuration in `provider.tf` to configure the AWS and Kubernetes providers. This may vary depending on your environment.

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~>1.5.7)

- <a name="requirement_helm"></a> [helm](#requirement\_helm) (~> 2.6)

- <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) (2.23.0)

## Providers

The following providers are used by this module:

- <a name="provider_aws"></a> [aws](#provider\_aws) (5.17.0)

- <a name="provider_helm"></a> [helm](#provider\_helm) (2.11.0)

## Modules

The following Modules are called:

### <a name="module_aws_load_balancer_controller_irsa_role"></a> [aws\_load\_balancer\_controller\_irsa\_role](#module\_aws\_load\_balancer\_controller\_irsa\_role)

Source: terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks

Version:

### <a name="module_cert_manager_irsa_role"></a> [cert\_manager\_irsa\_role](#module\_cert\_manager\_irsa\_role)

Source: terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks

Version:

### <a name="module_cluster_autoscaler_irsa_role"></a> [cluster\_autoscaler\_irsa\_role](#module\_cluster\_autoscaler\_irsa\_role)

Source: terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks

Version:

### <a name="module_eks"></a> [eks](#module\_eks)

Source: terraform-aws-modules/eks/aws

Version: ~> 19.16.0

### <a name="module_external_dns_irsa_role"></a> [external\_dns\_irsa\_role](#module\_external\_dns\_irsa\_role)

Source: terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks

Version:

### <a name="module_vpc"></a> [vpc](#module\_vpc)

Source: terraform-aws-modules/vpc/aws

Version: ~> 4.0

## Resources

The following resources are used by this module:

- [helm_release.argocd](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) (resource)
- [helm_release.argocd-liapi](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) (resource)
- [helm_release.aws_load_balancer_controller](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) (resource)
- [helm_release.cert_manager](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) (resource)
- [helm_release.cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) (resource)
- [helm_release.external_dns_controller](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) (resource)
- [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) (data source)
- [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) (data source)

## Required Inputs

No required inputs.

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_argocd_hostname"></a> [argocd\_hostname](#input\_argocd\_hostname)

Description: Hostname used for the ArgoCD ingress annotation. Would be used in conjunction with externaldns hosted zone

Type: `string`

Default: `null`

### <a name="input_cert_manager_hosted_zone_arns"></a> [cert\_manager\_hosted\_zone\_arns](#input\_cert\_manager\_hosted\_zone\_arns)

Description: A list of hosted zone ARNs to pass to the cert-manager IRSA role policy

Type: `list(string)`

Default: `null`

### <a name="input_eks_aws_auth_roles"></a> [eks\_aws\_auth\_roles](#input\_eks\_aws\_auth\_roles)

Description: List of maps of AWS IAM roles to add to the aws-auth ConfigMap

Type: `list(any)`

Default: `[]`

### <a name="input_eks_aws_auth_users"></a> [eks\_aws\_auth\_users](#input\_eks\_aws\_auth\_users)

Description: List of maps of AWS IAM users to add to the aws-auth ConfigMap

Type: `list(any)`

Default: `[]`

### <a name="input_eks_cluster_endpoint_private_access"></a> [eks\_cluster\_endpoint\_private\_access](#input\_eks\_cluster\_endpoint\_private\_access)

Description: Indicates whether or not the Amazon EKS private API server endpoint is enabled

Type: `bool`

Default: `true`

### <a name="input_eks_cluster_endpoint_public_access"></a> [eks\_cluster\_endpoint\_public\_access](#input\_eks\_cluster\_endpoint\_public\_access)

Description: Indicates whether or not the Amazon EKS public API server endpoint is enabled

Type: `bool`

Default: `false`

### <a name="input_eks_cluster_endpoint_public_access_cidrs"></a> [eks\_cluster\_endpoint\_public\_access\_cidrs](#input\_eks\_cluster\_endpoint\_public\_access\_cidrs)

Description: List of CIDR blocks which can access the Amazon EKS public API server endpoint

Type: `list(string)`

Default:

```json
[
  "0.0.0.0/0"
]
```

### <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name)

Description: Name of the EKS cluster

Type: `string`

Default: `"dev-liapi"`

### <a name="input_eks_cluster_version"></a> [eks\_cluster\_version](#input\_eks\_cluster\_version)

Description: Kubernetes `<major>.<minor>` version to use for the EKS cluster (i.e.: `1.27`)

Type: `string`

Default: `"1.27"`

### <a name="input_external_dns_hosted_zone_arns"></a> [external\_dns\_hosted\_zone\_arns](#input\_external\_dns\_hosted\_zone\_arns)

Description: A list of hosted zone ARNs to pass to the external-dns IRSA role policy

Type: `list(string)`

Default: `null`

### <a name="input_liapi_hostname"></a> [liapi\_hostname](#input\_liapi\_hostname)

Description: Hostname used in the ingress annotation for the liapi deployment in ArgoCD. Would be used in conjunction with externaldns hosted zone

Type: `string`

Default: `null`

### <a name="input_liapi_target_revision"></a> [liapi\_target\_revision](#input\_liapi\_target\_revision)

Description: Target revision of the liapi deployment in ArgoCD

Type: `string`

Default: `"0.1.*"`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Map of tags to apply to supported resources

Type: `map(string)`

Default: `{}`

### <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr)

Description: CIDR block for the VPC

Type: `string`

Default: `"10.0.0.0/16"`

## Outputs

No outputs.

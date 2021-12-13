# ----------------------------------------------------------------------------------------------------------------------
# Example : Simple Argo CD installation
# ----------------------------------------------------------------------------------------------------------------------

module "argo_cd" {
  source = "git::https://github.com/runoncloud/terraform-kubernetes-argocd.git?ref=v1.0.0"

  namespace       = "argocd"
  argo_cd_version = "1.5.5"
}

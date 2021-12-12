# ----------------------------------------------------------------------------------------------------------------------
# Example : Simple Argo CD installation
# ----------------------------------------------------------------------------------------------------------------------

module "argo_cd" {
  source = "git::https://github.com/runoncloud/terraform-kubernetes-argocd.git?ref=1.1.2"

  namespace       = "argocd"
  argo_cd_version = "1.8.7"
}

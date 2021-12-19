# ----------------------------------------------------------------------------------------------------------------------
# Example : Simple Argo CD installation
# ----------------------------------------------------------------------------------------------------------------------

module "argocd" {
  source = "git::https://github.com/lablabs/terraform-helm-argocd.git?ref=v0.3.0"

  self_managed_use_helm = true

  # Example how to pass values
  values = yamlencode({
    "global" : {
      "image" : {
        "imagePullPolicy" : "Always"
      }
    }
  })

  # Example how to pass overriding parameters
  # settings = {
  #   "global.image.imagePullPolicy": "IfNotPresent"
  # }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.20.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.0.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.0.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "3.0.0"
    }

    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }

#    k8s = {
#      version = ">= 0.8.0"
#      source  = "banzaicloud/k8s"
#    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.1"
    }
  }
   required_version = ">= 0.12.9, != 0.13.0"
}

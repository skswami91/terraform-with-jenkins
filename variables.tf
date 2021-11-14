variable "region" {
  default     = "ap-south-1"
  description = "AWS region"
}

locals {
  cluster_name = "my-bb-eks-${random_string.suffix.result}"
}

variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = list(string)

  default = [
    "990646871711"
  ]
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      rolearn  = "arn:aws:iam::<AccountNumber>:role/<Role>"
      username = "prg-bb"
      groups   = ["system:masters"]
    },
     {
      rolearn  = "arn:aws:iam::<AccountNumber>:role/<Role>"
      username = "prg-bb-devops"
      groups   = ["system:masters"]
    }
  ]
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      userarn  = "arn:aws:iam::<AccountNumber>:user/<Account-Name>"
      username = "prg-bb-devops"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::<AccountNumber>:user/<Account-Name>"
      username = "prg-bb"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::<AccountNumber>:root"
      username = "prg-bb"
      groups   = ["system:masters"]
    }
  ]
}

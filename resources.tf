resource "random_string" "suffix" {
  length  = 8
  special = false
}

resource "kubernetes_namespace" "jenkins" {
  metadata {
      annotations = {
        name = "jenkins"
      }
      labels = {
        name        = "jenkins"
        description = "continuous-integration-and-delivery"
      }
      name = "jenkins"
  }
}

resource "kubernetes_secret" "docker_secret" {
  metadata {
    name = "docker-secret"
    labels = {
      name = "docker-secret"
      description = "docker-hub-credentials"
    }
  }

  data = {
    ".dockerconfigjson": "{\n\t\"auths\": {\n\t\t\"https://index.docker.io/v1/\": {}\n\t},\n\t\"credsStore\": \"wincred\",\n\t\"stackOrchestrator\": \"swarm\"\n}"
  }

  type = "kubernetes.io/dockerconfigjson"
}


resource "kubernetes_service_account" "ServiceAccount" {
  metadata {
    name = "jenkins"
  }
}

resource "kubernetes_cluster_role" "ClusterRole" {
  metadata {
    annotations = {
      "rbac.authorization.kubernetes.io/autoupdate" = "true"
    }
    labels = {
      "kubernetes.io/bootstrapping" = "rbac-defaults"
    }
    name = "jenkins"
  }
  
  rule {
    api_groups = ["*"]
    resources = [
                  "statefulsets",
                  "services",
                  "replicationcontrollers",
                  "replicasets",
                  "podtemplates",
                  "podsecuritypolicies",
                  "pods",
                  "pods/log",
                  "pods/exec",
                  "podpreset",
                  "poddisruptionbudget",
                  "persistentvolumes",
                  "persistentvolumeclaims",
                  "jobs",
                  "endpoints",
                  "deployments",
                  "deployments/scale",
                  "daemonsets",
                  "cronjobs",
                  "configmaps",
                  "namespaces",
                  "events",
                  "secrets"
                  ]
      verbs      = [
                  "create",
                  "get",
                  "watch",
                  "delete",
                  "list",
                  "patch",
                  "apply",
                  "update",
                  ]
}
  rule {
    api_groups = [""]
    resources  = ["nodes", "pods", "services", "deployments", "namespaces"]
    verbs      = ["create", "get", "list", "watch", "update"]
  }

}

resource "kubernetes_cluster_role_binding" "ClusterRoleBinding" {
  metadata {
    annotations = {
      "rbac.authorization.kubernetes.io/autoupdate" = "true"
    }
    labels = {
      "kubernetes.io/bootstrapping" = "rbac-defaults"
    }
    name = "jenkins"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "jenkins"
  }
  subject {
    kind      = "Group"
    name      = "system:serviceaccounts:jenkins"
    api_group = ""
  }
  subject {
    kind      = "ServiceAccount"
    name      = "jenkins"
    namespace = "jenkins"
  }
}


resource "helm_release" "jenkins" {
  name       = "jenkins"
  repository = "/sandeep/terraform-eks-jenkins/terraform-aws-eks"
  chart      = "helm"
  verify     = false
  timeout    = 30000
  namespace  = "jenkins"
  values = ["${file("/sandeep/terraform-eks-jenkins/terraform-aws-eks/helm/values.yaml")}"]
  set {
    name  = "cluster.enabled"
    value = "true"
  }

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }
}


resource "kubernetes_persistent_volume" "jenkins_pv" {
  metadata {
    name = "jenkins-pv"
    labels = {
      name = "jenkins-pv"
    }
    }
  spec {
    capacity = {
      storage = "8Gi"
    }
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name = "jenkins-pv"
    access_modes = ["ReadWriteOnce"]
    persistent_volume_source {
      host_path {
        path = "/data/jenkins-volume/"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "jenkins-claim" {
  metadata {
    name = "jenkins-claim"
    namespace = "jenkins"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    storage_class_name = "jenkins-pv"
    resources {
      requests = {
        storage = "8Gi"
      }
    }
    selector {
      match_labels = {
        "name" = "jenkins-pv"
      }
    }
    volume_name = "jenkins-pv"
  }
}  

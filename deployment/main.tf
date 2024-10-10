# Create ArgoCD namespace
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "kubernetes_namespace" "web_service" {
  metadata {
    name = "web-service"
  }
}

resource "kubernetes_namespace" "python_service" {
  metadata {
    name = "python-service"
  }
}

resource "kubernetes_manifest" "web_service_deployment" {
  manifest   = yamldecode(file("${path.module}/yaml/gopher-web-services-deployment.yaml"))
  depends_on = [helm_release.argocd]
}

resource "kubernetes_manifest" "web_service_service" {
  manifest   = yamldecode(file("${path.module}/yaml/gopher-web-services-service.yaml"))
  depends_on = [helm_release.argocd]
}

resource "kubernetes_manifest" "gopher_notifier_deployment" {
  manifest   = yamldecode(file("${path.module}/yaml/gopher-notifier-deployment.yaml"))
  depends_on = [helm_release.argocd]
}

resource "kubernetes_manifest" "gopher_notifier_service" {
  manifest   = yamldecode(file("${path.module}/yaml/gopher-notifier-service.yaml"))
  depends_on = [helm_release.argocd]
}

resource "kubernetes_manifest" "gopher_notifier_cm" {
  manifest   = yamldecode(file("${path.module}/yaml/config-map.yaml"))
  depends_on = [helm_release.argocd]
}

resource "kubernetes_manifest" "cluster_role" {
  manifest   = yamldecode(file("${path.module}/yaml/cluster-role.yaml"))
  depends_on = [helm_release.argocd]
}

resource "kubernetes_manifest" "role_binding" {
  manifest   = yamldecode(file("${path.module}/yaml/role-binding.yaml"))
  depends_on = [helm_release.argocd]
}

resource "kubernetes_manifest" "service_role" {
  manifest   = yamldecode(file("${path.module}/yaml/service-access-role.yaml"))
  depends_on = [helm_release.argocd]
}

resource "kubernetes_manifest" "python_role" {
  manifest   = yamldecode(file("${path.module}/yaml/python-role-binding.yaml"))
  depends_on = [helm_release.argocd]
}

resource "kubernetes_manifest" "argocd_application" {
  manifest   = yamldecode(file("${path.module}/yaml/argocd-application.yaml"))
  depends_on = [helm_release.argocd]
}


resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  version    = "5.23.2"

  values = [file("${path.module}/yaml/values.yaml")
  ]

  depends_on = [kubernetes_namespace.argocd]
}
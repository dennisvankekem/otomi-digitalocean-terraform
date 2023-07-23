data "digitalocean_kubernetes_cluster" "cluster_info" {
  name = "otomi-cluster"
  depends_on = [
    digitalocean_kubernetes_cluster.kubernetes_cluster
  ]
}

provider "helm" {

  kubernetes {
    host                   = digitalocean_kubernetes_cluster.kubernetes_cluster.endpoint
    token                  = digitalocean_kubernetes_cluster.kubernetes_cluster.kube_config.0.token
    client_certificate     = base64decode(digitalocean_kubernetes_cluster.kubernetes_cluster.kube_config.0.client_certificate)
    client_key             = base64decode(digitalocean_kubernetes_cluster.kubernetes_cluster.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(digitalocean_kubernetes_cluster.kubernetes_cluster.kube_config.0.cluster_ca_certificate)
  }
}

# Installs Otomi chart on cluster
# Note: This resource waits until all the jobs have finished installing.
# Estimated time to finish for vanilla Otomi: 15 ~ 20min 
# If it takes longer than 20 minutes you might want to check the kubernetes dashboard for status 
resource "helm_release" "otomi" {
  name = "otomi"

  repository = "https://otomi.io/otomi-core"
  chart      = "otomi"

  values        = [file("otomi-values.yaml")]
  timeout       = 1800
  wait_for_jobs = true
}

resource "null_resource" "print_otomi_url" {
  depends_on = [
    helm_release.otomi
  ]
  provisioner "local-exec" {
    command = "kubectl logs jobs/otomi -n default -f"
  }
}

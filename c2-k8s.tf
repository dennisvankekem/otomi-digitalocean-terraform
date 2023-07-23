# Get latest minor version slug from DO 
data "digitalocean_kubernetes_versions" "k8s_version_slug" {
  version_prefix = "1.24."
}

# Provision k8s cluster
# Note: Also sets the created cluster as default in your local kube config 
# Note: For reason stated above you should run terraform as root with sudo -s
#       Our comment out the local-exec block if you don't want this cluster as your default cluster
resource "digitalocean_kubernetes_cluster" "kubernetes_cluster" {
  name    = "otomi-cluster"
  region  = "ams3"
  version = data.digitalocean_kubernetes_versions.k8s_version_slug.latest_version

  node_pool {
    name       = "default-pool"
    size       = "s-8vcpu-16gb"
    node_count = 2
    auto_scale = true
    min_nodes  = 2
    max_nodes  = 5
  }

  provisioner "local-exec" {
    command = "doctl kubernetes cluster kubeconfig save ${digitalocean_kubernetes_cluster.kubernetes_cluster.id}"
  }
}

# Assigns cluster to your project
# Note: Expects that your project already exists.
#       If you want your project to be managed (and also be destroyed!) by terraform 
#       You can comment out the data and resource block and uncomment the playground block
resource "digitalocean_project" "project_folder" {
  name        = "Otomi"
  description = "Kubernetes cluster running Otomi"
  purpose     = "Web Application"
  environment = "Development"
}

resource "digitalocean_project_resources" "project" {
  project   = digitalocean_project.project_folder.id
  resources = [digitalocean_kubernetes_cluster.kubernetes_cluster.urn]
  depends_on = [
    digitalocean_project.project_folder
  ]
}



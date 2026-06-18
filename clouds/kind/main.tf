# clouds/kind/main.tf

provider "kind" {}

terraform {
  required_providers {
    kind = {
      source = "tehcyx/kind"
      version = "~> 0.2.0"
    }
  }
}

resource "kind_cluster" "default" {
  name = "app-cluster"
  kind_config {
    kind        = yamldecode(file("./kind-config.yaml"))["kind"]
    api_version = yamldecode(file("./kind-config.yaml"))["apiVersion"]
    dynamic "node" {
      for_each = lookup(yamldecode(file("./kind-config.yaml")), "nodes", [])
      content {
        role = node.value["role"]
      }
    }
  }
}

# Provider configuration for Helm, pointing to the Kind cluster created above
provider "helm" {
  kubernetes {
    host                   = kind_cluster.default.endpoint
    client_certificate     = kind_cluster.default.client_certificate
    client_key             = kind_cluster.default.client_key
    cluster_ca_certificate = kind_cluster.default.cluster_ca_certificate
  }
}

# Calling the reusable bootstrap module
module "bootstrap" {
  source = "../../modules/k8s-bootstrap"
}

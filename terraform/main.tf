terraform {
    required_providers {
        kind = {
            source = "tehcyx/kind"
            version = "~> 0.2.0"
                }
            }
        }

    provider "kind" {}

    resource "kind_cluster" "default" {
        name = "app-cluster"
        kind_config {
            kind = yamldecode(file("kind-config.yaml"))["kind"]
            api_version = yamldecode(file("kind-config.yaml"))["apiVersion"]
            dynamic "node" {
                for_each = lookup(yamldecode(file("kind-config.yaml")), "nodes", [])
                content {
                    role = node.value["role"]
                        }
                    }
            }
        }
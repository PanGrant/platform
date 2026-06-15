terraform {
    required_providers {
        kind = {
            source = "tehsunn/kind"
            version = "0.6.0"
                }
            }
        }

    provider "kind" {}

    resource "kind_cluster" "default" {
        name = "app-cluster"
        kind_config = file("kind-config.yaml")
        }

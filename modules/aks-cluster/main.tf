resource "azurerm_kubernetes_cluster" "cluster" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  node_resource_group = var.node_resource_group
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version

  ######
/*        fqdn                    = 
       id                      = 
       kubelet_identity        = 
       kubernetes_version      = 
       private_cluster_enabled = 
       private_fqdn            = 
       private_link_enabled    = 
        sku_tier                = "Free"




              + addon_profile {
          + aci_connector_linux {
              + enabled     = (known after apply)
              + subnet_name = (known after apply)
            }

          + azure_policy {
              + enabled = (known after apply)
            }

          + http_application_routing {
              + enabled                            = (known after apply)
              + http_application_routing_zone_name = (known after apply)
            }

          + kube_dashboard {
              + enabled = (known after apply)
            }

          + oms_agent {
              + enabled                    = (known after apply)
              + log_analytics_workspace_id = (known after apply)
              + oms_agent_identity         = (known after apply)
            }
        }

      + auto_scaler_profile {
          + balance_similar_node_groups      = (known after apply)
          + max_graceful_termination_sec     = (known after apply)
          + scale_down_delay_after_add       = (known after apply)
          + scale_down_delay_after_delete    = (known after apply)
          + scale_down_delay_after_failure   = (known after apply)
          + scale_down_unneeded              = (known after apply)
          + scale_down_unready               = (known after apply)
          + scale_down_utilization_threshold = (known after apply)
          + scan_interval                    = (known after apply)
        }
 */


  default_node_pool {
    name            = var.default_pool_name
    node_count      = var.node_count
    vm_size         = var.vm_size
    os_disk_size_gb = var.os_disk_size_gb
    vnet_subnet_id  = var.vnet_subnet_id
    max_pods        = var.max_pods
    type            = var.default_pool_type
    #os_type         = var.os_type
    enable_auto_scaling = true
    min_count           = var.min_count
    max_count           = var.max_count

    tags = merge(
    {
       "environment" = "aks2"
    },
    {
      "aadssh" = "True"
    },
  )
  }
 

  network_profile {
    network_plugin     = var.network_plugin
    network_policy     = "calico"
    service_cidr       = var.service_cidr
    dns_service_ip     = "10.0.0.10"
    docker_bridge_cidr = "172.17.0.1/16"
  }

 /*  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  } */
#####
 addon_profile {
 ## Enable Dash board
  kube_dashboard {
      enabled = true
    }
 }
 
 identity {
    type = "SystemAssigned"
  }

 tags = {
        Environment = "Development"
    }

  lifecycle {
    prevent_destroy = false
  }
}

resource "azurerm_monitor_diagnostic_setting" "aks_cluster" {
  name                       = "${azurerm_kubernetes_cluster.cluster.name}-audit"
  target_resource_id         = azurerm_kubernetes_cluster.cluster.id
  log_analytics_workspace_id = var.diagnostics_workspace_id

  log {
    category = "kube-apiserver"
    enabled  = false  # true to enable

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "kube-controller-manager"
    enabled  = false # true to enable

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "cluster-autoscaler"
    enabled  = true  # true to enable

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "kube-scheduler"
    enabled  = false # true to enable

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "kube-audit"
    enabled  = false # true to enable

    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }
}




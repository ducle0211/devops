###############
####  AKS  ####
###############
resource "azurerm_kubernetes_cluster" "k8s" {
  name                = "k8s-${var.resource_group}"
  location            = var.location
  resource_group_name = var.resource_group
  dns_prefix          = "k8s-${var.resource_group}"
  identity {
    type = "SystemAssigned"
  }
  default_node_pool {
    name            = "system"
    node_count      = 2
    vm_size         = "Standard_B8ms"
    node_labels     = {"dedicated": "service1"}
    max_pods        = 220

  }
  depends_on = [
   azurerm_resource_group.rg,
  ]
  tags = {
    Environment = var.environment
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "worker1" {
  kubernetes_cluster_id = azurerm_kubernetes_cluster.k8s.id
  name                  = "worker1"
  node_count            = 1
  node_taints           = ["dedicated=worker1:NoSchedule"]
  node_labels           = {"dedicated": "worker1"}
  vm_size               = var.nodePool
  zones                 = ["1", "2", "3"]
  depends_on = [
    azurerm_kubernetes_cluster.k8s,
    ]
}

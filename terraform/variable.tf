variable "location" {
    type = string
    description = "Location resource"
}

variable "resource_group" {
    type = string
    description = "Resource group running"
}

variable "environment" {
    type = string
    description = "Environment running"
}

variable "nodePool" {
    type = string
    description = "Node pool for AKS"
}

variable "user_devops" {
    type = string
    description = "ID user to grant IAM storage account"
}

variable "user_local" {
    type = string
    description = "ID user to grant IAM storage account"
}

variable "service_names" {
  description = "Service names"
  type        = list(string)
}
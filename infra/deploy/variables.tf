variable "prefix" {
  description = "Prefix for resources in AWS"
  default     = "raa" # Only lowercase alphanumeric characters and hyphens allowed (Specially for RDS)
}

variable "project" {
  description = "Project name for tagging resources"
  default     = "recipe-app-api"
}

variable "contact" {
  description = "Contact email for tagging resources"
  default     = "raaid.khan47@gmail.com"
}


variable "db_username" {
  description = "Username for the recipe app api database"
  default     = "recipeapp"
}

variable "db_password" {
  description = "Password for the Terraform database"
}

variable "ecr_proxy_image" {
  description = "Path to the ECR repo with the proxy image"
}

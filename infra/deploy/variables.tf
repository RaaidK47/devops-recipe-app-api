variable "prefix" {
  description = "Prefix for resources in AWS"
  default     = "raa" # Keep this Lowercase (Else RDS will give Error)
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

# db_password is defined in docker-compose.yml as "TF_VAR_db_password"
# This is extracted from Secrets in GitHub Actions
variable "db_password" {
  description = "Password for the Terraform database"
}

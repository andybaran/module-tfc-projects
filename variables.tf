variable "organization" {
  description = "Terraform Cloud / Enterprise organization in which to create projects"
  type        = string
}

variable "description" {
  description = "Base description applied to each project (suffix with project index)."
  type        = string
  default     = "Managed by Terraform module tfe-projects"
}

variable "AppIDs" {
  description = "List of App IDs to create projects for"
  type        = map(string)
  default = { "1" = "1ac", "2" = "2bd", "3" = "3ce", "4" = "4df", "5" = "5eg", "6" = "6fh", "7" = "7gi", 
  "8" = "8hj", "9" = "9jk", "10" = "10kl"}
}

terraform {
  required_version = ">= 1.0"

  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = ">= 0.71"
    }
  }
}

module "projects" {
  source       = "../../"
  organization = "my-org"

  app_ids = {
    "1" = "1ac"
    "2" = "2bd"
    "3" = "3ce"
  }

  # Override defaults to demonstrate flexibility.
  queue_all_runs            = true
  team_project_access_level = "write"
}

output "project_names" {
  value = module.projects.project_names
}

output "workspace_names" {
  value = module.projects.workspace_names
}

output "team_ids" {
  value = module.projects.team_ids
}

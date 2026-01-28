module "projects" {
  source       = "../../"
  organization = "my-org"

  app_ids = {
    "1" = "1ac"
    "2" = "2bd"
    "3" = "3ce"
  }
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

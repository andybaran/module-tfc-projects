output "project_names" {
  description = "List of created project names"
  value       = [for p in tfe_project.projects : p.name]
}

output "project_ids" {
  description = "Map of project name to project ID"
  value       = { for p in tfe_project.projects : p.name => p.id }
}

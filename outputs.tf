output "project_ids" {
  description = "Map of app key to project ID."
  value       = { for k, p in tfe_project.projects : k => p.id }
}

output "project_names" {
  description = "List of created project names."
  value       = [for p in tfe_project.projects : p.name]
}

output "workspace_ids" {
  description = "Map of workspace key (env-AppID-name) to workspace ID."
  value       = { for k, w in tfe_workspace.workspaces : k => w.id }
}

output "workspace_names" {
  description = "List of created workspace names."
  value       = [for w in tfe_workspace.workspaces : w.name]
}

output "team_ids" {
  description = "Map of project name to team ID."
  value       = { for k, t in tfe_team.app_teams : tfe_project.projects[k].name => t.id }
}

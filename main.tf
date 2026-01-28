locals {
  workspace_map = merge([
    for app_key, app_id in var.app_ids : {
      for env_key, env_name in var.environments :
      "${env_key}-AppID-${app_id}" => {
        app_key  = app_key
        app_id   = app_id
        env_key  = env_key
        env_name = env_name
      }
    }
  ]...)
}

resource "tfe_project" "projects" {
  for_each     = var.app_ids
  organization = var.organization
  name         = "AppID-${each.value}"
  description  = "${var.description}-${each.value}"

  tags = {
    app_id = each.value
  }
}

resource "tfe_workspace" "workspaces" {
  for_each       = local.workspace_map
  name           = each.key
  organization   = var.organization
  queue_all_runs = var.queue_all_runs
  project_id     = tfe_project.projects[each.value.app_key].id

  tags = {
    environment = each.value.env_name
    app_id      = each.value.app_id
  }
}

resource "tfe_team" "app_teams" {
  for_each     = tfe_project.projects
  name         = each.value.name
  organization = var.organization

  organization_access {
    manage_projects    = false
    manage_workspaces  = false
    manage_agent_pools = false
  }
}

resource "tfe_team_project_access" "app_team_project_access" {
  for_each   = tfe_project.projects
  team_id    = tfe_team.app_teams[each.key].id
  project_id = each.value.id
  access     = var.team_project_access_level
}

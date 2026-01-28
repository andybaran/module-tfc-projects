locals {
  workspace_map = merge([
    for app_key, app_id in var.app_ids : {
      for env_key, env_name in var.environments :
      "${env_key}-${var.project_name_prefix}-${app_id}" => {
        app_key  = app_key
        app_id   = app_id
        env_key  = env_key
        env_name = env_name
      }
    }
  ]...)

  cross_project_access = var.enable_global_read_access ? {
    for pair in flatten([
      for team_key, team in tfe_team.app_teams : [
        for proj_key, proj in tfe_project.projects : {
          key        = "${team_key}-${proj_key}"
          team_id    = team.id
          project_id = proj.id
        } if team_key != proj_key
      ]
    ]) : pair.key => pair
  } : {}
}

resource "tfe_project" "projects" {
  for_each     = var.app_ids
  organization = var.organization
  name         = "${var.project_name_prefix}-${each.value}"
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
    read_workspaces            = var.team_organization_access.read_workspaces
    read_projects              = var.team_organization_access.read_projects
    manage_policies            = var.team_organization_access.manage_policies
    manage_policy_overrides    = var.team_organization_access.manage_policy_overrides
    manage_workspaces          = var.team_organization_access.manage_workspaces
    manage_vcs_settings        = var.team_organization_access.manage_vcs_settings
    manage_providers           = var.team_organization_access.manage_providers
    manage_modules             = var.team_organization_access.manage_modules
    manage_run_tasks           = var.team_organization_access.manage_run_tasks
    manage_projects            = var.team_organization_access.manage_projects
    manage_membership          = var.team_organization_access.manage_membership
    manage_teams               = var.team_organization_access.manage_teams
    manage_organization_access = var.team_organization_access.manage_organization_access
    access_secret_teams        = var.team_organization_access.access_secret_teams
    manage_agent_pools         = var.team_organization_access.manage_agent_pools
  }
}

resource "tfe_team_project_access" "app_team_project_access" {
  for_each   = tfe_project.projects
  team_id    = tfe_team.app_teams[each.key].id
  project_id = each.value.id
  access     = var.team_project_access_level
}

resource "tfe_team_project_access" "cross_project_read_access" {
  for_each   = local.cross_project_access
  team_id    = each.value.team_id
  project_id = each.value.project_id
  access     = "read"
}

resource "tfe_team" "org_admins" {
  count        = var.org_admins_team_name != null ? 1 : 0
  name         = var.org_admins_team_name
  organization = var.organization

  organization_access {
    read_workspaces            = true
    read_projects              = true
    manage_policies            = true
    manage_policy_overrides    = true
    manage_workspaces          = true
    manage_vcs_settings        = true
    manage_providers           = true
    manage_modules             = true
    manage_run_tasks           = true
    manage_projects            = true
    manage_membership          = true
    manage_teams               = true
    manage_organization_access = true
    access_secret_teams        = true
    manage_agent_pools         = true
  }
}

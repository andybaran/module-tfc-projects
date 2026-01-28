resource "tfe_project" "projects" {
  for_each     = var.AppIDs
  organization = var.organization
  name         = "AppID-${each.value}"
  description  = "${var.description}-${each.value}"
  tags = {
    app_id     = each.value
    }
}

resource "tfe_workspace" "dev-workspaces" {
  for_each     = tfe_project.projects
  name                 = "dev-${each.value.name}"
  organization         = var.organization
  queue_all_runs       = false
  project_id           = each.value.id
  tags = {
    environment = "development"
    app_id      = each.value.tags.app_id
    }
  }


resource "tfe_workspace" "test-workspaces" {
  for_each     = tfe_project.projects
  name                 = "test-${each.value.name}"
  organization         = var.organization
  queue_all_runs       = false
  project_id           = each.value.id
  tags = {
    environment = "test"
    app_id      = each.value.tags.app_id
    }
  }


resource "tfe_workspace" "prod-workspaces" {
  for_each     = tfe_project.projects
  name                 = "prod-${each.value.name}"
  organization         = var.organization
  queue_all_runs       = false
  project_id           = each.value.id
  tags = {
    environment = "production"
    app_id      = each.value.tags.app_id
    }
  }


resource "tfe_team" "app_teams" {
  for_each     = tfe_project.projects
  name = "${each.value.name}"
    organization = var.organization
    organization_access {
      manage_projects    = false
      manage_workspaces  = false
      manage_agent_pools = false
    }
}

resource "tfe_team_project_access" "app_team_project_access" {
  for_each    = tfe_project.projects
  team_id     = tfe_team.app_teams[each.key].id
  project_id  = each.value.id
  access      = "maintain"
} 
variable "organization" {
  description = "Terraform Cloud / Enterprise organization in which to create projects."
  type        = string
  nullable    = false

  validation {
    condition     = length(var.organization) > 0
    error_message = "The organization name must not be empty."
  }
}

variable "description" {
  description = "Base description applied to each project (suffixed with the app ID)."
  type        = string
  nullable    = false
  default     = "Managed by Terraform module tfe-projects"
}

variable "project_name_prefix" {
  description = "Prefix used in project and workspace names (e.g. projects are named '{prefix}-{id}', workspaces '{env}-{prefix}-{id}')."
  type        = string
  nullable    = false
  default     = "AppID"

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.project_name_prefix))
    error_message = "The project_name_prefix must contain only alphanumeric characters, hyphens, or underscores."
  }
}

variable "app_ids" {
  description = "Map of keys to app ID strings used to create projects and workspaces."
  type        = map(string)
  nullable    = false

  validation {
    condition     = length(var.app_ids) > 0
    error_message = "The app_ids map must contain at least one entry."
  }

  validation {
    condition     = alltrue([for v in values(var.app_ids) : can(regex("^[a-zA-Z0-9_-]+$", v))])
    error_message = "Each app_ids value must contain only alphanumeric characters, hyphens, or underscores."
  }
}

variable "environments" {
  description = "Map of short environment keys to display names used for workspace creation and tagging."
  type        = map(string)
  nullable    = false
  default = {
    dev  = "development"
    test = "test"
    prod = "production"
  }

  validation {
    condition     = length(var.environments) > 0
    error_message = "The environments map must contain at least one entry."
  }

  validation {
    condition     = alltrue([for k in keys(var.environments) : can(regex("^[a-zA-Z0-9_-]+$", k))])
    error_message = "Each environments key must contain only alphanumeric characters, hyphens, or underscores."
  }
}

variable "team_project_access_level" {
  description = "Access level granted to each app team on its project."
  type        = string
  nullable    = false
  default     = "maintain"

  validation {
    condition     = contains(["admin", "maintain", "write", "read"], var.team_project_access_level)
    error_message = "The team_project_access_level must be one of: admin, maintain, write, read."
  }
}

# See organization_access attributes:
# https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/team#organization_access
variable "team_organization_access" {
  description = "Organization-level access settings applied to each app team."
  nullable    = false
  type = object({
    read_workspaces            = optional(bool, false)
    read_projects              = optional(bool, false)
    manage_policies            = optional(bool, false)
    manage_policy_overrides    = optional(bool, false)
    manage_workspaces          = optional(bool, false)
    manage_vcs_settings        = optional(bool, false)
    manage_providers           = optional(bool, false)
    manage_modules             = optional(bool, false)
    manage_run_tasks           = optional(bool, false)
    manage_projects            = optional(bool, false)
    manage_membership          = optional(bool, false)
    manage_teams               = optional(bool, false)
    manage_organization_access = optional(bool, false)
    access_secret_teams        = optional(bool, false)
    manage_agent_pools         = optional(bool, false)
  })
  default = {}
}

variable "queue_all_runs" {
  description = "Whether workspaces should queue all runs."
  type        = bool
  nullable    = false
  default     = false
}

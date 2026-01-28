# tfe-projects Terraform Module

Creates Terraform Cloud/Enterprise projects, per-environment workspaces, teams, and team-project access for a set of application IDs.

For each app ID the module creates:
- A **project** named `AppID-<id>`
- A **workspace** per environment (default: dev, test, prod) named `<env>-AppID-<id>`
- A **team** named after the project
- A **team-project access** grant at a configurable level (default: `maintain`)

## Resources Created

| Resource | Description |
|----------|-------------|
| `tfe_project` | One project per app ID |
| `tfe_workspace` | One workspace per app ID per environment |
| `tfe_team` | One team per project |
| `tfe_team_project_access` | Grants the team access to its project |

## Requirements

| Name      | Version |
|-----------|---------|
| terraform | >= 1.0  |
| tfe       | >= 0.71 |

## Inputs

| Name | Type | Description | Default | Required |
|------|------|-------------|---------|----------|
| `organization` | `string` | TFE organization in which to create resources | n/a | yes |
| `app_ids` | `map(string)` | Map of keys to app ID strings | n/a | yes |
| `description` | `string` | Base description applied to each project | `"Managed by Terraform module tfe-projects"` | no |
| `environments` | `map(string)` | Map of short env keys to display names | `{ dev = "development", test = "test", prod = "production" }` | no |
| `team_project_access_level` | `string` | Access level for app teams (`admin`, `maintain`, `write`, `read`) | `"maintain"` | no |
| `queue_all_runs` | `bool` | Whether workspaces should queue all runs | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| `project_ids` | Map of app key to project ID |
| `project_names` | List of created project names |
| `workspace_ids` | Map of workspace key to workspace ID |
| `workspace_names` | List of created workspace names |
| `team_ids` | Map of project name to team ID |

## Usage

```hcl
module "projects" {
  source  = "app.terraform.io/my-org/projects/tfe"
  version = "~> 1.0"

  organization = "my-org"

  app_ids = {
    "1" = "1ac"
    "2" = "2bd"
  }
}

output "project_names" {
  value = module.projects.project_names
}
```

See the [`examples/basic`](./examples/basic) directory for a complete example.

## Notes

- Provider configuration (`tfe`) must be supplied by the calling root module.
- `app_ids` values and `environments` keys must only contain alphanumeric characters, hyphens, or underscores (validated at plan time).
- Input/output tables can be regenerated with [`terraform-docs`](https://terraform-docs.io/).

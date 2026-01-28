# tfe-projects Terraform Module

Creates a user-specified number of Terraform Cloud/Enterprise (TFE) projects with a common prefix and a 3-character random suffix for uniqueness.

## Features
- Bulk create N projects (`project_count`)
- Ensures unique names using `prefix-xyz` pattern (xyz = 3 random chars)
- Adds index in description for traceability
- Validates sensible bounds (count <= 50, prefix length <= 40)

## Requirements
| Name      | Version |
|-----------|---------|
| terraform | >= 1.0  |
| tfe       | >= 0.71 |
| random    | >= 3.5  |

## Inputs
| Name | Type | Description | Default | Required |
|------|------|-------------|---------|----------|
| organization | string | TFE organization in which to create projects | n/a | yes |
| prefix | string | Common prefix for all project names (suffix of 3 random chars appended) | n/a | yes |
| project_count | number | Number of projects to create (1..50) | 1 | no |
| description | string | Base description added to each project (index appended) | "Managed by Terraform module tfe-projects" | no |

## Outputs
| Name | Description |
|------|-------------|
| project_names | List of created project names |
| project_ids   | Map of project name => project ID |

## Name Format
Each project name will be: `"<prefix>-<rnd>"` where `<rnd>` is 3 random alphanumeric lowercase characters (may include digits).
Example: `platform-4f2`, `platform-a1c`.

## Usage
```hcl
module "projects" {
  source         = "./modules/tfe-projects"
  organization   = var.organization
  prefix         = "platform"
  project_count  = 5
  description    = "Platform team project set"
}

output "project_names" {
  value = module.projects.project_names
}
```

## Example Generated Names
If `prefix = "demo"` and `project_count = 3`:
```
demo-8b4
demo-1af
demo-92e
```

## Notes
- Random suffix characters are stable after creation; they only change if resource is tainted/destroyed.
- To force regeneration of names, run: `terraform taint random_string.suffix[<index>]` then `apply`.
- Provider configuration (`tfe`) must be in the root module; this submodule does not configure the provider.

## Limitations
- Does not manage team/project associations or access settings.
- `project_count` capped at 50 to avoid accidental large-scale creation.

## Destroying
Removing the module block or setting `project_count = 0` (after manual adjustment) and applying will destroy managed projects.

## Contributing
Feel free to extend with project access controls or tagging in future iterations.

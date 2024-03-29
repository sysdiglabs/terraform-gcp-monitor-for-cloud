terraform {
  required_version = ">= 0.12"
  required_providers {
    sysdig = {
      source  = "sysdiglabs/sysdig"
      version = ">=0.5.47"
    }
    google = {
      source  = "hashicorp/google"
      version = ">=4.49.0"
    }
  }
}

data "google_projects" "org_projects" {
  filter = var.parent_folder_id == "" ? "lifecycleState:ACTIVE" : "parent.id:${var.parent_folder_id} lifecycleState:ACTIVE"
}

module "project" {
  for_each       = toset([for project in data.google_projects.org_projects.projects : project.project_id])
  source         = "github.com/sysdiglabs/terraform-gcp-monitor-for-cloud/single-project"
  gcp_project_id = each.key
}

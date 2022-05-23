terraform {
  required_providers {
    github = {
      source = "integrations/github"
      version = "4.25.0"
    }
  }
}

provider "github" {
  token = "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"
}



resource "github_repository" "Project-ecs" {
  name        = "repo1123"
  description = "My repository"

  visibility = "public"
}

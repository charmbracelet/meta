# meta

Charm's meta configuration files:

- goreleaser configurations
- github actions workflows

## Usage

```yaml
# .goreleaser.yml
includes:
  - from_url:
      url: charmbracelet/meta/main/goreleaser.yaml

variables:
  main: ""
  binary_name: ""
  description: ""
  github_url: ""
  maintainer: ""
  homepage: "https://charm.sh/"
  brew_commit_author_name: ""
  brew_commit_author_email: ""
  brew_owner: charmbracelet
  docker_io_registry_owner: charmcli
  ghcr_io_registry_owner: charmbracelet
```

> You can override the variables you need

```yaml
# .github/workflows/goreleaser.yml
name: goreleaser

on:
  push:
    tags:
      - v*.*.*

concurrency:
  group: goreleaser
  cancel-in-progress: true

jobs:
  goreleaser:
    uses: charmbracelet/meta/.github/workflows/goreleaser.yml@main
    with:
      secrets:
        docker_username: ${{ secrets.DOCKERHUB_USERNAME }}
        docker_token: ${{ secrets.DOCKERHUB_TOKEN }}
        gh_pat: ${{ secrets.PERSONAL_ACCESS_TOKEN }}
        goreleaser_key: ${{ secrets.GORELEASER_KEY }
```

You'll need to set the secrets used.

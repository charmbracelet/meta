# meta

This repo contains Charm’s meta configuration files:

- GoReleaser configurations
- GitHub Actions workflows

## Related docs

- [GitHub: Reusing Workflows](https://docs.github.com/en/actions/learn-github-actions/reusing-workflows)
- [GoReleaser: includes](https://goreleaser.com/customization/includes/)

## Usage

### GoReleaser release

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
  homepage: "https://charm.land/"
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
    secrets:
      docker_username: ${{ secrets.DOCKERHUB_USERNAME }}
      docker_token: ${{ secrets.DOCKERHUB_TOKEN }}
      gh_pat: ${{ secrets.PERSONAL_ACCESS_TOKEN }}
      goreleaser_key: ${{ secrets.GORELEASER_KEY }
```

You'll need to set the secrets used.

### GoReleaser snapshot

```yaml
# .github/workflows/snapshot.yml
name: snapshot

on: [push, pull_request]

jobs:
  snapshot:
    uses: charmbracelet/meta/.github/workflows/snapshot.yml@main
    secrets:
      goreleaser_key: ${{ secrets.GORELEASER_KEY }}
```

### GoReleaser nightly

```yaml
# .github/workflows/nightly.yml
name: nightly

on: push

jobs:
  nightly:
    uses: charmbracelet/meta/.github/workflows/nightly.yml@main
    secrets:
      docker_username: ${{ secrets.DOCKERHUB_USERNAME }}
      docker_token: ${{ secrets.DOCKER_PASSWORD }}
      goreleaser_key: ${{ secrets.GORELEASER_KEY }}
```

```yaml
# .github/workflows/pr-comment.yml
name: pr-comment

on:
  workflow_run:
    workflows: [build]
    types: [completed]

jobs:
  pr-comment:
    uses: charmbracelet/meta/.github/workflows/pr-comment.yml@main
```

---

Part of [Charm](https://charm.land).

<a href="https://charm.land/"><img alt="The Charm logo" src="https://stuff.charm.sh/charm-badge.jpg" width="400"></a>

<!-- prettier-ignore -->
Charm热爱开源 • Charm loves open source

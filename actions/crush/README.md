# Crush GitHub Actions

Crush is an autonomous AI coding agent that runs in GitHub Actions. It can implement issues, review PRs, answer questions, and address review feedback.

## Quick Start

1. **Set up repository variables** (Settings → Secrets and variables → Actions → Variables):
   - `CRUSH_PROVIDER`: Your AI provider (e.g., `anthropic`, `openai`)
   - `CRUSH_MODEL`: The model to use (e.g., `claude-sonnet-4-20250514`, `gpt-4o`)
   - `CRUSH_SMALL_MODEL` (optional): A smaller/faster model for routing decisions (defaults to `CRUSH_MODEL`)

2. **Add the provider API key** as a secret (Settings → Secrets and variables → Actions → Secrets):
   - `PROVIDER_API_KEY`: Your AI provider's API key

3. **Create `.github/workflows/ai.yml`** in your repository:

```yaml
name: ai

on:
  issues:
    types: [assigned]
  pull_request:
    types: [assigned]
  issue_comment:
    types: [created]
  pull_request_review:
    types: [submitted]

permissions:
  contents: write
  pull-requests: write
  issues: write

jobs:
  crush:
    uses: charmbracelet/meta/.github/workflows/crush.yml@main
    secrets:
      provider_api_key: ${{ secrets.PROVIDER_API_KEY }}
```

> **Required**: You must set `CRUSH_PROVIDER` and `CRUSH_MODEL` as repository variables, or pass them as workflow inputs (`provider` and `model`).

## Features

### Trigger Methods

| Method | Description |
|--------|-------------|
| **@mention** | Comment `@charmcrush <request>` on any issue or PR |
| **Assignment** | Assign the bot user to an issue or PR |
| **PR Review** | Leave a review on a PR created by the bot |

### Built-in Actions

| Action | Context | Description |
|--------|---------|-------------|
| `implement` | Issues | Implement features, fix bugs, create PRs |
| `review` | PRs | Review code for correctness, security, quality |
| `fix` | PRs | Address review feedback and requested changes |
| `ask` | Both | Answer questions about the codebase |

The router automatically selects the appropriate action based on context and your message.

## Configuration

### Workflow Inputs

| Input | Required | Default | Description |
|-------|----------|---------|-------------|
| `trigger` | No | `@charmcrush` | Word that activates Crush in comments |
| `trigger_username` | No | `charmcrush` | Bot username for assignment triggers |
| `allow_external_triggers` | No | `false` | Allow non-collaborators to trigger |
| `git_user_name` | No | `charmcrush` | Git user.name for commits |
| `git_user_email` | No | `charmcrush@users.noreply.github.com` | Git user.email for commits |
| `branch_prefix` | No | `crush` | Prefix for created branches |
| `provider` | No | `vars.CRUSH_PROVIDER` | AI provider (anthropic, openai, etc.) |
| `model` | No | `vars.CRUSH_MODEL` | AI model name |
| `small_model` | No | `vars.CRUSH_SMALL_MODEL` | Smaller model for routing |
| `agent_instructions` | No | - | Path to custom instructions file |
| `config_json` | No | `{}` | Additional crush config as JSON |
| `timeout_minutes` | No | `30` | Workflow timeout |
| `artifact_retention_days` | No | `7` | Days to keep artifacts |

### Secrets

| Secret | Required | Description |
|--------|----------|-------------|
| `gh_token` | No | GitHub token (defaults to `GITHUB_TOKEN` if not provided) |
| `provider_api_key` | Yes | API key for your AI provider |

> **Note**: Using the default `GITHUB_TOKEN` works for most operations. Commits will still be attributed to the configured `git_user_name`/`git_user_email` (default: charmcrush). However, a dedicated bot account PAT is recommended for:
> - Triggering workflows on created PRs (GITHUB_TOKEN can't trigger workflows)
> - Avoiding rate limits on busy repositories
> - Assignment-based triggers (requires a real user account)

### Repository Variables (Required)

Set these in your repository settings (Settings → Secrets and variables → Actions → Variables):

| Variable | Required | Description |
|----------|----------|-------------|
| `CRUSH_PROVIDER` | **Yes** | AI provider (`anthropic`, `openai`, etc.) |
| `CRUSH_MODEL` | **Yes** | AI model (`claude-sonnet-4-20250514`, `gpt-4o`, etc.) |
| `CRUSH_SMALL_MODEL` | No | Smaller model for routing (defaults to `CRUSH_MODEL`) |

Alternatively, pass `provider` and `model` as workflow inputs.

## Setup Guide

### Quick Setup (Using GITHUB_TOKEN)

The simplest setup uses the default GitHub Actions token:

1. **Add the AI provider secret**:
   - Go to Settings → Secrets and variables → Actions
   - Add `PROVIDER_API_KEY` with your AI provider's API key

2. **Add repository variables**:
   - Go to Settings → Secrets and variables → Actions → Variables
   - Add `CRUSH_PROVIDER` (e.g., `anthropic`, `openai`)
   - Add `CRUSH_MODEL` (e.g., `claude-sonnet-4-20250514`, `gpt-4o`)

3. **Create the workflow** as shown in [Quick Start](#quick-start)

Commits will be attributed to `charmcrush` by default.

### Full Setup (With Bot Account)

For the best experience, create a dedicated bot account:

1. **Create a bot account** on GitHub

2. **Generate a Personal Access Token**:
   - Log in as the bot account
   - Go to Settings → Developer settings → Personal access tokens → Fine-grained tokens
   - Create a token with these permissions:
     - **Contents**: Read and write
     - **Issues**: Read and write
     - **Pull requests**: Read and write
     - **Metadata**: Read-only

3. **Add secrets to your repository**:
   - Go to Settings → Secrets and variables → Actions
   - Add `BOT_TOKEN` with the PAT
   - Add `PROVIDER_API_KEY` with your AI provider's API key

4. **Add repository variables**:
   - Add `CRUSH_PROVIDER` (e.g., `anthropic`, `openai`)
   - Add `CRUSH_MODEL` (e.g., `claude-sonnet-4-20250514`, `gpt-4o`)

5. **Update the workflow** to use the bot token:

```yaml
jobs:
  crush:
    uses: charmbracelet/meta/.github/workflows/crush.yml@main
    with:
      trigger: "@mybot"
      trigger_username: "mybot-account"
    secrets:
      gh_token: ${{ secrets.BOT_TOKEN }}
      provider_api_key: ${{ secrets.PROVIDER_API_KEY }}
```

## Usage Examples

### Implement an Issue

```
@charmcrush implement this feature
```

Or simply assign the bot to the issue.

### Review a PR

```
@charmcrush please review this PR
```

Or assign the bot to the PR.

### Ask a Question

```
@charmcrush how does the authentication system work?
```

### Address Review Feedback

Just leave a review on a PR created by the bot - it will automatically respond.

## Custom Agent Instructions

Create a markdown file with custom instructions and reference it:

```yaml
jobs:
  crush:
    uses: charmbracelet/meta/.github/workflows/crush.yml@main
    with:
      agent_instructions: .github/CRUSH_INSTRUCTIONS.md
    secrets:
      provider_api_key: ${{ secrets.PROVIDER_API_KEY }}
```

Example `.github/CRUSH_INSTRUCTIONS.md`:

```markdown
# Project-Specific Instructions

## Tech Stack
- Go 1.21+
- PostgreSQL database
- React frontend

## Conventions
- Use `errgroup` for concurrent operations
- All public functions must have godoc comments
- Tests use testify/assert

## Testing
Run tests with: `go test ./...`
Run lints with: `golangci-lint run`
```

## Additional Configuration

Pass extra configuration via `config_json`. This is merged with the base configuration.

See the full [Crush config schema](https://github.com/charmbracelet/crush/blob/main/schema.json) for all options.

### Model Options

Configure model parameters like temperature and max tokens:

```yaml
jobs:
  crush:
    uses: charmbracelet/meta/.github/workflows/crush.yml@main
    with:
      config_json: |
        {
          "models": {
            "large": {
              "provider": "anthropic",
              "model": "claude-sonnet-4-20250514",
              "max_tokens": 16384,
              "temperature": 0.7
            }
          }
        }
    secrets:
      provider_api_key: ${{ secrets.PROVIDER_API_KEY }}
```

Available model options:

| Option | Type | Description |
|--------|------|-------------|
| `max_tokens` | integer | Maximum tokens for responses (up to 200000) |
| `temperature` | number | Sampling temperature (0-1) |
| `top_p` | number | Top-p (nucleus) sampling (0-1) |
| `top_k` | integer | Top-k sampling parameter |
| `reasoning_effort` | string | For OpenAI reasoning models: `low`, `medium`, `high` |
| `think` | boolean | Enable thinking mode for Anthropic models |

### General Options

```yaml
config_json: |
  {
    "options": {
      "disable_auto_summarize": true,
      "context_paths": [".github/CRUSH.md", "docs/CONTRIBUTING.md"],
      "disabled_tools": ["sourcegraph"],
      "attribution": {
        "trailer_style": "co-authored-by",
        "generated_with": false
      }
    }
  }
```

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `context_paths` | string[] | - | Additional files to include as context |
| `disabled_tools` | string[] | - | Tools to disable (e.g., `bash`, `sourcegraph`) |
| `disable_auto_summarize` | boolean | false | Disable automatic conversation summarization |
| `debug` | boolean | false | Enable debug logging |

### Attribution Options

Control how Crush attributes its contributions:

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `trailer_style` | string | `assisted-by` | Commit trailer: `none`, `co-authored-by`, `assisted-by` |
| `generated_with` | boolean | true | Add "Generated with Crush" to commits/PRs |

### MCP Servers

Add additional MCP (Model Context Protocol) servers:

```yaml
config_json: |
  {
    "mcp": {
      "filesystem": {
        "type": "stdio",
        "command": "npx",
        "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/allowed/dir"]
      },
      "custom-api": {
        "type": "http",
        "url": "https://api.example.com/mcp/",
        "headers": {
          "Authorization": "Bearer ${{ secrets.CUSTOM_API_KEY }}"
        }
      }
    }
  }
```

MCP server types:
- `stdio`: Local command-based servers
- `http`: HTTP-based remote servers  
- `sse`: Server-Sent Events servers

### Permissions

Auto-approve specific tools (use with caution):

```yaml
config_json: |
  {
    "permissions": {
      "allowed_tools": ["view", "glob", "grep", "ls"]
    }
  }
```

## Actions Reference

The workflow uses these composite actions internally:

| Action | Description |
|--------|-------------|
| `actions/crush/setup` | Install Crush and configure environment |
| `actions/crush/route` | Route request to appropriate action |
| `actions/crush/execute` | Execute action with context and prompts |
| `actions/crush/run` | Low-level Crush execution |

You can use these actions directly for custom workflows:

```yaml
- name: Setup Crush
  id: setup
  uses: charmbracelet/meta/actions/crush/setup@main
  with:
    provider: anthropic
    provider_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
    model: claude-sonnet-4-20250514
    gh_token: ${{ secrets.BOT_TOKEN }}

- name: Run Custom Prompt
  uses: charmbracelet/meta/actions/crush/run@main
  with:
    prompt: "Analyze the codebase and suggest improvements"
    crush_dir: ${{ steps.setup.outputs.crush_dir }}
    data_dir: ${{ steps.setup.outputs.data_dir }}
    status_log: ${{ steps.setup.outputs.status_log }}
    gh_token: ${{ secrets.BOT_TOKEN }}
```

## Custom Actions

You can extend the built-in actions (`implement`, `review`, `fix`, `ask`) or create entirely new ones.

### Config-Based Custom Actions (Recommended)

The easiest way to add custom actions is through a `.github/crush.yml` config file:

```yaml
# .github/crush.yml
actions:
  security-audit:
    description: "Deep security review focusing on vulnerabilities"
    context: [pr]
    prompt: .github/prompts/security-audit.md

  docs:
    description: "Generate or update documentation"
    context: [issue, pr]
    prompt: .github/prompts/docs.md

  refactor:
    description: "Refactor code for better maintainability"
    context: [issue]
    prompt: .github/prompts/refactor.md
```

That's it! The workflow automatically:
1. Reads `.github/crush.yml` on each trigger
2. Merges custom actions with built-in ones
3. Routes to the appropriate action based on context
4. Uses your custom prompt

**No workflow changes needed.**

### Writing Custom Prompts

Create prompt files in `.github/prompts/` (or wherever you specify). Prompts support these template variables:

| Variable | Description |
|----------|-------------|
| `{{ context_number }}` | Issue or PR number |
| `{{ context_type }}` | `issue` or `pr` |
| `{{ branch_prefix }}` | Branch prefix for new branches |
| `{{ trigger_user }}` | User who triggered the action |
| `{{ user_message }}` | The user's message/request |
| `{{ review_context }}` | Review details (for `fix` action) |
| `{{ context_data }}` | Full issue/PR data as JSON |
| `{{ diff }}` | PR diff (for PR context) |

Example custom prompt (`.github/prompts/security-audit.md`):

```markdown
# Security Audit for PR #{{ context_number }}

## Your Mission

Perform a security-focused review of this pull request.

## GitHub MCP Tools

Use `mcp_github_add_issue_comment` to post your findings.
Use `mcp_github_pull_request_review_write` to submit your review.

## Checklist

Review the code for:
- [ ] SQL injection vulnerabilities
- [ ] Cross-site scripting (XSS)
- [ ] Authentication/authorization issues
- [ ] Exposed secrets or credentials
- [ ] Insecure dependencies
- [ ] Input validation

## PR Details

{{ context_data }}

## Changes

```diff
{{ diff }}
```

## Instructions

1. Acknowledge on PR #{{ context_number }}
2. Review each file for security issues
3. Submit review with `REQUEST_CHANGES` if issues found, `APPROVE` if secure
```

### Overriding Built-in Actions

You can override built-in actions by using the same name in your config:

```yaml
# .github/crush.yml
actions:
  # Override the built-in review action with a custom prompt
  review:
    description: "Review with project-specific guidelines"
    context: [pr]
    prompt: .github/prompts/custom-review.md
```

### Advanced: Manual Custom Prompts

For fully custom workflows, you can pass actions and prompts directly:

```yaml
- name: Execute with Custom Prompt
  uses: charmbracelet/meta/actions/crush/execute@main
  with:
    action: review
    custom_prompt: .github/prompts/security-review.md
    context_type: pr
    context_number: ${{ github.event.pull_request.number }}
    trigger_user: ${{ github.event.sender.login }}
    crush_dir: ${{ steps.setup.outputs.crush_dir }}
    data_dir: ${{ steps.setup.outputs.data_dir }}
    status_log: ${{ steps.setup.outputs.status_log }}
    gh_token: ${{ secrets.GITHUB_TOKEN }}
```

### Fully Custom Workflow

For complete control, build your own workflow using the individual actions:

```yaml
name: custom-crush

on:
  issue_comment:
    types: [created]

jobs:
  custom:
    runs-on: ubuntu-latest
    if: contains(github.event.comment.body, '@charmcrush audit')
    steps:
      - uses: actions/checkout@v4

      - name: Setup Crush
        id: setup
        uses: charmbracelet/meta/actions/crush/setup@main
        with:
          provider: anthropic
          provider_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          model: claude-sonnet-4-20250514
          gh_token: ${{ secrets.GITHUB_TOKEN }}

      - name: Run Security Audit
        uses: charmbracelet/meta/actions/crush/run@main
        with:
          prompt: |
            Perform a security audit of this repository.
            
            Focus on:
            - Dependency vulnerabilities
            - Secret exposure risks
            - Common security anti-patterns
            
            Post your findings as a comment on issue #${{ github.event.issue.number }}
            using mcp_github_add_issue_comment.
          crush_dir: ${{ steps.setup.outputs.crush_dir }}
          data_dir: ${{ steps.setup.outputs.data_dir }}
          status_log: ${{ steps.setup.outputs.status_log }}
          gh_token: ${{ secrets.GITHUB_TOKEN }}
```

## Troubleshooting

### Bot doesn't respond to comments

1. Check the workflow runs in Actions tab
2. Verify the trigger word matches exactly
3. Ensure the commenter has collaborator access (or enable `allow_external_triggers`)

### Bot can't push changes

1. Verify the `gh_token` has write access to contents
2. Check branch protection rules allow the bot

### Authentication errors

1. Verify the `provider_api_key` is correct
2. Check the provider name matches (anthropic, openai, etc.)

### Debugging with Artifacts

Every workflow run uploads artifacts containing:
- **crush_dir**: Full configuration, prompts, and context data
  - `crush.json` - The generated Crush configuration
  - `prompt.txt` - The final prompt sent to the AI
  - `context.json` - Issue/PR data fetched from GitHub
  - `diff.txt` - PR diff (for PR contexts)
  - `output.txt` - Crush's output
  - `status.log` - Status updates during execution
- **data_dir**: Crush's conversation database and cache

To download artifacts:
1. Go to the workflow run in the Actions tab
2. Scroll to "Artifacts" at the bottom
3. Download `crush-{issue|pr}-{number}-{run_id}`

Artifacts are retained for 7 days by default (configurable via `artifact_retention_days`).

## Security

- The bot only responds to collaborators by default
- API keys are passed as secrets, never logged
- Artifacts are retained for debugging but expire automatically
- The bot uses GitHub's MCP server for safe API interactions

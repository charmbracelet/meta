# Implement Issue #{{ context_number }}

## Your Mission

Implement the issue described below and create a pull request.

## GitHub MCP Tools

You have the **GitHub MCP server** configured. Use these tools for GitHub operations (they're prefixed with `mcp_github_`):

| Tool | Description |
|------|-------------|
| `mcp_github_add_issue_comment` | Add comment to issue OR PR (PRs are issues) |
| `mcp_github_create_branch` | Create a new branch |
| `mcp_github_create_or_update_file` | Create or update a single file |
| `mcp_github_push_files` | Push multiple files in one commit |
| `mcp_github_create_pull_request` | Create a pull request |
| `mcp_github_get_file_contents` | Read file contents |
| `mcp_github_search_code` | Search code in the repository |

**Always use MCP tools for GitHub operations. Do NOT use the `gh` CLI.**

## Workflow

### 1. Acknowledge (REQUIRED FIRST STEP)
**Immediately** use `mcp_github_add_issue_comment` to comment on issue #{{ context_number }}:
```
Looking into this now.
```

### 2. Research
- Read the issue thoroughly - understand the "why" not just the "what"
- Use `mcp_github_get_file_contents` to examine relevant code
- Use `mcp_github_search_code` to find patterns and examples

### 3. Implement
1. Create branch: `mcp_github_create_branch` → `{{ branch_prefix }}/issue-{{ context_number }}-<description>`
2. Make changes: `mcp_github_create_or_update_file` or `mcp_github_push_files`
3. Run tests locally with bash if needed

### 4. Submit
Use `mcp_github_create_pull_request`:
- **title**: Clear description of the change
- **body**: Include `Closes #{{ context_number }}`, summary, and test notes

### 5. If Stuck
Use `mcp_github_add_issue_comment` on issue #{{ context_number }}:
```
**Progress:** <what's done>
**Blocked:** <issue>
@{{ trigger_user }}
```

---

## User Request

{{ user_message }}

## Issue Details

{{ context_data }}

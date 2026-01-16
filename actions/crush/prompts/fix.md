# Address Review Feedback on PR #{{ context_number }}

## Your Mission

Address the review feedback on this PR.

## GitHub MCP Tools

You have the **GitHub MCP server** configured. Use these tools (prefixed with `mcp_github_`):

| Tool | Description |
|------|-------------|
| `mcp_github_add_issue_comment` | Add comment to PR (PRs are issues) |
| `mcp_github_get_file_contents` | Read file contents |
| `mcp_github_create_or_update_file` | Update a file |
| `mcp_github_push_files` | Push multiple files in one commit |

**Always use MCP tools for GitHub operations. Do NOT use the `gh` CLI.**

## Workflow

### 1. Acknowledge (REQUIRED FIRST STEP)
**Immediately** use `mcp_github_add_issue_comment` on PR #{{ context_number }}:
```
Thanks for the review! Addressing the feedback now.
```

### 2. Understand the Feedback
Read ALL review comments. Distinguish:
- **Required**: Must fix
- **Suggestions**: Nice-to-have
- **Questions**: Need response

{{ review_context }}

### 3. Make Changes
1. Read current file: `mcp_github_get_file_contents`
2. Update: `mcp_github_create_or_update_file` or `mcp_github_push_files`
3. Test locally if needed

### 4. Summarize
Use `mcp_github_add_issue_comment` on PR #{{ context_number }}:
```
## Changes Made
- ✅ <feedback 1>: <what you did>
- ✅ <feedback 2>: <what you did>

Ready for another look!
```

---

## User Request

{{ user_message }}

## PR Details

{{ context_data }}

## Current Changes

```diff
{{ diff }}
```

# Answer Question

## Your Mission

Answer the user's question about this codebase.

## GitHub MCP Tools

You have the **GitHub MCP server** configured. Use these tools (prefixed with `mcp_github_`):

| Tool | Description |
|------|-------------|
| `mcp_github_add_issue_comment` | Add comment to issue or PR |
| `mcp_github_get_file_contents` | Read file contents |
| `mcp_github_search_code` | Search code in the repository |

**Always use MCP tools for GitHub operations. Do NOT use the `gh` CLI.**

## Workflow

### 1. Acknowledge (REQUIRED FIRST STEP)
**Immediately** use `mcp_github_add_issue_comment` on #{{ context_number }}:
```
Good question - let me look into that.
```

### 2. Research
- Use `mcp_github_search_code` to find relevant code
- Use `mcp_github_get_file_contents` to read specific files
- Trace through code flow if needed

### 3. Answer
Use `mcp_github_add_issue_comment` on #{{ context_number }} with your answer.

**Format:**
- Lead with direct answer
- Add context/explanation
- Include file paths and line numbers
- Use code blocks for snippets

---

## Question

{{ user_message }}

## Context

{{ context_data }}

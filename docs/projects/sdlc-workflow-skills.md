# SDLC Workflow Skills

Slash commands for AI-assisted software development workflows — connecting your editor to Jira, GitHub, and Azure DevOps.

```bash
/create-task --type=story for user authentication
/create-plan for PROJ-123
/start-task PROJ-123
/complete-task PROJ-123
```

Install with the skills CLI and they show up in Cursor, Claude Code, or any Agent Skills-compatible environment:

```bash
npx skills add fancy-bread/sdlc-workflow-skills -a cursor
```

## Skills

- **Product:** `/create-task`, `/decompose-task`
- **Planning:** `/refine-task`, `/create-plan`
- **Development:** `/start-task`, `/complete-task`
- **Quality:** `/create-test`, `/review-code`
- **Utilities:** `/mcp-status`, `/setup-asdlc`

## How It Works

Skills are Markdown instruction files with frontmatter. When invoked, the AI reads your project context and executes the workflow — creating Jira issues, branching in GitHub, running reviews — consistently across projects and teams.

## Stack

Markdown (Agent Skills format), MCP servers for Jira / GitHub / Azure DevOps, Cursor IDE (primary environment).

## Links

- [GitHub](https://github.com/fancy-bread/sdlc-workflow-skills)
- [Documentation](https://fancy-bread.github.io/sdlc-workflow-skills)

# Agent Context Explorer

**ACE** is a VS Code/Cursor extension that makes AI agent artifacts visible across your workspaces — rules, commands, skills, and specs in one tree, auto-refreshing as files change.

## What It Shows

**Workspaces view** — per-project artifacts for every open workspace:

- Cursor rules, commands, and skills
- Claude Code rules, commands, and skills
- Feature specs (`specs/*/spec.md`)

**Agents view** — your global agent configuration across `~/.cursor/`, `~/.claude/`, and `~/.agents/`.

Click any item to open it read-only. Use the `+` button to add external projects. The tree updates within seconds of any file change.

## MCP Server

ACE exposes an MCP server so AI assistants can query project context on demand — rules, commands, skills, specs — without loading entire codebases.

In Cursor it registers automatically via the VS Code MCP Extension API. No setup needed.

## Stack

TypeScript, VS Code Extension API, MCP server.

## Links

- [GitHub](https://github.com/fancy-bread/agent-context-explorer)

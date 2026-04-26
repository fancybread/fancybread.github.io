# Bureau

**Spec file in. Pull request out.**

Bureau is an autonomous pipeline for AI-assisted software development. Hand it an approved spec; it validates, plans, builds, reviews, and opens a pull request. Everything in between is not your problem.

```
[bureau] run.started  id=run-a3f9c2b1  spec=specs/002-auth/spec.md
[bureau] phase.completed  phase=validate_spec
[bureau] phase.completed  phase=builder  duration=4m12s
[bureau] phase.completed  phase=reviewer  verdict=pass
[bureau] pr.created  pr=https://github.com/org/repo/pull/42  duration=6m01s
```

## Pipeline

| Phase | Role |
|-------|------|
| `validate_spec` | Confirms spec is complete and unambiguous before any work starts |
| `repo_analysis` | Reads the target repo config to understand the stack |
| `builder` | Implements against the spec; runs tests, iterates until passing |
| `reviewer` | Scores output across five axes against the spec |
| `pr_create` | Opens a pull request with a structured run summary |

If a phase can't proceed — ambiguous spec, missing contract, tests failing after retries — bureau pauses and tells you exactly what it needs. A wrong guess is worse than a paused run.

## Stack

Python, [LangGraph](https://github.com/langchain-ai/langgraph), Anthropic API, SQLite (run checkpointing), GitHub CLI, CloudEvents 1.0 NDJSON output, optional Kafka publishing.

## Links

- [GitHub](https://github.com/fancy-bread/bureau)

# Contributing

Thanks for contributing!

## Quick start

1. Fork & clone, then create a branch: `git checkout -b feat/your-change`
2. Build & test: `./mvnw -B clean verify`
3. Open a PR against `main` using the PR template.

## Branches

This repository uses a **trunk-based** model: `main` is the only long-lived branch.

| Branch | Purpose |
|--------|---------|
| `main` | Default branch, always green, receives squash PRs |
| `feat/…`, `fix/…`, `refactor/…`, `ci/…`, `chore/…`, `docs/…` | Short-lived feature branches (max 2 days) |

### Branch Naming

| Prefix | Purpose | Example |
|--------|---------|---------|
| `feat/` | New feature | `feat/revision-property` |
| `fix/` | Bug fix | `fix/enforcer-rule` |
| `refactor/` | Restructure | `refactor/release-workflow` |
| `ci/` | CI/CD changes | `ci/sota-2026-actions` |
| `chore/` | Deps, config | `chore/bump-wrapper` |
| `docs/` | Documentation | `docs/release-process` |

## Conventions

- Follow the existing POM structure and formatting.
- Keep changes minimal and focused; one concern per PR.
- Use Conventional Commits (`feat:`, `fix:`, `chore:`, `docs:`, ...) to enable auto-changelogs.

## CI gates

A PR is mergeable when:
- CI (build + tests) is green
- Security workflow is green
- SonarQube quality gate passes *(maintainer-triggered, requires `SONAR_TOKEN`)*

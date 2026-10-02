# Contributing

Thanks for contributing!

## Quick start

1. Fork & clone, then create a branch: `git checkout -b feat/your-change`
2. Build & test: `./mvnw -B clean verify`
3. Open a PR against `develop` using the PR template.

## Branches

| Branch | Purpose |
|--------|---------|
| `develop` | Default branch, receives PRs |
| `master` | Release / site branch (no direct PRs) |

## Conventions

- Follow the existing POM structure and formatting.
- Keep changes minimal and focused; one concern per PR.
- Use Conventional Commits (`feat:`, `fix:`, `chore:`, `docs:`, ...) to enable auto-changelogs.

## CI gates

A PR is mergeable when:
- CI (build + tests) is green
- Security workflow is green
- SonarQube quality gate passes

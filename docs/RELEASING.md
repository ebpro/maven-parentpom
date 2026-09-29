# Release Standard — Trunk-Based Two-Tier Publishing

> **Status**: Standard for all `ebpro` Java repositories
> **Last updated**: 2026-09-25
> **Applies to**: Any Maven project using `maven-parentpom` ≥ 0.1.20

## Philosophy

- **Trunk-based development**: `develop` (or `main`) is the single source of truth
- **Tags are releases**: No release branches. A tag IS the release.
- **Two-tier publishing**:
  - **Tier 1 — GitHub Packages** (internal): Automatic on every release tag
  - **Tier 2 — Maven Central** (public): Opt-in, explicit human decision
- **CI does everything**: No manual `mvn release:prepare` commands
- **SNAPSHOTs are for development**: Deployed on every push to trunk

## Git Workflow

```
feature/my-change ──PR──▶ develop ──tag v0.1.20──▶ [CI Release]
                              │
                              └── CI bumps to 0.1.21-SNAPSHOT
```

### Rules
1. All development happens on `develop` (trunk)
2. Feature branches → PR → merge to `develop`
3. Releases are triggered by **annotated tags** on `develop`
4. No `release/` branches, no `main`/`master` divergence
5. After release, CI automatically bumps to next `-SNAPSHOT`

## Release Triggers

| Trigger | Action | Tier |
|---------|--------|------|
| `git tag v0.1.20 && git push --tags` | Auto-release | GitHub Packages |
| `workflow_dispatch` + `publish-central: false` | Manual release | GitHub Packages |
| `workflow_dispatch` + `publish-central: true` | Manual release | GitHub Packages + Central |

## Procedure

### Quick Release (GitHub Packages only)

```bash
# 1. Ensure develop is green
# 2. Tag and push
git checkout develop
git pull
git tag -a v0.1.20 -m "Release 0.1.20"
git push origin v0.1.20
# Done. CI handles the rest.
```

### Full Release (GitHub Packages + Maven Central)

1. Go to **Actions → Release → Run workflow**
2. Enter version: `0.1.20`
3. Set `publish-central`: `true`
4. Click **Run workflow**
5. CI will:
   - Create tag `v0.1.20`
   - Build + sign + deploy to GitHub Packages
   - Build + sign + publish to Maven Central Portal
   - Bump to `0.1.21-SNAPSHOT`
   - Push bump to `develop`

### What CI Does (automated)

```
┌─────────────────────────────────────────────────────────┐
│ 1. Checkout develop (or tag)                            │
│ 2. Set version: 0.1.20-SNAPSHOT → 0.1.20              │
│ 3. mvn clean deploy -P release -DskipTests             │
│    ├── Enforcer: requireReleaseVersion ✅              │
│    ├── maven-source-plugin: attach sources ✅          │
│    ├── maven-javadoc-plugin: attach javadoc ✅         │
│    ├── sign-maven-plugin: GPG sign (ed25519) ✅        │
│    ├── cyclonedx-maven-plugin: SBOM ✅                 │
│    └── maven-deploy-plugin: → GitHub Packages ✅       │
│ 4. (If Central) central-publishing:publish → Central  │
│ 5. Bump: 0.1.20 → 0.1.21-SNAPSHOT                     │
│ 6. git commit + push to develop                        │
│ 7. Validate: artifact resolvable from GitHub Packages  │
└─────────────────────────────────────────────────────────┘
```

## Prerequisites

### CI Secrets

| Secret | Purpose | Scope |
|--------|---------|-------|
| `SIGN_KEY` | GPG private key (armored) | Org |
| `SIGN_KEY_PASS` | GPG passphrase | Org |
| `GITHUBTOKEN` | PAT with `packages:write` + `contents:write` | Org |
| `CENTRAL_PORTAL_USERNAME` | Central Portal token ID | Org |
| `CENTRAL_PORTAL_TOKEN` | Central Portal API token | Org |

### GPG Key
- Algorithm: **ed25519** (or RSA 4096)
- Must be pushed to a keyserver (for Central Portal verification)
- Fingerprint must be registered on [Central Portal](https://central.sonatype.com) (Tier 2 only)

### POM Requirements
- `distributionManagement` → GitHub Packages (default)
- `release` profile: enforcer + sources + javadoc + GPG + SBOM (NO central-publishing)
- `mavencentral` profile: central-publishing-maven-plugin (for Tier 2)
- Version format: `MAJOR.MINOR.PATCH-SNAPSHOT`

## Versioning

- Follow [Semantic Versioning](https://semver.org/): `MAJOR.MINOR.PATCH`
- `MAJOR`: Breaking API changes
- `MINOR`: New features, backward compatible
- `PATCH`: Bug fixes, backward compatible
- SNAPSHOT: `X.Y.Z-SNAPSHOT` (deployed on every push to trunk)
- Release: `X.Y.Z` (deployed on tag)

## Troubleshooting

| Symptom | Cause | Fix |
|---------|-------|-----|
| `requireReleaseVersion` failure | Version still has `-SNAPSHOT` | CI sets version before build; check `versions:set` step |
| GitHub Packages 401 | Token expired or missing `packages:write` | Regenerate PAT |
| Central Portal rejection | GPG fingerprint not registered | Register on central.sonatype.com |
| Central Portal: "duplicate version" | Version already published | Bump version (Central doesn't allow overwrites) |
| Validation job fails | Artifact not yet visible (CDN cache) | Wait 30s and re-run validation |

## Adapting to Other Repositories

To adopt this standard in another repo:

1. **Copy** `.github/workflows/release.yml` from this repo
2. **Adjust** in the workflow:
   - `runs-on` labels (your self-hosted runners)
   - Group ID / Artifact ID in the validation step
   - GitHub Packages URL (uses `${github.account}` from POM)
3. **Ensure** your POM has:
   - `distributionManagement` → GitHub Packages
   - `release` profile (enforcer + sources + javadoc + GPG + SBOM)
   - `mavencentral` profile (central-publishing, optional)
4. **Set** org secrets: `SIGN_KEY`, `SIGN_KEY_PASS`, `GITHUBTOKEN`
5. **Tag** your first release: `git tag -a v1.0.0 -m "Release 1.0.0" && git push --tags`

That's it. No `maven-release-plugin` configuration, no `scm` tag fiddling, no manual commands.

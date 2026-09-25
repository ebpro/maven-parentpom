# Maven Parent POM

Production-ready parent POM for Java + Maven + Docker CI/CD. Provides opinionated defaults for build, quality, security, packaging, and release.

## Stack

| Component | Version |
|-----------|---------|
| Java | 25 (Temurin) |
| Maven | 3.9.11+ |
| Build toolchain | Enforced via `maven-enforcer-plugin` |

## Features

- **BOM & dependency management** — Curated versions for common libraries (Spring, JUnit 5, Mockito, Testcontainers, Jackson, Logback, etc.)
- **Quality gates** — JaCoCo coverage, SonarQube integration, Spotless formatting, API compatibility (RevAPI)
- **Security** — OWASP Dependency Check, CycloneDX SBOM, GitHub CodeQL, Dependency Review
- **Packaging modes** — Standard JAR, shaded JAR, JPMS jlink runtime, GraalVM native image
- **Release** — GPG signing (ed25519), Central Portal publishing, GitHub Packages
- **CI/CD** — GitHub Actions (shared workflows), self-hosted runner compatible
- **Testing** — JUnit 5, Testcontainers, Maven Invoker IT (canary)

## Application Image Contract

For application (non-library) modules, set the `app.image` property to select the packaging mode:

| `app.image` | Profile | Output | Docker target |
|-------------|---------|--------|---------------|
| `libs` | `libs` | Thin JAR + `target/libs/` (runtime deps) | `finalLibs` — `java -cp app.jar:libs/* ${app.main.class}` |
| `jlink` | `jlink` | Custom JPMS runtime via jlink | `finalJlink` — `./myapp` launcher |
| `native` | `native` | Single native executable (GraalVM) | `finalNative` — `./myapp` binary |
| *(empty)* | — | Standard JAR (library) | — |

### Required properties for apps

```xml
<properties>
    <app.image>libs</app.image>              <!-- libs | jlink | native -->
    <app.main.class>com.example.MyApp</app.main.class>  <!-- fully qualified -->
    <!-- optional: <app.module.name>com.example.myapp</app.module.name> -->
</properties>
```

### Notes

- `shadedjar` is **not** part of `app.image` — activate explicitly with `-Pshadedjar` for fat-jar mode
- For **static** native binaries (alpine/musl), override in your module:
  ```xml
  <buildArgs combine.children="append">
      <arg>--static</arg>
  </buildArgs>
  ```
- The `jlink` profile uses `jigsaw-maven-plugin` 1.1.3. Note: `mainClass`, `multiRelease`, `jlinkOptions`, and `ignoreMissingDeps` are currently no-ops (awaiting upstream support). Only `launcher` and `module` are functional.

## Profiles

| Profile | Activation | Purpose |
|---------|-----------|---------|
| `libs` | `app.image=libs` | Copy runtime deps to `target/libs/` |
| `jlink` | `app.image=jlink` | Build JPMS jlink runtime |
| `native` | `app.image=native` | Build GraalVM native image |
| `shadedjar` | Manual (`-Pshadedjar`) | Fat JAR via maven-shade-plugin |
| `gpgsigning` | Manual | GPG signing for release |
| `mavencentral` | Manual | Central Portal deployment config |
| `javadoc` | Manual | Javadoc generation |
| `jacoco` | Automatic (file-activated) | Code coverage |
| `sonar` | Manual | SonarQube analysis |
| `release` | Manual | Release preparation |
| `format` | Manual | Spotless formatting |
| `api-compat` | Manual | RevAPI binary compatibility check |
| `it` | Automatic (file-activated on `src/it`) | Maven Invoker integration tests |

## CI/CD

- **Build & test**: Shared workflow (`gh-actions-shared-java`) on push/PR to `develop`
- **Security**: CodeQL, Dependency Review, SBOM generation, OWASP canary scan
- **Release**: On `v*` tag → GPG sign → Central Portal + GitHub Packages
- **Runners**: Self-hosted (`self-hosted`, `linux`, `ebpro-org`, `x64`)

## Version Bumps

Dependency and plugin versions are managed in `<properties>` and `<pluginManagement>`. Use:

```bash
mvn versions:display-dependency-updates -DrulesFile=https://bruno.univ-tln.fr/rules.xml
mvn versions:display-plugin-updates -DrulesFile=https://bruno.univ-tln.fr/rules.xml
```

## Links

- Website: [https://ebpro.github.io/maven-parentpom/](https://ebpro.github.io/maven-parentpom/)
- Archetypes: [ebpro/maven-archetypes](https://github.com/ebpro/maven-archetypes)
- CI runners: [ebpro/quarkus-ci-runner](https://github.com/ebpro/quarkus-ci-runner)
- Shared workflows: [ebpro/gh-actions-shared-java](https://github.com/ebpro/gh-actions-shared-java)

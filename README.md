# Maven Parent POM

[![CI](https://github.com/ebpro/maven-parentpom/actions/workflows/ci-java.yml/badge.svg)](https://github.com/ebpro/maven-parentpom/actions/workflows/ci-java.yml)
[![Security](https://github.com/ebpro/maven-parentpom/actions/workflows/security.yml/badge.svg)](https://github.com/ebpro/maven-parentpom/actions/workflows/security.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Java](https://img.shields.io/badge/Java-25-red.svg)](https://adoptium.net/)
[![Maven](https://img.shields.io/badge/Maven-3.9.11+-blue.svg)](https://maven.apache.org/)

Production-ready parent POM for Java 25 + Maven 3.9+ + Docker CI/CD. Provides opinionated, SOTA-2026 defaults for build, quality, security, packaging, and release. Inherit it to get a fully wired Java project in 10 lines of XML.

---

## Quick Start

### Create a new project from an archetype

```bash
# Simple standalone project
mvn archetype:generate \
  -DarchetypeGroupId=fr.ebruno.maven.archetypes \
  -DarchetypeArtifactId=maven-archetype-simple \
  -DgroupId=com.example \
  -DartifactId=my-app \
  -Dversion=1.0.0-SNAPSHOT

# Project inheriting this parent POM
mvn archetype:generate \
  -DarchetypeGroupId=fr.ebruno.maven.archetypes \
  -DarchetypeArtifactId=maven-archetype-withparent \
  -DgroupId=com.example \
  -DartifactId=my-app \
  -Dversion=1.0.0-SNAPSHOT
```

### Or inherit directly

```xml
<project>
    <modelVersion>4.0.0</modelVersion>

    <parent>
        <groupId>fr.ebruno.maven.poms</groupId>
        <artifactId>maven-parentpom</artifactId>
        <version>0.1.20</version>
    </parent>

    <groupId>com.example</groupId>
    <artifactId>my-app</artifactId>
    <version>1.0.0-SNAPSHOT</version>
    <packaging>jar</packaging>

    <properties>
        <github.account>your-org</github.account>
        <!-- For applications: -->
        <app.image>libs</app.image>
        <app.main.class>com.example.MyApp</app.main.class>
    </properties>

    <dependencies>
        <!-- Versions are managed — just declare groupId:artifactId -->
        <dependency>
            <groupId>com.fasterxml.jackson.core</groupId>
            <artifactId>jackson-databind</artifactId>
        </dependency>
        <dependency>
            <groupId>org.junit.jupiter</groupId>
            <artifactId>junit-jupiter</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>
</project>
```

That's it. You get: enforced Java/Maven versions, dependency convergence, JaCoCo coverage, SonarQube, Spotless formatting, GPG signing, SBOM, OWASP scanning, and release tooling — all pre-configured.

---

## Managed Dependencies

All versions are managed in `<dependencyManagement>`. Declare dependencies in your child **without** `<version>`.

### Testing

| Library | Version | Artifacts |
|---------|---------|-----------|
| JUnit | 6.1.3 | `junit-bom` (import), `junit-jupiter`, `junit-platform-*` |
| AssertJ | 3.27.7 | `assertj-core` |
| Mockito | 5.24.0 | `mockito-core`, `mockito-junit-jupiter` |
| Hamcrest | 3.0 | `hamcrest`, `hamcrest-library` |
| JSONassert | 1.5.3 | `jsonassert` |
| Awaitility | 4.3.0 | `awaitility` |
| REST Assured | 6.0.1 | `rest-assured` |
| Testcontainers | 2.0.5 | `testcontainers-bom` (import), `junit-jupiter`, `postgresql` (1.21.4) |
| Arquillian | 1.10.2.Final | `arquillian-bom` (import), `arquillian-weld-embedded` (4.0.0.Final) |
| Arquillian Cube | 2.0.0.Final | `arquillian-cube-bom` (import) |

### Persistence / JPA

| Library | Version | Artifacts |
|---------|---------|-----------|
| Jakarta Persistence | 3.2.0 | `jakarta.persistence-api` |
| EclipseLink | 5.0.2 | `eclipselink` |
| Hibernate ORM | 7.4.10.Final | `hibernate-platform` (import), `hibernate-c3p0` |
| C3P0 | 0.14.2 | `c3p0` |

### Databases / JDBC

| Library | Version | Artifacts |
|---------|---------|-----------|
| H2 | 2.5.250 | `h2` |
| PostgreSQL | 42.7.13 | `postgresql` |
| MySQL Connector/J | 26.7.0 | `mysql-connector-j` |

### JSON / XML

| Library | Version | Artifacts |
|---------|---------|-----------|
| Jackson | 2.22.3 | `jackson-bom` (import), `jackson-jakarta-rs-json-provider` |
| JAXB | 4.0.5 / 4.0.9 | `jakarta.xml.bind-api`, `jaxb-impl` |

### REST / Web

| Library | Version | Artifacts |
|---------|---------|-----------|
| JAX-RS | 4.0.0 | `jakarta.ws.rs-api` |
| Jersey | 4.0.2 | `jersey-bom` (import), `jersey-client` |
| Tyrus (WebSocket) | 2.2.2 | `tyrus-server`, `tyrus-container-grizzly-server`, `tyrus-standalone-client` |
| JWT (jjwt) | 0.13.0 | `jjwt-api`, `jjwt-impl`, `jjwt-jackson` |

### Jakarta EE / JEE

| Library | Version | Artifacts |
|---------|---------|-----------|
| Jakarta EE API | 11.0.0 | `jakarta.jakartaee-api`, `jakarta.jakartaee-web-api` (provided) |
| EL | 4.0.2 | `jakarta.el` |
| Bean Validation | 3.0.0 | `hibernate-validator` (9.1.4.Final) |
| PrimeFaces | 16.0.0 | `primefaces` (jakarta classifier), `all-themes` (1.1.0) |
| Payara | 6.2023.11 | (Arquillian managed) |

### Logging

| Library | Version | Artifacts |
|---------|---------|-----------|
| SLF4J | 2.0.20 | `slf4j-bom` (import) |
| Logback | 1.6.4 | `logback-classic` |

### Utilities

| Library | Version | Artifacts |
|---------|---------|-----------|
| Lombok | 1.18.48 | `lombok` (provided) |
| Eclipse Collections | 13.0.0 | `eclipse-collections` |
| Throwing-Function | 1.6.1 | `throwing-function` |

---

## Application Image Contract

For **application** (non-library) modules, the `app.image` property selects the packaging mode. Setting it **automatically activates** the corresponding profile via Maven property activation.

| `app.image` | Profile | Build Output | Docker Target | Run Command |
|-------------|---------|-------------|---------------|-------------|
| `libs` | `libs` | Thin JAR + `target/libs/*.jar` | `finalLibs` | `java -cp app.jar:libs/* ${app.main.class}` |
| `jlink` | `jlink` | Custom JPMS runtime (`target/jlink/`) | `finalJlink` | `./jlink/bin/myapp` |
| `native` | `native` | Single native executable | `finalNative` | `./native-image/myapp` |
| *(empty)* | — | Standard JAR (library) | — | — |

### Required properties

```xml
<properties>
    <app.image>libs</app.image>                    <!-- libs | jlink | native -->
    <app.main.class>com.example.MyApp</app.main.class>  <!-- fully qualified main class -->
</properties>
```

### Optional

```xml
<properties>
    <!-- JPMS module name (defaults to ${project.groupId}.${project.artifactId}) -->
    <app.module.name>com.example.myapp</app.module.name>
</properties>
```

### Notes

- **`shadedjar`** is NOT part of `app.image`. Activate explicitly: `mvn package -Pshadedjar`
- **Static native binaries** (alpine/musl): override in your module's POM:
  ```xml
  <build>
      <plugins>
          <plugin>
              <groupId>org.graalvm.buildtools</groupId>
              <artifactId>native-maven-plugin</artifactId>
              <configuration>
                  <buildArgs combine.children="append">
                      <arg>--static</arg>
                  </buildArgs>
              </configuration>
          </plugin>
      </plugins>
  </build>
  ```
- **jlink limitation**: `jigsaw-maven-plugin` 1.1.3 `link` goal only supports `launcher`, `module`, `output`, `modulePath`, `ignoreSigningInformation`. The `mainClass`, `multiRelease`, `jlinkOptions`, `ignoreMissingDeps` elements are present for forward compatibility but currently no-ops.

---

## Profiles

| Profile | Activation | Purpose |
|---------|-----------|---------|
| `libs` | `app.image=libs` | Copy runtime deps → `target/libs/` |
| `jlink` | `app.image=jlink` | Build JPMS jlink custom runtime |
| `native` | `app.image=native` | GraalVM native image compilation |
| `shadedjar` | Manual: `-Pshadedjar` | Fat JAR (maven-shade-plugin) |
| `gpgsigning` | Manual: `-Pgpgsigning` | GPG signing (ed25519) |
| `mavencentral` | Manual: `-Pmavencentral` | Central Portal deployment config |
| `javadoc` | Manual: `-Pjavadoc` | Javadoc jar generation |
| `jacoco` | Automatic (file-activated) | Code coverage (JaCoCo) |
| `sonar` | Manual: `-Psonar` | SonarQube analysis |
| `arq-payara-micro` | Manual | Arquillian + Payara Micro embedded |
| `arq-payara-managed` | Manual | Arquillian + Payara managed |
| `release` | Manual: `-Prelease` | Release preparation (flatten, gpg, central) |
| `format` | Manual: `-Pformat` | Spotless format/apply |
| `api-compat` | Manual: `-Papi-compat` | RevAPI binary compatibility check |
| `it` | Automatic (file-activated on `src/it`) | Maven Invoker integration tests |

---

## Quality Gates

### Enforcer Rules (always active)

| Rule | Purpose |
|------|---------|
| `requireMavenVersion` | Maven ≥ 3.9.11 |
| `requireJavaVersion` | Java ≥ 25 |
| `dependencyConvergence` | All transitive deps resolve to same version |
| `banDuplicatePomDependencyVersions` | No duplicate declarations |
| `requireUpperBoundDeps` | No version conflicts in dependency tree |
| `banDynamicVersions` | No `LATEST`/`RELEASE`/ranges |

### JaCoCo (code coverage)

- Reports: HTML + XML (for SonarQube)
- Check: enforced minimum coverage (configurable per project)
- Excludes: test classes, generated code

### SonarQube

- Plugin: `sonar-maven-plugin` 5.5.0.6356
- Quality gate: `sonar-quality-gate-maven-plugin` 1.3.0
- Connect via: `-Dsonar.host.url=... -Dsonar.token=...`

### Spotless (formatting)

- Formatter: **Palantir Java Format** 2.50.0
- Goals: `spotless:check` (CI) / `spotless:apply` (dev)
- Activate: `-Pformat`

### API Compatibility (RevAPI)

- Plugin: `revapi-maven-plugin` 0.28.1
- Detects binary incompatibilities between releases
- Activate: `-Papi-compat`

---

## Security

| Tool | What it does | When |
|------|-------------|------|
| **OWASP Dependency Check** 13.0.0 | Scans dependencies against NVD (CVSS ≥ 9 fails) | CI: canary project |
| **CycloneDX SBOM** 2.9.3 | Generates `bom.json` + `bom.xml` | CI: every build |
| **GitHub CodeQL** | SAST (static analysis) | CI: every push/PR |
| **GitHub Dependency Review** | Flags vulnerable deps in PRs | CI: every PR |

### OWASP Configuration

```xml
<dependency-check.version>13.0.0</dependency-check.version>
<!-- failBuildOnCVSS=9: only critical vulns fail the build -->
```

The parent POM itself has `packaging: pom` (no direct dependencies), so OWASP runs against the **canary** integration test project (`src/it/canary/`) which has real dependencies (Jackson, JUnit).

### SBOM

CycloneDX generates both JSON and XML SBOMs on every build:
```
target/bom.json
target/bom.xml
```

---

## Release Process

### Prerequisites

1. **GPG key** (ed25519) — registered on Central Portal
   - `SIGN_KEY` org secret: armored private key
   - `SIGN_KEY_PASS` org secret: passphrase
2. **Central Portal** credentials
   - `CENTRAL_PORTAL_USERNAME` org secret
   - `CENTRAL_PORTAL_TOKEN` org secret
3. **Maven Central account** — key fingerprint registered at https://central.sonatype.com

### Release workflow

```
git tag v0.1.20
  → GitHub Actions: release.yml
    → mvn clean verify -Prelease -Pgpgsigning -Pmavencentral
    → Sign JAR + POM + sources + javadoc
    → Deploy to Central Portal (staged → closed → released)
    → Deploy to GitHub Packages
```

### Tag format

`v{major}.{minor}.{patch}` — e.g., `v0.1.20`

### Manual release (local)

```bash
# Prepare
mvn clean verify -Prelease -Pgpgsigning -Pmavencentral

# Or use maven-release-plugin
mvn release:prepare release:perform
```

---

## CI/CD

### Workflows

| Workflow | Trigger | Purpose |
|----------|---------|---------|
| `ci-java.yml` | Push/PR to `develop` | Build, test, SonarQube |
| `security.yml` | Push/PR to `develop` | CodeQL, SBOM, OWASP canary, Dep Review |
| `release.yml` | Tag `v*` | Sign + publish to Central Portal |

### Runners

Self-hosted: `self-hosted`, `linux`, `ebpro-org`, `x64`
- Image: `sha-2d55143`
- Pre-installed: Java 25 (Temurin), Maven 3.9.11, GPG, Docker
- Cached: `~/.m2/repository` at `/opt/cache/m2/repository`

### Shared workflows

- Build: [`ebpro/gh-actions-shared-java`](https://github.com/ebpro/gh-actions-shared-java)
- Runner: [`ebpro/quarkus-ci-runner`](https://github.com/ebpro/quarkus-ci-runner)

---

## Testing

### Unit tests

- **JUnit 6** (Jupiter) — `junit-jupiter` on classpath
- **Surefire** 3.6.0 — runs `*Test.java`
- **Failsafe** 3.6.0 — runs `*IT.java` (integration)

### Integration tests

- **Testcontainers** 2.0.5 — PostgreSQL, etc.
- **Arquillian** — Payara Micro (embedded) or Payara Managed
- **REST Assured** 6.0.1 — HTTP API testing

### Canary (parent POM self-test)

The parent POM includes an invoker-based integration test (`src/it/canary/`) that:
1. Creates a minimal child project inheriting this parent
2. Compiles and runs it in an isolated Maven environment
3. Verifies the parent POM works end-to-end

Activated automatically when `src/it/` exists. Runs `clean verify` on the canary.

---

## Version Management

### Check for updates

```bash
# Dependencies
mvn versions:display-dependency-updates \
  -DrulesFile=https://bruno.univ-tln.fr/rules.xml

# Plugins
mvn versions:display-plugin-updates \
  -DrulesFile=https://bruno.univ-tln.fr/rules.xml

# BOM
mvn versions:display-property-updates
```

### Bump a version

```bash
# Single property
mvn versions:set-property -Dproperty=jackson.version -DnewVersion=2.23.0

# All at once (careful!)
mvn versions:update-properties
```

### Release a new parent version

```bash
mvn release:prepare -DreleaseVersion=0.1.20 -DdevelopmentVersion=0.1.21-SNAPSHOT
mvn release:perform
git tag v0.1.20
git push && git push --tags
```

---

## Design Decisions

| Decision | Rationale |
|----------|-----------|
| `packaging: pom` | This is a parent, not a library. No code to compile. |
| Property-based profile activation (`app.image`) | Declarative: set a property, get the behavior. No `-P` flags needed in Dockerfiles. |
| `jlink` + `native` as opt-in profiles | Not every module is an app. Libraries stay lean. |
| `shadedjar` separate from `app.image` | Fat JAR is a deployment choice, not an identity choice. |
| OWASP on canary, not parent | Parent has zero dependencies (POM packaging). Canary has real deps. |
| Enforcer `dependencyConvergence` | Catches version conflicts early, before they cause runtime issues. |
| Reproducible builds (`outputTimestamp`) | Same inputs → same JAR bytes. Critical for supply chain security. |
| GPG ed25519 | Modern, fast, 256-bit security. Supersedes RSA-4096. |
| Central Portal (not OSSRH) | OSSRH is retired. Central Portal is the current publishing mechanism. |

---

## Project Structure

```
maven-parentpom/
├── pom.xml                    # The parent POM (2300+ lines)
├── README.md                  # This file
├── .github/
│   └── workflows/
│       ├── ci-java.yml        # Build + test + SonarQube
│       ├── security.yml       # CodeQL + SBOM + OWASP + Dep Review
│       └── release.yml        # GPG sign + Central Portal publish
├── src/
│   └── it/
│       ├── canary/            # Invoker IT: minimal child project
│       │   ├── pom.xml
│       │   ├── invoker.properties
│       │   └── src/main/java/...
│       └── settings.xml       # Isolated Maven settings for invoker
└── .mvn/
    └── wrapper/               # Maven Wrapper
```

---

## Links

| Resource | URL |
|----------|-----|
| Website | https://ebpro.github.io/maven-parentpom/ |
| Archetypes | https://github.com/ebpro/maven-archetypes |
| CI Runner | https://github.com/ebpro/quarkus-ci-runner |
| Shared Workflows | https://github.com/ebpro/gh-actions-shared-java |
| Versions Rules | https://bruno.univ-tln.fr/rules.xml |
| Central Portal | https://central.sonatype.com/ |
| NVD API | https://nvd.nist.gov/ |
| SonarQube | (org-internal) |

---

## License

[MIT](https://opensource.org/licenses/MIT) © Emmanuel Bruno, Université de Toulon

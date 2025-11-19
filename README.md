<p align="center"><a href="https://bearsampp.com/contribute" target="_blank"><img width="250" src="img/Bearsampp-logo.svg"></a></p>

[![GitHub release](https://img.shields.io/github/release/bearsampp/module-postgresql.svg?style=flat-square)](https://github.com/bearsampp/module-postgresql/releases/latest)
![Total downloads](https://img.shields.io/github/downloads/bearsampp/module-postgresql/total.svg?style=flat-square)

This is a module of [Bearsampp project](https://github.com/bearsampp/bearsampp) involving PostgreSQL.

## Build System

This project uses **Gradle** as its build system. The build has been implemented with a modern, pure Gradle implementation.

### Quick Start

```bash
# Display build information
gradle info

# List all available tasks
gradle tasks

# Verify build environment
gradle verify

# Build a release for specific version
gradle release -PbundleVersion=17.5

# Build all versions
gradle releaseAll

# Clean build artifacts
gradle clean
```

### Prerequisites

| Requirement       | Version       | Purpose                                  |
|-------------------|---------------|------------------------------------------|
| **Java**          | 8+            | Required for Gradle execution            |
| **Gradle**        | 8.0+          | Build automation tool                    |
| **7-Zip**         | Latest        | Archive extraction (optional)            |

### Available Tasks

| Task                  | Description                                      |
|-----------------------|--------------------------------------------------|
| `release`             | Build release package for specific version       |
| `releaseAll`          | Build all available versions                     |
| `clean`               | Clean build artifacts and temporary files        |
| `verify`              | Verify build environment and dependencies        |
| `info`                | Display build configuration information          |
| `listVersions`        | List available bundle versions in bin/           |
| `listReleases`        | List available releases from modules-untouched   |
| `validateProperties`  | Validate gradle.properties configuration         |
| `checkModulesUntouched` | Check modules-untouched integration            |

For complete documentation, see [.gradle-docs/README.md](.gradle-docs/README.md)

## Documentation

- **Build Documentation**: [.gradle-docs/README.md](.gradle-docs/README.md)
- **Task Reference**: [.gradle-docs/TASKS.md](.gradle-docs/TASKS.md)
- **Configuration Guide**: [.gradle-docs/CONFIGURATION.md](.gradle-docs/CONFIGURATION.md)
- **API Reference**: [.gradle-docs/API.md](.gradle-docs/API.md)
- **Module Downloads**: https://bearsampp.com/module/postgresql

## Issues

Issues must be reported on [Bearsampp repository](https://github.com/bearsampp/bearsampp/issues).

## Statistics

![Alt](https://repobeats.axiom.co/api/embed/2b56dc0b1aac6a6280b8051a41421d4fbb89ef49.svg "Repobeats analytics image")

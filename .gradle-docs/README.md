# Bearsampp Module PostgreSQL - Gradle Build Documentation

## Table of Contents

- [Overview](#overview)
- [Quick Start](#quick-start)
- [Installation](#installation)
- [Build Tasks](#build-tasks)
- [Configuration](#configuration)
- [Architecture](#architecture)
- [Troubleshooting](#troubleshooting)

---

## Overview

The Bearsampp Module PostgreSQL project uses a **pure Gradle build system**. This provides:

- **Modern Build System**     - Native Gradle tasks and conventions
- **Better Performance**       - Incremental builds and caching
- **Simplified Maintenance**   - Pure Groovy/Gradle DSL
- **Enhanced Tooling**         - IDE integration and dependency management
- **Cross-Platform Support**   - Works on Windows, Linux, and macOS

### Project Information

| Property          | Value                                    |
|-------------------|------------------------------------------|
| **Project Name**  | module-postgresql                        |
| **Group**         | com.bearsampp.modules                    |
| **Type**          | PostgreSQL Module Builder                |
| **Build Tool**    | Gradle 8.x+                              |
| **Language**      | Groovy (Gradle DSL)                      |

---

## Quick Start

### Prerequisites

| Requirement       | Version       | Purpose                                  |
|-------------------|---------------|------------------------------------------|
| **Java**          | 8+            | Required for Gradle execution            |
| **Gradle**        | 8.0+          | Build automation tool                    |
| **7-Zip**         | Latest        | Archive extraction (optional)            |

**Note:** This project uses **pure Gradle** without a wrapper. Install Gradle 8+ locally and run with `gradle ...`.

### Basic Commands

```bash
# Display build information
gradle info

# List all available tasks
gradle tasks

# Verify build environment
gradle verify

# Build a release (specify version)
gradle release -PbundleVersion=17.5

# Build all versions
gradle releaseAll

# Clean build artifacts
gradle clean
```

---

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/bearsampp/module-postgresql.git
cd module-postgresql
```

### 2. Verify Environment

```bash
gradle verify
```

This will check:
- Java version (8+)
- Required files (gradle.properties)
- Directory structure (bin/)
- Build dependencies

### 3. List Available Versions

```bash
gradle listVersions
```

### 4. Build Your First Release

```bash
# Specify version directly
gradle release -PbundleVersion=17.5
```

---

## Build Tasks

### Core Build Tasks

| Task                  | Description                                      | Example                                  |
|-----------------------|--------------------------------------------------|------------------------------------------|
| `release`             | Build and package release for specific version   | `gradle release -PbundleVersion=17.5`    |
| `releaseAll`          | Build all available versions                     | `gradle releaseAll`                      |
| `clean`               | Clean build artifacts and temporary files        | `gradle clean`                           |

### Verification Tasks

| Task                      | Description                                  | Example                                      |
|---------------------------|----------------------------------------------|----------------------------------------------|
| `verify`                  | Verify build environment and dependencies    | `gradle verify`                              |
| `validateProperties`      | Validate gradle.properties configuration     | `gradle validateProperties`                  |

### Information Tasks

| Task                | Description                                      | Example                    |
|---------------------|--------------------------------------------------|----------------------------|
| `info`              | Display build configuration information          | `gradle info`              |
| `listVersions`      | List available bundle versions in bin/           | `gradle listVersions`      |
| `listReleases`      | List all available releases from modules-untouched | `gradle listReleases`    |
| `checkModulesUntouched` | Check modules-untouched integration          | `gradle checkModulesUntouched` |

### Task Groups

| Group            | Purpose                                          |
|------------------|--------------------------------------------------|
| **build**        | Build and package tasks                          |
| **verification** | Verification and validation tasks                |
| **help**         | Help and information tasks                       |

---

## Configuration

### gradle.properties

The main configuration file for the build:

```properties
bundle.name     = postgresql
bundle.release  = 2025.7.2
bundle.type     = bins
bundle.format   = 7z
```

| Property          | Description                          | Example Value  |
|-------------------|--------------------------------------|----------------|
| `bundle.name`     | Name of the bundle                   | `postgresql`   |
| `bundle.release`  | Release version                      | `2025.7.2`     |
| `bundle.type`     | Type of bundle                       | `bins`         |
| `bundle.format`   | Archive format                       | `7z`           |

### Directory Structure

```
module-postgresql/
├── .gradle-docs/          # Gradle documentation
│   ├── README.md          # Main documentation
│   ├── TASKS.md           # Task reference
│   ├── CONFIGURATION.md   # Configuration guide
│   └── API.md             # API reference
├── bin/                   # PostgreSQL version configurations
│   ├── postgresql17.5/    # Configuration files for version 17.5
│   │   ├── bearsampp.conf
│   │   ├── init.bat
│   │   ├── pg_hba.conf.ber
│   │   └── postgresql.conf.ber
│   └── archived/          # Archived versions
│       └── postgresql*/
├── build.gradle           # Pure Gradle build script
├── settings.gradle        # Gradle settings
├── gradle.properties      # Build configuration
└── releases.properties    # Available PostgreSQL releases
```

### Build Output Structure

```
bearsampp-build/                    # External build directory (outside repo)
├── tmp/                            # Temporary build files
│   ├── bundles_prep/bins/postgresql/      # Prepared bundles
│   ├── bundles_build/bins/postgresql/     # Build staging
│   ├── downloads/postgresql/              # Downloaded dependencies
│   └── extract/postgresql/                # Extracted archives
└── bins/postgresql/                       # Final packaged archives
    └── 2025.7.2/                          # Release version
        ├── bearsampp-postgresql-17.5-2025.7.2.7z
        ├── bearsampp-postgresql-17.5-2025.7.2.7z.md5
        └── ...
```

---

## Architecture

### Build Process Flow

```
1. User runs: gradle release -PbundleVersion=17.5
                    ↓
2. Validate environment and version
                    ↓
3. Fetch download URL from modules-untouched
                    ↓
4. Download PostgreSQL binaries (with caching)
                    ↓
5. Extract binaries (with caching)
                    ↓
6. Create preparation directory (tmp/prep/)
                    ↓
7. Copy PostgreSQL files (excluding unnecessary files)
   - Excludes: pgAdmin, doc, include, StackBuilder, symbols, *.lib, *.pdb
                    ↓
8. Copy configuration files from bin/postgresql{version}/
                    ↓
9. Output prepared bundle to tmp/prep/
                    ↓
10. Package prepared folder into archive in bearsampp-build/bins/postgresql/{bundle.release}/
    - The archive includes the top-level folder: postgresql{version}/
```

### Packaging Details

- **Archive name format**: `bearsampp-postgresql-{version}-{bundle.release}.{7z|zip}`
- **Location**: `bearsampp-build/bins/postgresql/{bundle.release}/`
  - Example: `bearsampp-build/bins/postgresql/2025.7.2/bearsampp-postgresql-17.5-2025.7.2.7z`
- **Content root**: The top-level folder inside the archive is `postgresql{version}/` (e.g., `postgresql17.5/`)
- **Structure**: The archive contains the PostgreSQL version folder at the root with all PostgreSQL files inside

**Archive Structure Example**:
```
bearsampp-postgresql-17.5-2025.7.2.7z
└── postgresql17.5/         ← Version folder at root
    ├── bin/
    │   ├── pg_ctl.exe
    │   ├── postgres.exe
    │   └── ...
    ├── lib/
    ├── share/
    ├── bearsampp.conf
    ├── init.bat
    ├── pg_hba.conf.ber
    └── postgresql.conf.ber
```

**Verification Commands**:

```bash
# List archive contents with 7z
7z l bearsampp-build/bins/postgresql/2025.7.2/bearsampp-postgresql-17.5-2025.7.2.7z | more

# You should see entries beginning with:
#   postgresql17.5/bin/pg_ctl.exe
#   postgresql17.5/bin/postgres.exe
#   postgresql17.5/lib/
#   postgresql17.5/...

# Extract and inspect with PowerShell (zip example)
Expand-Archive -Path bearsampp-build/bins/postgresql/2025.7.2/bearsampp-postgresql-17.5-2025.7.2.zip -DestinationPath .\_inspect
Get-ChildItem .\_inspect\postgresql17.5 | Select-Object Name

# Expected output:
#   bin/
#   lib/
#   share/
#   bearsampp.conf
#   init.bat
#   ...
```

**Hash Files**: Each archive is accompanied by hash sidecar files:
- `.md5` - MD5 checksum
- `.sha1` - SHA-1 checksum
- `.sha256` - SHA-256 checksum
- `.sha512` - SHA-512 checksum

Example:
```
bearsampp-build/bins/postgresql/2025.7.2/
├── bearsampp-postgresql-17.5-2025.7.2.7z
├── bearsampp-postgresql-17.5-2025.7.2.7z.md5
├── bearsampp-postgresql-17.5-2025.7.2.7z.sha1
├── bearsampp-postgresql-17.5-2025.7.2.7z.sha256
└── bearsampp-postgresql-17.5-2025.7.2.7z.sha512
```

### Source Resolution

The build system resolves PostgreSQL binaries using this strategy:

1. **modules-untouched repository** (primary)
   - Fetches `postgresql.properties` from: https://github.com/Bearsampp/modules-untouched
   - Uses the URL specified for the requested version

2. **Standard URL format** (fallback)
   - If version not found in properties file
   - Constructs URL: `https://github.com/Bearsampp/modules-untouched/releases/download/postgresql-{version}/postgresql-{version}-windows-x64-binaries.zip`

### File Filtering

When copying PostgreSQL files, the following are excluded:
- `bin/pgAdmin*` - pgAdmin executables
- `doc/**` - Documentation files
- `include/**` - Header files
- `pgAdmin*/**` - pgAdmin directories
- `StackBuilder/**` - StackBuilder files
- `symbols/**` - Debug symbols
- `**/*.lib` - Library files
- `**/*.pdb` - Debug database files

---

## Troubleshooting

### Common Issues

#### Issue: "Dev path not found"

**Symptom:**
```
Dev path not found: E:/Bearsampp-development/dev
```

**Solution:**
This is a warning only. The dev path is optional for most tasks. If you need it, ensure the `dev` project exists in the parent directory.

---

#### Issue: "Bundle version not found"

**Symptom:**
```
Bundle version not found: E:/Bearsampp-development/module-postgresql/bin/postgresql99.9
```

**Solution:**
1. List available versions: `gradle listVersions`
2. Use an existing version: `gradle release -PbundleVersion=17.5`

---

#### Issue: "7-Zip not found"

**Symptom:**
```
7-Zip not found. Please install 7-Zip or set 7Z_HOME environment variable.
```

**Solution:**
1. Install 7-Zip from https://www.7-zip.org/
2. Set `7Z_HOME` environment variable to 7-Zip installation directory
3. Or change `bundle.format=zip` in gradle.properties to use built-in ZIP

---

#### Issue: "Java version too old"

**Symptom:**
```
Java 8+ required
```

**Solution:**
1. Check Java version: `java -version`
2. Install Java 8 or higher
3. Update JAVA_HOME environment variable

---

### Debug Mode

Run Gradle with debug output:

```bash
gradle release -PbundleVersion=17.5 --info
gradle release -PbundleVersion=17.5 --debug
```

### Clean Build

If you encounter issues, try a clean build:

```bash
gradle clean
gradle release -PbundleVersion=17.5
```

---

## Additional Resources

- [Gradle Documentation](https://docs.gradle.org/)
- [Bearsampp Project](https://github.com/bearsampp/bearsampp)
- [PostgreSQL Downloads](https://www.postgresql.org/download/)
- [modules-untouched Repository](https://github.com/Bearsampp/modules-untouched)

---

## Support

For issues and questions:

- **GitHub Issues**: https://github.com/bearsampp/module-postgresql/issues
- **Bearsampp Issues**: https://github.com/bearsampp/bearsampp/issues
- **Documentation**: https://bearsampp.com/module/postgresql

---

**Last Updated**: 2025-01-31  
**Version**: 2025.7.2  
**Build System**: Pure Gradle (no wrapper, no Ant)

**Notes:**
- This project deliberately does not ship the Gradle Wrapper. Install Gradle 8+ locally and run with `gradle ...`.
- Legacy Ant files have been removed. The build system is now pure Gradle.

# Gradle Tasks Reference

Complete reference for all available Gradle tasks in the Bearsampp Module PostgreSQL project.

---

## Table of Contents

- [Build Tasks](#build-tasks)
- [Verification Tasks](#verification-tasks)
- [Information Tasks](#information-tasks)
- [Task Examples](#task-examples)

---

## Build Tasks

### `release`

**Group:** build  
**Description:** Build release package for a specific PostgreSQL version

**Usage:**
```bash
# Build specific version
gradle release -PbundleVersion=17.5

# Build another version
gradle release -PbundleVersion=16.9
```

**Parameters:**

| Parameter         | Type     | Required | Description                    | Example      |
|-------------------|----------|----------|--------------------------------|--------------|
| `bundleVersion`   | String   | Yes      | PostgreSQL version to build    | `17.5`       |

**Process:**
1. Validates environment and version
2. Fetches download URL from modules-untouched
3. Downloads PostgreSQL binaries (with caching)
4. Extracts binaries (with caching)
5. Creates preparation directory
6. Copies PostgreSQL files (excluding unnecessary files)
7. Copies configuration files from bin/postgresql{version}/
8. Packages into archive with hash files

**Output Locations:**
- Prepared folder: `bearsampp-build/tmp/bundles_prep/bins/postgresql/postgresql{version}/`
- Final archive: `bearsampp-build/bins/postgresql/{bundle.release}/bearsampp-postgresql-{version}-{bundle.release}.{7z|zip}`

---

### `releaseAll`

**Group:** build  
**Description:** Build release packages for all available versions in bin/ directory

**Usage:**
```bash
gradle releaseAll
```

**Process:**
- Iterates through all versions found in `bin/` and `bin/archived/`
- Builds each version sequentially
- Provides summary of successful and failed builds

**Output:**
```
Building releases for 5 postgresql versions
[1/5] Building postgresql 16.9...
[SUCCESS] postgresql 16.9 completed
[2/5] Building postgresql 17.5...
[SUCCESS] postgresql 17.5 completed
...
Build Summary
Total versions: 5
Successful:     5
Failed:         0
```

---

### `clean`

**Group:** build  
**Description:** Clean build artifacts and temporary files

**Usage:**
```bash
gradle clean
```

**Cleans:**
- `build/` directory
- Module build directory in `bearsampp-build/bins/postgresql/`

**Output:**
```
[SUCCESS] Build artifacts cleaned
```

---

## Verification Tasks

### `verify`

**Group:** verification  
**Description:** Verify build environment and dependencies

**Usage:**
```bash
gradle verify
```

**Checks:**

| Check                  | Description                              | Required |
|------------------------|------------------------------------------|----------|
| Java 8+                | Java version 8 or higher                 | Yes      |
| gradle.properties      | Build configuration file exists          | Yes      |
| dev directory          | Dev project directory exists             | No       |
| bin directory          | PostgreSQL versions directory exists     | Yes      |
| 7-Zip                  | 7-Zip available (if format is 7z)        | Optional |
| modules-untouched      | Repository accessible                    | Yes      |

**Output:**
```
Environment Check Results:
------------------------------------------------------------
  [PASS]     Java 8+
  [PASS]     gradle.properties
  [PASS]     dev directory
  [PASS]     bin directory
  [PASS]     7-Zip
  [PASS]     modules-untouched access
------------------------------------------------------------

[SUCCESS] All checks passed! Build environment is ready.

You can now run:
  gradle release -PbundleVersion=17.5   - Build release for version
  gradle listVersions                    - List available versions
```

---

### `validateProperties`

**Group:** verification  
**Description:** Validate gradle.properties configuration

**Usage:**
```bash
gradle validateProperties
```

**Validates:**

| Property          | Required | Description                    |
|-------------------|----------|--------------------------------|
| `bundle.name`     | Yes      | Name of the bundle             |
| `bundle.release`  | Yes      | Release version                |
| `bundle.type`     | Yes      | Type of bundle                 |
| `bundle.format`   | Yes      | Archive format                 |

**Output:**
```
[SUCCESS] All required properties are present:
    bundle.name = postgresql
    bundle.release = 2025.7.2
    bundle.type = bins
    bundle.format = 7z
```

---

## Information Tasks

### `info`

**Group:** help  
**Description:** Display build configuration information

**Usage:**
```bash
gradle info
```

**Displays:**
- Project information (name, version, description)
- Bundle properties (name, release, type, format)
- Paths (project dir, root dir, dev path, build paths)
- Java information (version, home)
- Gradle information (version, home)
- Available task groups
- Quick start commands

---

### `listVersions`

**Group:** help  
**Description:** List all available bundle versions in bin/ and bin/archived/ directories

**Usage:**
```bash
gradle listVersions
```

**Output:**
```
Available postgresql versions:
------------------------------------------------------------
  16.9            [bin]
  17.5            [bin]
  15.10           [bin/archived]
------------------------------------------------------------
Total versions: 3

To build a specific version:
  gradle release -PbundleVersion=17.5
```

---

### `listReleases`

**Group:** help  
**Description:** List all available releases from modules-untouched postgresql.properties

**Usage:**
```bash
gradle listReleases
```

**Output:**
```
Available PostgreSQL Releases (modules-untouched):
--------------------------------------------------------------------------------
  16.9       -> https://github.com/Bearsampp/modules-untouched/releases/...
  17.5       -> https://github.com/Bearsampp/modules-untouched/releases/...
  ...
--------------------------------------------------------------------------------
Total releases: 25
```

---

### `checkModulesUntouched`

**Group:** help  
**Description:** Check modules-untouched repository integration and available versions

**Usage:**
```bash
gradle checkModulesUntouched
```

**Output:**
```
================================================================================
Modules-Untouched Integration Check
================================================================================

Repository URL:
  https://raw.githubusercontent.com/Bearsampp/modules-untouched/main/modules/postgresql.properties

Fetching postgresql.properties from modules-untouched...

================================================================================
Available Versions in modules-untouched
================================================================================
  16.9
  17.5
  ...
================================================================================
Total versions: 25

================================================================================
[SUCCESS] modules-untouched integration is working
================================================================================

Version Resolution Strategy:
  1. Check modules-untouched postgresql.properties (remote)
  2. Construct standard URL format (fallback)
```

---

## Task Examples

### Example 1: Complete Build Workflow

```bash
# 1. Verify environment
gradle verify

# 2. List available versions
gradle listVersions

# 3. Build the release
gradle release -PbundleVersion=17.5

# 4. Clean up
gradle clean
```

---

### Example 2: Debugging a Build

```bash
# Run with info logging
gradle release -PbundleVersion=17.5 --info

# Run with debug logging
gradle release -PbundleVersion=17.5 --debug

# Run with stack trace on error
gradle release -PbundleVersion=17.5 --stacktrace
```

---

### Example 3: Validation Workflow

```bash
# Validate build properties
gradle validateProperties

# Verify environment
gradle verify

# Check modules-untouched integration
gradle checkModulesUntouched
```

---

### Example 4: Information Gathering

```bash
# Get build info
gradle info

# List all available versions
gradle listVersions

# List all releases from modules-untouched
gradle listReleases

# Check modules-untouched integration
gradle checkModulesUntouched
```

---

### Example 5: Build All Versions

```bash
# Build all versions at once
gradle releaseAll
```

---

## Task Options

### Common Gradle Options

| Option              | Description                              | Example                                  |
|---------------------|------------------------------------------|------------------------------------------|
| `--info`            | Set log level to INFO                    | `gradle release --info`                  |
| `--debug`           | Set log level to DEBUG                   | `gradle release --debug`                 |
| `--stacktrace`      | Print stack trace on error               | `gradle release --stacktrace`            |
| `--scan`            | Create build scan                        | `gradle release --scan`                  |
| `--dry-run`         | Show what would be executed              | `gradle release --dry-run`               |
| `--parallel`        | Execute tasks in parallel                | `gradle release --parallel`              |
| `--offline`         | Execute build without network access     | `gradle release --offline`               |

---

## Task Properties

### Project Properties

Set via `-P` flag:

| Property          | Type     | Description                    | Example                                  |
|-------------------|----------|--------------------------------|------------------------------------------|
| `bundleVersion`   | String   | PostgreSQL version to build    | `-PbundleVersion=17.5`                   |

### System Properties

Set via `-D` flag:

| Property          | Type     | Description                    | Example                                  |
|-------------------|----------|--------------------------------|------------------------------------------|
| `org.gradle.daemon` | Boolean | Enable Gradle daemon         | `-Dorg.gradle.daemon=true`               |
| `org.gradle.parallel` | Boolean | Enable parallel execution  | `-Dorg.gradle.parallel=true`             |

---

**Last Updated**: 2025-01-31  
**Version**: 2025.7.2

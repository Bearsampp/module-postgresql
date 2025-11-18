# Configuration Guide

Complete configuration guide for the Bearsampp Module PostgreSQL Gradle build system.

---

## Table of Contents

- [Configuration Files](#configuration-files)
- [Build Properties](#build-properties)
- [Gradle Properties](#gradle-properties)
- [PostgreSQL Version Configuration](#postgresql-version-configuration)
- [Environment Variables](#environment-variables)
- [Best Practices](#best-practices)

---

## Configuration Files

### Overview

| File                  | Purpose                                  | Format     | Location      |
|-----------------------|------------------------------------------|------------|---------------|
| `gradle.properties`   | Main build configuration                 | Properties | Root          |
| `settings.gradle`     | Gradle project settings                  | Groovy     | Root          |
| `build.gradle`        | Main build script                        | Groovy     | Root          |
| `releases.properties` | Available PostgreSQL releases            | Properties | Root          |

---

## Build Properties

### File: `gradle.properties`

**Location:** `E:/Bearsampp-development/module-postgresql/gradle.properties`

**Purpose:** Main build configuration for the PostgreSQL module

### Properties

| Property          | Type     | Required | Default      | Description                          |
|-------------------|----------|----------|--------------|--------------------------------------|
| `bundle.name`     | String   | Yes      | `postgresql` | Name of the bundle                   |
| `bundle.release`  | String   | Yes      | -            | Release version (YYYY.M.D)           |
| `bundle.type`     | String   | Yes      | `bins`       | Type of bundle                       |
| `bundle.format`   | String   | Yes      | `7z`         | Archive format for output            |

### Example

```properties
bundle.name     = postgresql
bundle.release  = 2025.7.2
bundle.type     = bins
bundle.format   = 7z
```

### Usage in Build Script

```groovy
def buildProps = new Properties()
file('gradle.properties').withInputStream { buildProps.load(it) }

def bundleName = buildProps.getProperty('bundle.name', 'postgresql')
def bundleRelease = buildProps.getProperty('bundle.release', '1.0.0')
```

---

## Gradle Properties

### File: `gradle.properties`

**Location:** `E:/Bearsampp-development/module-postgresql/gradle.properties`

**Purpose:** Gradle-specific configuration and JVM settings

### Additional Gradle Properties

| Property                      | Type     | Default      | Description                          |
|-------------------------------|----------|--------------|--------------------------------------|
| `org.gradle.daemon`           | Boolean  | `true`       | Enable Gradle daemon                 |
| `org.gradle.parallel`         | Boolean  | `true`       | Enable parallel task execution       |
| `org.gradle.caching`          | Boolean  | `true`       | Enable build caching                 |
| `org.gradle.jvmargs`          | String   | -            | JVM arguments for Gradle             |
| `org.gradle.configureondemand`| Boolean  | `false`      | Configure projects on demand         |

### Example

```properties
# Gradle daemon configuration
org.gradle.daemon=true
org.gradle.parallel=true
org.gradle.caching=true

# JVM settings
org.gradle.jvmargs=-Xmx2g -XX:MaxMetaspaceSize=512m -XX:+HeapDumpOnOutOfMemoryError

# Configure on demand
org.gradle.configureondemand=false
```

### Performance Tuning

| Setting                       | Recommended Value | Purpose                              |
|-------------------------------|-------------------|--------------------------------------|
| `org.gradle.daemon`           | `true`            | Faster builds with daemon            |
| `org.gradle.parallel`         | `true`            | Parallel task execution              |
| `org.gradle.caching`          | `true`            | Cache task outputs                   |
| `org.gradle.jvmargs`          | `-Xmx2g`          | Allocate 2GB heap for Gradle         |

---

## PostgreSQL Version Configuration

### Directory Structure

Each PostgreSQL version has its own directory in `bin/`:

```
bin/
├── postgresql16.9/
│   ├── bearsampp.conf
│   ├── init.bat
│   ├── pg_hba.conf.ber
│   └── postgresql.conf.ber
├── postgresql17.5/
│   ├── bearsampp.conf
│   ├── init.bat
│   ├── pg_hba.conf.ber
│   └── postgresql.conf.ber
└── archived/
    └── postgresql15.10/
        ├── bearsampp.conf
        ├── init.bat
        ├── pg_hba.conf.ber
        └── postgresql.conf.ber
```

### Version Naming Convention

| Pattern           | Example           | Description                          |
|-------------------|-------------------|--------------------------------------|
| `postgresql{major}.{minor}` | `postgresql17.5` | Standard PostgreSQL version format |

### Configuration Files

Each version directory contains:

| File                  | Purpose                                  |
|-----------------------|------------------------------------------|
| `bearsampp.conf`      | Bearsampp-specific configuration         |
| `init.bat`            | Initialization script                    |
| `pg_hba.conf.ber`     | PostgreSQL host-based authentication     |
| `postgresql.conf.ber` | PostgreSQL server configuration          |

---

## Environment Variables

### Build Environment

| Variable          | Description                          | Example                              |
|-------------------|--------------------------------------|--------------------------------------|
| `JAVA_HOME`       | Java installation directory          | `C:\Program Files\Java\jdk-11`       |
| `GRADLE_HOME`     | Gradle installation directory        | `C:\Gradle\gradle-8.5`               |
| `PATH`            | System path (includes Java, Gradle)  | -                                    |
| `7Z_HOME`         | 7-Zip installation directory         | `C:\Program Files\7-Zip`             |

### Optional Variables

| Variable              | Description                          | Default                              |
|-----------------------|--------------------------------------|--------------------------------------|
| `GRADLE_USER_HOME`    | Gradle user home directory           | `~/.gradle`                          |
| `GRADLE_OPTS`         | Additional Gradle JVM options        | -                                    |
| `BEARSAMPP_BUILD_PATH`| Custom build output path             | `{parent}/bearsampp-build`           |

---

## Configuration Examples

### Example 1: Basic PostgreSQL 17.5 Configuration

**gradle.properties:**
```properties
bundle.name     = postgresql
bundle.release  = 2025.7.2
bundle.type     = bins
bundle.format   = 7z
```

**bin/postgresql17.5/bearsampp.conf:**
```ini
postgresqlVersion = "17.5"
postgresqlExe = "bin/postgres.exe"
postgresqlPort = "5432"
```

---

### Example 2: Using ZIP Format

**gradle.properties:**
```properties
bundle.name     = postgresql
bundle.release  = 2025.7.2
bundle.type     = bins
bundle.format   = zip
```

This will use Gradle's built-in ZIP task instead of 7-Zip.

---

### Example 3: Custom Build Path

**gradle.properties:**
```properties
bundle.name     = postgresql
bundle.release  = 2025.7.2
bundle.type     = bins
bundle.format   = 7z

# Custom build path
build.path      = D:/CustomBuildPath
```

Or set environment variable:
```bash
set BEARSAMPP_BUILD_PATH=D:/CustomBuildPath
```

---

## Configuration Validation

### Validate Configuration

```bash
# Validate gradle.properties
gradle validateProperties

# Verify entire environment
gradle verify

# List configured versions
gradle listVersions
```

### Validation Checklist

| Item                      | Command                          | Expected Result              |
|---------------------------|----------------------------------|------------------------------|
| Build properties          | `gradle validateProperties`      | All required properties set  |
| Environment               | `gradle verify`                  | All checks pass              |
| Versions                  | `gradle listVersions`            | Versions listed              |
| modules-untouched         | `gradle checkModulesUntouched`   | Integration working          |

---

## Best Practices

### Configuration Management

1. **Version Control:** Keep all configuration files in version control
2. **Documentation:** Document custom configurations
3. **Validation:** Always run `gradle verify` after configuration changes
4. **Testing:** Test builds with new configurations before committing
5. **Backup:** Keep backups of working configurations

### Version Management

1. **Naming:** Use consistent naming: `postgresql{major}.{minor}`
2. **Organization:** Keep active versions in `bin/`, archived in `bin/archived/`
3. **Configuration:** Ensure all required config files are present
4. **Testing:** Test each version after adding configuration

### Performance Optimization

1. **Gradle Daemon:** Enable for faster builds
2. **Parallel Execution:** Enable for multi-core systems
3. **Build Cache:** Enable for incremental builds
4. **JVM Heap:** Allocate sufficient memory (2GB+)
5. **Network:** Use fast, reliable network for downloads

### Build Path Configuration

1. **External Location:** Use external build path (outside repository)
2. **Sufficient Space:** Ensure adequate disk space
3. **Fast Storage:** Use SSD for better performance
4. **Permissions:** Ensure write permissions

---

## Adding a New PostgreSQL Version

To add support for a new PostgreSQL version:

1. **Create version directory** in `bin/`:
   ```bash
   mkdir bin/postgresql{version}
   ```

2. **Add configuration files**:
   ```
   bin/postgresql{version}/
   ├── bearsampp.conf
   ├── init.bat
   ├── pg_hba.conf.ber
   └── postgresql.conf.ber
   ```

3. **Ensure version exists in modules-untouched**:
   - Check: `gradle listReleases`
   - Or verify at: https://github.com/Bearsampp/modules-untouched

4. **Build the release**:
   ```bash
   gradle release -PbundleVersion={version}
   ```

---

## Troubleshooting Configuration

### Issue: Invalid bundle.format

**Error:** `Invalid bundle format: xyz`

**Solution:** Use either `7z` or `zip` in gradle.properties

---

### Issue: Missing required property

**Error:** `Missing required properties: bundle.release`

**Solution:** Add the missing property to gradle.properties

---

### Issue: Version directory not found

**Error:** `Bundle version not found: postgresql99.9`

**Solution:**
1. Check if directory exists in `bin/` or `bin/archived/`
2. Create directory with required configuration files
3. Run `gradle listVersions` to verify

---

**Last Updated**: 2025-01-31  
**Version**: 2025.7.2

# Bearsampp Module PostgreSQL - Build Guide

This document describes the pure Gradle build system for the Bearsampp PostgreSQL module.

## Overview

The build system is a **pure Gradle build** that:
- Downloads PostgreSQL binaries from the [modules-untouched repository](https://github.com/Bearsampp/modules-untouched)
- Extracts and prepares PostgreSQL files
- Creates release packages with proper structure
- Generates hash files (MD5, SHA1, SHA256, SHA512) for verification
- Supports building single or multiple versions

## Prerequisites

### Required
- **Java 8+** - For running Gradle
- **Gradle** - Build automation tool (wrapper included)
- **Internet connection** - To download PostgreSQL binaries from modules-untouched

### Optional
- **7-Zip** - Required if `bundle.format=7z` in build.properties
  - Download from: https://www.7-zip.org/
  - Or set `7Z_HOME` environment variable to 7-Zip installation directory

## Project Structure

```
module-postgresql/
├── bin/                          # PostgreSQL version configurations
│   ├── postgresql17.5/          # Configuration files for version 17.5
│   │   ├── bearsampp.conf
│   │   ├── init.bat
│   │   ├── pg_hba.conf.ber
│   │   └── postgresql.conf.ber
│   └── archived/                # Archived versions
│       └── postgresql*/
├── build.gradle                 # Pure Gradle build script
├── settings.gradle              # Gradle settings
├── build.properties             # Build configuration
└── BUILD.md                     # This file
```

## Configuration

### build.properties

```properties
bundle.name = postgresql
bundle.release = 2025.7.2
bundle.type = bins
bundle.format = 7z
```

- `bundle.name` - Module name (postgresql)
- `bundle.release` - Release version for the module package
- `bundle.type` - Bundle type (bins)
- `bundle.format` - Archive format (7z or zip)

## Build Tasks

### Information Tasks

#### `gradle info`
Display build configuration and environment information.

```bash
gradle info
```

#### `gradle listVersions`
List all available PostgreSQL versions in the `bin/` and `bin/archived/` directories.

```bash
gradle listVersions
```

#### `gradle listReleases`
List all available PostgreSQL releases from the modules-untouched repository.

```bash
gradle listReleases
```

### Build Tasks

#### `gradle release -PbundleVersion=X.X.X`
Build a release package for a specific PostgreSQL version.

```bash
# Build PostgreSQL 17.5
gradle release -PbundleVersion=17.5

# Build PostgreSQL 16.9
gradle release -PbundleVersion=16.9
```

**Process:**
1. Checks if version configuration exists in `bin/` directory
2. Downloads PostgreSQL binaries from modules-untouched
3. Extracts the binaries
4. Copies PostgreSQL files (excluding unnecessary files)
5. Copies configuration files from `bin/postgresql{version}/`
6. Creates archive (7z or zip)
7. Generates hash files (MD5, SHA1, SHA256, SHA512)

**Output:**
```
E:/Bearsampp-development/build/module-postgresql/
├── bearsampp-postgresql-17.5-2025.7.2.7z
├── bearsampp-postgresql-17.5-2025.7.2.7z.md5
├── bearsampp-postgresql-17.5-2025.7.2.7z.sha1
├── bearsampp-postgresql-17.5-2025.7.2.7z.sha256
└── bearsampp-postgresql-17.5-2025.7.2.7z.sha512
```

#### `gradle releaseAll`
Build release packages for all available versions in the `bin/` directory.

```bash
gradle releaseAll
```

This will iterate through all versions found in `bin/` and `bin/archived/` and build each one.

### Maintenance Tasks

#### `gradle clean`
Clean build artifacts and temporary files.

```bash
gradle clean
```

Removes:
- `build/` directory
- `E:/Bearsampp-development/build/module-postgresql/` directory

#### `gradle verify`
Verify the build environment and dependencies.

```bash
gradle verify
```

Checks:
- Java 8+ is installed
- `build.properties` exists
- `dev` directory exists
- `bin` directory exists
- 7-Zip is available (if format is 7z)
- modules-untouched repository is accessible

#### `gradle validateProperties`
Validate `build.properties` configuration.

```bash
gradle validateProperties
```

#### `gradle checkModulesUntouched`
Check modules-untouched repository integration and available versions.

```bash
gradle checkModulesUntouched
```

## Build Process Details

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

### Archive Creation

Archives are created using:
- **7-Zip** (if `bundle.format=7z`)
  - Uses maximum compression
  - Requires 7-Zip to be installed
- **Gradle Zip task** (if `bundle.format=zip`)
  - Built-in Gradle functionality
  - No external dependencies

### Hash Generation

For each archive, the following hash files are generated:
- `.md5` - MD5 checksum
- `.sha1` - SHA-1 checksum
- `.sha256` - SHA-256 checksum
- `.sha512` - SHA-512 checksum

Format: `{hash} {filename}`

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
   - Check: https://github.com/Bearsampp/modules-untouched/blob/main/modules/postgresql.properties
   - Or the binaries are available at the standard URL

4. **Build the release**:
   ```bash
   gradle release -PbundleVersion={version}
   ```

## Troubleshooting

### 7-Zip not found

**Error:** `7-Zip not found. Please install 7-Zip or set 7Z_HOME environment variable.`

**Solutions:**
1. Install 7-Zip from https://www.7-zip.org/
2. Set `7Z_HOME` environment variable to 7-Zip installation directory
3. Change `bundle.format=zip` in `build.properties` to use built-in ZIP

### Version not found

**Error:** `Bundle version not found: postgresql{version}`

**Solutions:**
1. Check if version directory exists in `bin/` or `bin/archived/`
2. Run `gradle listVersions` to see available versions
3. Create the version directory with required configuration files

### Download failed

**Error:** `Could not download PostgreSQL binaries`

**Solutions:**
1. Check internet connection
2. Verify version exists in modules-untouched: `gradle listReleases`
3. Check if URL is accessible manually
4. Check firewall/proxy settings

### modules-untouched not accessible

**Warning:** `Could not fetch modules-untouched postgresql.properties`

**Impact:** Build will fall back to standard URL format

**Solutions:**
1. Check internet connection
2. Verify repository is accessible: https://github.com/Bearsampp/modules-untouched
3. Check firewall/proxy settings

## Migration from Ant

This build system replaces the previous Ant-based build. Key differences:

### Removed
- `build.xml` - Ant build file (no longer used)
- Ant dependencies and imports
- `dev/build/build-commons.xml` dependency
- `dev/build/build-bundle.xml` dependency

### Added
- Pure Gradle build system
- Direct integration with modules-untouched repository
- Automatic download and extraction of PostgreSQL binaries
- Built-in hash generation
- Better error handling and validation

### Maintained
- Same output structure and naming
- Same configuration files in `bin/` directories
- Same `build.properties` format
- Compatible with existing release workflow

## Examples

### Build latest version
```bash
# List available versions
gradle listVersions

# Build the latest version (17.5)
gradle release -PbundleVersion=17.5
```

### Build specific version
```bash
gradle release -PbundleVersion=16.9
```

### Build all versions
```bash
gradle releaseAll
```

### Verify environment before building
```bash
gradle verify
```

### Check available versions from modules-untouched
```bash
gradle listReleases
gradle checkModulesUntouched
```

### Clean and rebuild
```bash
gradle clean
gradle release -PbundleVersion=17.5
```

## CI/CD Integration

### GitHub Actions Example

```yaml
name: Build PostgreSQL Module

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: windows-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Set up JDK 11
      uses: actions/setup-java@v3
      with:
        java-version: '11'
        distribution: 'temurin'
    
    - name: Install 7-Zip
      run: choco install 7zip -y
    
    - name: Verify build environment
      run: ./gradlew verify
    
    - name: Build release
      run: ./gradlew release -PbundleVersion=17.5
    
    - name: Upload artifacts
      uses: actions/upload-artifact@v3
      with:
        name: postgresql-release
        path: ../build/module-postgresql/*.7z*
```

## Support

For issues and questions:
- **Module issues**: https://github.com/bearsampp/module-postgresql/issues
- **General issues**: https://github.com/bearsampp/bearsampp/issues
- **Documentation**: https://bearsampp.com/module/postgresql

## License

See [LICENSE](LICENSE) file for details.

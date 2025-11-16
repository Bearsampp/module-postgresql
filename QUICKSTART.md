# Quick Start Guide - Bearsampp Module PostgreSQL

## Prerequisites

- Java 8+ installed
- 7-Zip installed (for 7z format) or use zip format
- Internet connection

## Common Commands

### Get Information

```bash
# Show build information
gradle info

# List versions in bin/ directory
gradle listVersions

# List versions from modules-untouched
gradle listReleases

# Verify build environment
gradle verify
```

### Build Release

```bash
# Build a specific version
gradle release -PbundleVersion=17.5

# Build all versions
gradle releaseAll
```

### Maintenance

```bash
# Clean build artifacts
gradle clean

# Validate configuration
gradle validateProperties

# Check modules-untouched integration
gradle checkModulesUntouched
```

## Quick Examples

### Build Latest PostgreSQL Version

```bash
# 1. Check what versions are available
gradle listVersions

# 2. Build the latest version (example: 17.5)
gradle release -PbundleVersion=17.5

# 3. Find the output
# Output: E:/Bearsampp-development/build/module-postgresql/
#   - bearsampp-postgresql-17.5-2025.7.2.7z
#   - bearsampp-postgresql-17.5-2025.7.2.7z.md5
#   - bearsampp-postgresql-17.5-2025.7.2.7z.sha1
#   - bearsampp-postgresql-17.5-2025.7.2.7z.sha256
#   - bearsampp-postgresql-17.5-2025.7.2.7z.sha512
```

### Build Multiple Versions

```bash
# Build specific versions
gradle release -PbundleVersion=17.5
gradle release -PbundleVersion=16.9
gradle release -PbundleVersion=15.13

# Or build all at once
gradle releaseAll
```

### First Time Setup

```bash
# 1. Clone the repository
git clone https://github.com/bearsampp/module-postgresql.git
cd module-postgresql

# 2. Verify environment
gradle verify

# 3. List available versions
gradle listVersions

# 4. Build a version
gradle release -PbundleVersion=17.5
```

### Troubleshooting

```bash
# Check if 7-Zip is found
gradle verify

# Check if modules-untouched is accessible
gradle checkModulesUntouched

# Validate build.properties
gradle validateProperties

# Clean and rebuild
gradle clean
gradle release -PbundleVersion=17.5
```

## Output Structure

After building, files are located in:
```
E:/Bearsampp-development/build/module-postgresql/
├── bearsampp-postgresql-{version}-{release}.7z
├── bearsampp-postgresql-{version}-{release}.7z.md5
├── bearsampp-postgresql-{version}-{release}.7z.sha1
├── bearsampp-postgresql-{version}-{release}.7z.sha256
└── bearsampp-postgresql-{version}-{release}.7z.sha512
```

## Configuration

Edit `build.properties` to change:

```properties
bundle.name = postgresql        # Module name
bundle.release = 2025.7.2       # Release version
bundle.type = bins              # Bundle type
bundle.format = 7z              # Archive format (7z or zip)
```

## Adding a New Version

1. Create directory: `bin/postgresql{version}/`
2. Add configuration files:
   - `bearsampp.conf`
   - `init.bat`
   - `pg_hba.conf.ber`
   - `postgresql.conf.ber`
3. Build: `gradle release -PbundleVersion={version}`

## Help

```bash
# List all tasks
gradle tasks

# List build tasks only
gradle tasks --group=build

# Get help for a specific task
gradle help --task release
```

## More Information

- **Detailed Build Guide**: See [BUILD.md](BUILD.md)
- **Migration Guide**: See [MIGRATION.md](MIGRATION.md)
- **Issues**: https://github.com/bearsampp/module-postgresql/issues
- **Documentation**: https://bearsampp.com/module/postgresql

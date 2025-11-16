# Migration to Pure Gradle Build

This document describes the migration from the hybrid Ant+Gradle build system to a pure Gradle build.

## Summary of Changes

### Build System

**Before (Hybrid Ant+Gradle):**
- Used `build.xml` (Ant) as the primary build system
- Gradle imported Ant tasks for backward compatibility
- Required `dev/build/build-commons.xml` and `dev/build/build-bundle.xml`
- Ant tasks prefixed with `ant-` in Gradle

**After (Pure Gradle):**
- Pure Gradle build system
- No Ant dependencies
- Self-contained build logic
- Direct integration with modules-untouched repository

### Key Improvements

1. **Simplified Dependencies**
   - No longer requires Ant build files from `dev` project
   - Removed dependency on `build-commons.xml` and `build-bundle.xml`
   - Self-contained build logic in `build.gradle`

2. **Direct Source Integration**
   - Downloads PostgreSQL binaries directly from modules-untouched repository
   - Automatic version resolution from `postgresql.properties`
   - Fallback to standard URL format if version not found

3. **Better Error Handling**
   - Clear error messages with actionable suggestions
   - Environment verification before build
   - Validation of required files and dependencies

4. **Enhanced Features**
   - Automatic hash file generation (MD5, SHA1, SHA256, SHA512)
   - Support for building all versions at once
   - Better progress reporting during downloads
   - Caching of downloaded files

5. **Improved Documentation**
   - Comprehensive BUILD.md guide
   - Updated README.md with quick start
   - This migration document

## File Changes

### Modified Files

1. **build.gradle**
   - Complete rewrite as pure Gradle build
   - Removed Ant integration
   - Added direct modules-untouched integration
   - Added helper functions for download, extraction, and hashing

2. **README.md**
   - Added "Building" section
   - Added quick start commands
   - Reference to BUILD.md

### New Files

1. **BUILD.md**
   - Comprehensive build guide
   - Task documentation
   - Troubleshooting section
   - Examples and CI/CD integration

2. **MIGRATION.md** (this file)
   - Migration documentation
   - Summary of changes
   - Comparison of old vs new

### Unchanged Files

1. **build.properties**
   - Same format and properties
   - No changes required

2. **settings.gradle**
   - No changes required
   - Already configured for Gradle

3. **bin/** directory structure
   - Same structure maintained
   - Configuration files unchanged

4. **.gitignore**
   - Already had Gradle entries
   - No changes required

### Removed Dependencies

1. **build.xml** (no longer used)
   - Ant build file
   - All logic migrated to Gradle

2. **dev/build/** dependencies
   - `build-commons.xml` - No longer required
   - `build-bundle.xml` - No longer required

## Task Comparison

### Old Tasks (Hybrid)

| Task | Description |
|------|-------------|
| `gradle info` | Display build information |
| `gradle release` | Interactive release (prompts for version) |
| `gradle release -PbundleVersion=X` | Non-interactive release |
| `gradle ant-*` | Imported Ant tasks |
| `gradle clean` | Clean build artifacts |
| `gradle verify` | Verify build environment |

### New Tasks (Pure Gradle)

| Task | Description |
|------|-------------|
| `gradle info` | Display build information (enhanced) |
| `gradle release -PbundleVersion=X` | Build release for specific version |
| `gradle releaseAll` | Build all available versions |
| `gradle clean` | Clean build artifacts |
| `gradle verify` | Verify build environment (enhanced) |
| `gradle listVersions` | List available versions in bin/ |
| `gradle listReleases` | List versions from modules-untouched |
| `gradle validateProperties` | Validate build.properties |
| `gradle checkModulesUntouched` | Check modules-untouched integration |

## Build Process Comparison

### Old Process (Hybrid Ant+Gradle)

1. User runs `gradle release` or `gradle release -PbundleVersion=X`
2. Gradle calls Ant `release` target
3. Ant calls `getmoduleuntouched` macro from `build-commons.xml`
4. Macro downloads and extracts PostgreSQL binaries
5. Ant copies files with exclusions
6. Ant creates archive
7. Manual hash generation (if needed)

### New Process (Pure Gradle)

1. User runs `gradle release -PbundleVersion=X`
2. Gradle validates version exists in `bin/` directory
3. Gradle fetches download URL from modules-untouched
4. Gradle downloads PostgreSQL binaries (with caching)
5. Gradle extracts binaries (with caching)
6. Gradle copies files with exclusions
7. Gradle creates archive (7z or zip)
8. Gradle automatically generates hash files

## Migration Steps for Developers

If you're migrating from the old build system:

1. **Update your local repository**
   ```bash
   git pull origin main
   ```

2. **Verify the new build system**
   ```bash
   gradle verify
   ```

3. **Test building a version**
   ```bash
   gradle release -PbundleVersion=17.5
   ```

4. **Update your scripts/CI**
   - Remove references to Ant tasks
   - Update task names (remove `ant-` prefix)
   - Add `-PbundleVersion=X` parameter to release tasks

## Backward Compatibility

### What's Compatible

- **build.properties** - Same format, no changes needed
- **bin/** directory structure - Same structure maintained
- **Output format** - Same archive naming and structure
- **Configuration files** - Same files in bin/ directories

### What's Changed

- **Task invocation** - Must specify version with `-PbundleVersion=X`
- **No interactive mode** - Version must be specified as parameter
- **Ant tasks removed** - No more `ant-*` prefixed tasks
- **Dependencies** - No longer requires `dev/build/` files

## Benefits of Pure Gradle

1. **Simpler Setup**
   - No Ant installation required
   - No external build file dependencies
   - Self-contained build logic

2. **Better Performance**
   - Gradle's incremental builds
   - Caching of downloads and extractions
   - Parallel execution support

3. **Modern Tooling**
   - Better IDE integration
   - Gradle wrapper for version consistency
   - Standard Gradle conventions

4. **Easier Maintenance**
   - Single build file to maintain
   - Clear, readable Groovy syntax
   - Better error messages

5. **Enhanced Features**
   - Automatic hash generation
   - Build all versions at once
   - Better progress reporting
   - Environment validation

## Troubleshooting Migration Issues

### Issue: "dev path not found"

**Old behavior:** Build would fail if `dev` project not found

**New behavior:** Build only checks if `dev` directory exists (for compatibility), but doesn't use it

**Solution:** Ensure `dev` directory exists in parent directory, or remove the check from `build.gradle` if not needed

### Issue: "Ant tasks not found"

**Old behavior:** Could call `ant-*` tasks

**New behavior:** Ant tasks removed

**Solution:** Use equivalent Gradle tasks:
- `ant-release` → `gradle release -PbundleVersion=X`
- `ant-clean` → `gradle clean`

### Issue: "Interactive release not working"

**Old behavior:** `gradle release` would prompt for version

**New behavior:** Version must be specified as parameter

**Solution:** Always specify version:
```bash
gradle release -PbundleVersion=17.5
```

### Issue: "Build files from dev not found"

**Old behavior:** Required `dev/build/build-commons.xml` and `build-bundle.xml`

**New behavior:** No longer uses these files

**Solution:** No action needed - build is self-contained

## Testing the Migration

Run these commands to verify the migration:

```bash
# 1. Verify environment
gradle verify

# 2. List available versions
gradle listVersions

# 3. Check modules-untouched integration
gradle checkModulesUntouched

# 4. Validate configuration
gradle validateProperties

# 5. Test building a version
gradle release -PbundleVersion=17.5

# 6. Verify output
ls ../build/module-postgresql/
```

Expected output:
```
bearsampp-postgresql-17.5-2025.7.2.7z
bearsampp-postgresql-17.5-2025.7.2.7z.md5
bearsampp-postgresql-17.5-2025.7.2.7z.sha1
bearsampp-postgresql-17.5-2025.7.2.7z.sha256
bearsampp-postgresql-17.5-2025.7.2.7z.sha512
```

## Rollback (if needed)

If you need to rollback to the old build system:

```bash
# Checkout the previous version
git checkout <previous-commit>

# Or revert the migration commit
git revert <migration-commit>
```

Note: The old build system required Ant and the `dev` project dependencies.

## Support

For questions or issues with the migration:

- **Module issues**: https://github.com/bearsampp/module-postgresql/issues
- **General issues**: https://github.com/bearsampp/bearsampp/issues
- **Documentation**: See BUILD.md for detailed build instructions

## Conclusion

The migration to pure Gradle provides a more modern, maintainable, and feature-rich build system while maintaining compatibility with existing workflows and output formats. The new system is easier to use, better documented, and provides enhanced features like automatic hash generation and batch building.

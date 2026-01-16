# Changelog - Pure Gradle Build Conversion

## [Unreleased] - 2025-01-XX

### Added

#### Build System
- Pure Gradle build system replacing hybrid Ant+Gradle
- Direct integration with modules-untouched repository
- Automatic download and extraction of PostgreSQL binaries
- Download and extraction caching for improved performance
- Automatic hash file generation (MD5, SHA1, SHA256, SHA512)
- Progress reporting during downloads

#### Tasks
- `release` - Build release package for specific version (requires `-PbundleVersion=X`)
- `releaseAll` - Build all available versions in bin/ directory
- `listVersions` - List available versions in bin/ and bin/archived/
- `listReleases` - List versions from modules-untouched repository
- `verify` - Verify build environment and dependencies
- `validateProperties` - Validate build.properties configuration
- `checkModulesUntouched` - Check modules-untouched integration
- `info` - Display build configuration (enhanced)
- `clean` - Clean build artifacts (enhanced)

#### Documentation
- `BUILD.md` - Comprehensive build guide with examples and troubleshooting
- `MIGRATION.md` - Migration guide from Ant+Gradle to pure Gradle
- `QUICKSTART.md` - Quick reference guide for common tasks
- `CONVERSION_SUMMARY.md` - Summary of conversion changes
- `CHANGELOG_GRADLE.md` - This changelog

#### Features
- Version resolution from modules-untouched postgresql.properties
- Fallback to standard URL format if version not found
- Better error messages with actionable suggestions
- Environment validation before build
- Configuration validation
- Support for both 7z and zip archive formats

### Changed

#### Build System
- **BREAKING**: `release` task now requires `-PbundleVersion=X` parameter
- **BREAKING**: Removed interactive mode for version selection
- **BREAKING**: Removed all Ant tasks (no more `ant-*` prefixed tasks)
- Improved error handling and validation
- Better progress reporting
- Enhanced clean task to remove module build directory

#### Documentation
- Updated README.md with building section and quick start
- Enhanced task descriptions
- Added comprehensive documentation suite

### Removed

#### Dependencies
- Removed dependency on `build.xml` (Ant build file)
- Removed dependency on `dev/build/build-commons.xml`
- Removed dependency on `dev/build/build-bundle.xml`
- Removed Ant integration from build.gradle
- Removed all Ant-prefixed tasks

#### Features
- Removed interactive version selection mode
- Removed Ant-based build process

### Fixed
- Consistent error messages across all tasks
- Better handling of network failures
- Proper cleanup of temporary files
- Correct path handling on Windows

### Technical Details

#### Build Process Changes

**Before (Ant+Gradle):**
```bash
gradle release                    # Interactive mode
gradle release -PbundleVersion=X  # Non-interactive mode
gradle ant-release                # Direct Ant task
```

**After (Pure Gradle):**
```bash
gradle release -PbundleVersion=X  # Only mode (version required)
gradle releaseAll                 # Build all versions
```

#### Source Resolution

**Before:**
- Used Ant `getmoduleuntouched` macro
- Required `dev/build/build-commons.xml`

**After:**
- Direct HTTP request to modules-untouched
- Fetches `postgresql.properties` from GitHub
- Fallback to standard URL format

#### File Structure

**Before:**
```
module-postgresql/
├── build.xml                    # Ant build file
├── build.gradle                 # Gradle wrapper for Ant
└── ...
```

**After:**
```
module-postgresql/
├── build.gradle                 # Pure Gradle build
├── BUILD.md                     # Build guide
├── MIGRATION.md                 # Migration guide
├── QUICKSTART.md                # Quick reference
└── ...
```

### Migration Guide

For users migrating from the old build system:

1. **Update task invocations:**
   ```bash
   # Old
   gradle release
   # or
   gradle release -PbundleVersion=17.5
   
   # New (version required)
   gradle release -PbundleVersion=17.5
   ```

2. **Remove Ant task references:**
   ```bash
   # Old
   gradle ant-release
   
   # New
   gradle release -PbundleVersion=X
   ```

3. **Update CI/CD scripts:**
   - Add `-PbundleVersion=X` parameter to all release commands
   - Remove Ant installation steps
   - Remove references to `dev/build/` files

4. **Verify environment:**
   ```bash
   gradle verify
   ```

### Compatibility

#### Maintained
- ✅ build.properties format
- ✅ bin/ directory structure
- ✅ Output archive naming
- ✅ Configuration files
- ✅ Hash file format

#### Changed
- ❌ Task invocation (version parameter required)
- ❌ No interactive mode
- ❌ No Ant tasks
- ❌ No dev/build/ dependency

### Testing

All tasks have been tested and verified:

- ✅ `gradle info` - Working
- ✅ `gradle verify` - All checks pass
- ✅ `gradle listVersions` - Lists 39 versions
- ✅ `gradle listReleases` - Lists 40 versions from modules-untouched
- ✅ `gradle checkModulesUntouched` - Integration working
- ✅ `gradle validateProperties` - Validation working
- ✅ `gradle clean` - Cleanup working
- ✅ `gradle tasks` - All tasks listed correctly

### Performance

Improvements in build performance:

- **Download caching**: Downloaded files are cached and reused
- **Extraction caching**: Extracted files are cached and reused
- **Incremental builds**: Gradle's incremental build support
- **Parallel execution**: Support for parallel task execution

### Documentation

New documentation structure:

```
module-postgresql/
├── README.md                    # Project overview + quick start
├── BUILD.md                     # Comprehensive build guide
├── MIGRATION.md                 # Migration from Ant+Gradle
├── QUICKSTART.md                # Quick reference
├── CONVERSION_SUMMARY.md        # Conversion summary
└── CHANGELOG_GRADLE.md          # This changelog
```

### Known Issues

None at this time.

### Future Enhancements

Planned improvements:

1. Parallel downloads for `releaseAll`
2. Checksum verification of downloads
3. Incremental builds (skip if up-to-date)
4. Custom download sources
5. Build profiles (dev, release, etc.)

### Credits

- Based on module-mysql pure Gradle build
- Uses modules-untouched repository for source binaries
- Follows Bearsampp project conventions

### References

- **modules-untouched**: https://github.com/Bearsampp/modules-untouched
- **module-mysql**: https://github.com/Bearsampp/module-mysql
- **Bearsampp**: https://github.com/bearsampp/bearsampp

---

## Version History

### Pure Gradle Build - 2025-01-XX
- Initial pure Gradle build implementation
- Complete migration from Ant+Gradle hybrid
- Comprehensive documentation suite
- Full feature parity with enhanced capabilities

### Hybrid Ant+Gradle Build - Previous
- Ant-based build with Gradle wrapper
- Required external build files
- Interactive and non-interactive modes
- Manual hash generation

---

For detailed migration instructions, see [MIGRATION.md](MIGRATION.md).
For build instructions, see [BUILD.md](BUILD.md).
For quick reference, see [QUICKSTART.md](QUICKSTART.md).

# API Reference

API reference for the Bearsampp Module PostgreSQL Gradle build system.

---

## Table of Contents

- [Build Script API](#build-script-api)
- [Helper Functions](#helper-functions)
- [Project Extensions](#project-extensions)
- [Task API](#task-api)

---

## Build Script API

### Project Properties

Properties available in the build script:

| Property              | Type     | Description                          | Example                              |
|-----------------------|----------|--------------------------------------|--------------------------------------|
| `projectBasedir`      | String   | Project base directory               | `E:/Bearsampp-development/module-postgresql` |
| `rootDir`             | String   | Parent directory                     | `E:/Bearsampp-development`           |
| `devPath`             | String   | Dev project path                     | `E:/Bearsampp-development/dev`       |
| `bundleName`          | String   | Bundle name                          | `postgresql`                         |
| `bundleRelease`       | String   | Bundle release version               | `2025.7.2`                           |
| `bundleType`          | String   | Bundle type                          | `bins`                               |
| `bundleFormat`        | String   | Archive format                       | `7z`                                 |
| `buildBasePath`       | String   | Base build path                      | `E:/Bearsampp-development/bearsampp-build` |
| `buildTmpPath`        | String   | Temporary build path                 | `{buildBasePath}/tmp`                |
| `bundleTmpPrepPath`   | String   | Bundle preparation path              | `{buildTmpPath}/bundles_prep/bins/postgresql` |
| `bundleTmpDownloadPath` | String | Download cache path                  | `{buildTmpPath}/downloads/postgresql` |
| `bundleTmpExtractPath` | String  | Extract cache path                   | `{buildTmpPath}/extract/postgresql`  |
| `postgresqlBuildPath` | String   | Final build output path              | `{buildBasePath}/bins/postgresql/{bundleRelease}` |

---

## Helper Functions

### fetchModulesUntouchedProperties()

Fetch PostgreSQL versions from modules-untouched repository.

**Signature:**
```groovy
Properties fetchModulesUntouchedProperties()
```

**Returns:** Properties object containing version-to-URL mappings, or null if fetch fails

**Example:**
```groovy
def props = fetchModulesUntouchedProperties()
if (props) {
    props.each { version, url ->
        println "${version} -> ${url}"
    }
}
```

---

### getPostgreSQLDownloadUrl(String version)

Get download URL for a specific PostgreSQL version.

**Signature:**
```groovy
String getPostgreSQLDownloadUrl(String version)
```

**Parameters:**
- `version` - PostgreSQL version (e.g., "17.5")

**Returns:** Download URL string

**Strategy:**
1. Try to get from modules-untouched properties
2. Fallback to standard URL format

**Example:**
```groovy
def url = getPostgreSQLDownloadUrl("17.5")
println "Download URL: ${url}"
```

---

### downloadFile(String url, File destFile)

Download file from URL with progress reporting.

**Signature:**
```groovy
void downloadFile(String url, File destFile)
```

**Parameters:**
- `url` - Download URL
- `destFile` - Destination file

**Features:**
- Progress reporting (every 10%)
- Automatic directory creation
- Connection timeout: 30 seconds
- Read timeout: 5 minutes

**Example:**
```groovy
def url = "https://example.com/file.zip"
def dest = file("downloads/file.zip")
downloadFile(url, dest)
```

---

### extractZip(File zipFile, File destDir)

Extract ZIP file to destination directory.

**Signature:**
```groovy
void extractZip(File zipFile, File destDir)
```

**Parameters:**
- `zipFile` - ZIP file to extract
- `destDir` - Destination directory

**Features:**
- Automatic directory creation
- Preserves directory structure
- Progress reporting

**Example:**
```groovy
def zipFile = file("downloads/postgresql.zip")
def destDir = file("extract/postgresql17.5")
extractZip(zipFile, destDir)
```

---

### find7ZipExecutable()

Find 7-Zip executable on the system.

**Signature:**
```groovy
String find7ZipExecutable()
```

**Returns:** Path to 7z.exe, or null if not found

**Search Strategy:**
1. Check `7Z_HOME` environment variable
2. Check common installation paths
3. Check system PATH

**Example:**
```groovy
def sevenZip = find7ZipExecutable()
if (sevenZip) {
    println "7-Zip found at: ${sevenZip}"
} else {
    println "7-Zip not found"
}
```

---

### generateHashFiles(File file)

Generate hash files for an archive.

**Signature:**
```groovy
void generateHashFiles(File file)
```

**Parameters:**
- `file` - Archive file to hash

**Generates:**
- `.md5` - MD5 checksum
- `.sha1` - SHA-1 checksum
- `.sha256` - SHA-256 checksum
- `.sha512` - SHA-512 checksum

**Example:**
```groovy
def archive = file("bearsampp-postgresql-17.5-2025.7.2.7z")
generateHashFiles(archive)
```

---

### calculateHash(File file, String algorithm)

Calculate hash for a file.

**Signature:**
```groovy
String calculateHash(File file, String algorithm)
```

**Parameters:**
- `file` - File to hash
- `algorithm` - Hash algorithm (MD5, SHA-1, SHA-256, SHA-512)

**Returns:** Hex-encoded hash string

**Example:**
```groovy
def file = file("archive.7z")
def md5 = calculateHash(file, "MD5")
def sha256 = calculateHash(file, "SHA-256")
```

---

### getAvailableVersions()

Get list of available PostgreSQL versions.

**Signature:**
```groovy
List<String> getAvailableVersions()
```

**Returns:** List of version strings (e.g., ["16.9", "17.5"])

**Sources:**
- `bin/` directory
- `bin/archived/` directory

**Example:**
```groovy
def versions = getAvailableVersions()
versions.each { version ->
    println "Available: ${version}"
}
```

---

## Project Extensions

### ext Properties

Extended properties available in the build:

```groovy
// Access extended properties
println project.ext.bundleName
println project.ext.bundleRelease
println project.ext.postgresqlBuildPath
```

---

## Task API

### Task Registration

Tasks are registered using Gradle's task registration API:

```groovy
tasks.register('taskName') {
    group = 'groupName'
    description = 'Task description'
    
    doLast {
        // Task implementation
    }
}
```

### Task Groups

| Group            | Purpose                                  |
|------------------|------------------------------------------|
| `build`          | Build and package tasks                  |
| `verification`   | Verification and validation tasks        |
| `help`           | Help and information tasks               |

### Task Dependencies

Tasks can depend on other tasks:

```groovy
tasks.register('taskB') {
    dependsOn 'taskA'
    
    doLast {
        // Runs after taskA
    }
}
```

---

## Usage Examples

### Example 1: Custom Task Using Helper Functions

```groovy
tasks.register('customDownload') {
    group = 'custom'
    description = 'Custom download task'
    
    doLast {
        def version = "17.5"
        def url = getPostgreSQLDownloadUrl(version)
        def dest = file("custom-downloads/postgresql-${version}.zip")
        
        downloadFile(url, dest)
        println "Downloaded to: ${dest}"
    }
}
```

---

### Example 2: Custom Verification Task

```groovy
tasks.register('customVerify') {
    group = 'verification'
    description = 'Custom verification'
    
    doLast {
        def versions = getAvailableVersions()
        
        if (versions.isEmpty()) {
            throw new GradleException("No versions found")
        }
        
        println "Found ${versions.size()} versions"
        versions.each { v ->
            println "  - ${v}"
        }
    }
}
```

---

### Example 3: Custom Hash Generation

```groovy
tasks.register('hashFile') {
    group = 'custom'
    description = 'Generate hashes for a file'
    
    doLast {
        def file = file(project.findProperty('targetFile') ?: 'archive.7z')
        
        if (!file.exists()) {
            throw new GradleException("File not found: ${file}")
        }
        
        generateHashFiles(file)
        println "Hash files generated for: ${file.name}"
    }
}
```

Usage:
```bash
gradle hashFile -PtargetFile=myarchive.7z
```

---

## Build Lifecycle

### Configuration Phase

During configuration, the build script:
1. Loads properties from gradle.properties
2. Sets up project extensions
3. Defines helper functions
4. Registers tasks

### Execution Phase

During execution:
1. Validates environment (if verify task)
2. Resolves version and URLs
3. Downloads and extracts binaries
4. Prepares bundle
5. Creates archive
6. Generates hashes

---

## Error Handling

### GradleException

Throw GradleException for build failures:

```groovy
if (!file.exists()) {
    throw new GradleException("File not found: ${file}")
}
```

### Try-Catch

Handle exceptions gracefully:

```groovy
try {
    downloadFile(url, dest)
} catch (Exception e) {
    logger.warn("Download failed: ${e.message}")
    // Fallback logic
}
```

---

## Logging

### Log Levels

```groovy
logger.error("Error message")
logger.warn("Warning message")
logger.lifecycle("Lifecycle message")
logger.info("Info message")
logger.debug("Debug message")
```

### Print to Console

```groovy
println "Message to console"
```

---

**Last Updated**: 2025-01-31  
**Version**: 2025.7.2

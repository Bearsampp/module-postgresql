# PostgreSQL Module CI/CD Testing

## Overview

This document describes the automated testing workflow for the Bearsampp PostgreSQL module. The CI/CD pipeline ensures that PostgreSQL builds are properly packaged, can be extracted, started, and perform basic database operations.

## Workflow Triggers

The PostgreSQL testing workflow is triggered automatically on:

- **Pull Request Events**: When a PR is opened, synchronized (new commits pushed), reopened, or edited
  - Target branches: `main` or `develop`

## Test Scope

The workflow tests the **latest 5 PostgreSQL versions** from `releases.properties` by default. This ensures recent versions are validated while keeping CI runtime reasonable.

## Test Phases

### Phase 1: Installation Validation

**Purpose**: Verify the PostgreSQL package can be downloaded and extracted correctly.

**Steps**:
1. **Download PostgreSQL** (Phase 1.1)
   - Reads the download URL from `releases.properties`
   - Downloads the `.7z` archive from GitHub releases
   - Reports download size and success status

2. **Extract Archive** (Phase 1.1)
   - Extracts the `.7z` file using 7-Zip
   - Locates the `postgresqlVERSION` subfolder
   - Validates the directory structure

3. **Verify Executables** (Phase 1.2)
   - Checks for required PostgreSQL executables:
     - `postgres.exe` - Main database server
     - `psql.exe` - Command-line client
     - `pg_ctl.exe` - Server control utility
     - `initdb.exe` - Database cluster initialization
     - `createdb.exe` - Database creation utility
     - `dropdb.exe` - Database deletion utility
   - Retrieves and displays PostgreSQL version

### Phase 2: Server Initialization

**Purpose**: Verify PostgreSQL can initialize a database cluster and start successfully.

**Steps**:
1. **Initialize Database Cluster** (Phase 2.1)
   - Creates a new PostgreSQL data directory
   - Initializes the cluster with:
     - User: `postgres`
     - Authentication: `trust` (for testing)
     - Locale: `C`
     - Encoding: `UTF8`
   - Validates initialization success

2. **Start PostgreSQL Server** (Phase 2.2)
   - Starts the PostgreSQL server using `pg_ctl`
   - Waits for server to be ready (5 seconds)
   - Verifies server is running
   - Captures server logs for debugging

### Phase 3: Database Operations

**Purpose**: Verify basic database operations work correctly.

**Steps**:
1. **Test Connection** (Phase 3.1)
   - Connects to the default `postgres` database
   - Executes `SELECT version();` query
   - Validates connection and query execution

2. **Test Database Creation** (Phase 3.2)
   - Creates a test database: `bearsampp_test_db`
   - Verifies database appears in database list
   - Creates a test table with columns:
     - `id` (SERIAL PRIMARY KEY)
     - `name` (VARCHAR(100))
     - `created_at` (TIMESTAMP)
   - Inserts sample data (2 test records)
   - Queries and displays the test data
   - Validates all operations succeed

3. **Test Database Deletion** (Phase 3.3)
   - Drops the test database using `dropdb`
   - Verifies database no longer exists in database list
   - Validates cleanup was successful

### Phase 4: Cleanup

**Purpose**: Properly shut down the PostgreSQL server.

**Steps**:
- Stops the PostgreSQL server using `pg_ctl stop -m fast`
- Waits for graceful shutdown (3 seconds)
- Verifies server has stopped
- Runs even if previous phases failed (using `if: always()`)

## Test Results

### Artifacts

The workflow generates and uploads the following artifacts:

1. **Test Results** (`test-results-postgresql-VERSION`)
   - `verify.json` - Executable verification results
   - `summary.md` - Human-readable test summary
   - Retention: 30 days

2. **Server Logs** (`server-logs-postgresql-VERSION`)
   - `postgresql.log` - Complete server log output
   - Retention: 7 days

### PR Comments

For pull requests, the workflow automatically posts a comment with:
- Test date and time (UTC)
- Summary for each tested version
- Pass/fail status for each phase
- Overall test status
- Links to detailed artifacts

The comment is updated if it already exists (no duplicate comments).

### Test Summary Format

Each version's summary includes:

```
### PostgreSQL X.Y

**Phase 1: Installation Validation**
- Download & Extract: ✅ PASS / ❌ FAIL
- Verify Executables: ✅ PASS / ❌ FAIL

**Phase 2: Server Initialization**
- Initialize Cluster: ✅ PASS / ❌ FAIL
- Start Server: ✅ PASS / ❌ FAIL

**Phase 3: Database Operations**
- Test Connection: ✅ PASS / ❌ FAIL
- Create Database: ✅ PASS / ❌ FAIL
- Delete Database: ✅ PASS / ❌ FAIL

**Overall Status:** ✅ ALL TESTS PASSED / ❌ SOME TESTS FAILED
```

## Error Handling

- Each phase uses `continue-on-error: true` to allow subsequent phases to run
- Failed phases are clearly marked in the summary
- Server logs are always uploaded for debugging
- Cleanup phase always runs to prevent resource leaks

## Platform

- **Runner**: `windows-latest`
- **Reason**: PostgreSQL builds are Windows executables (.exe)
- **Tools**: Native Windows PowerShell, 7-Zip

## Matrix Strategy

- **Parallel Execution**: Tests run in parallel for different versions
- **Fail-Fast**: Disabled (`fail-fast: false`) to test all versions even if one fails
- **Version Selection**: Latest 5 versions from `releases.properties`

## Workflow File Location

`.github/workflows/postgresql-test.yml`

## Maintenance

### Adding New Test Cases

To add new database operation tests:

1. Add a new step after Phase 3.3
2. Use `continue-on-error: true`
3. Check previous phase success with `if: steps.PREVIOUS_STEP.outputs.success == 'true'`
4. Set output variable: `echo "success=true/false" >> $env:GITHUB_OUTPUT`
5. Update the test summary generation to include the new phase

### Modifying Version Selection

To change which versions are tested, edit the `Get PostgreSQL Versions` step:

```bash
# Current: Latest 5 versions
VERSIONS=$(... | .[0:5]')

# Example: Latest 3 versions
VERSIONS=$(... | .[0:3]')

# Example: All versions
VERSIONS=$(... | .')
```

### Adjusting Timeouts

Key timing parameters:

- Server startup wait: `Start-Sleep -Seconds 5` (Phase 2.2)
- Server shutdown wait: `Start-Sleep -Seconds 3` (Phase 4)

Increase these values if tests fail due to slow server startup/shutdown.

## Troubleshooting

### Common Issues

1. **Download Failures**
   - Check if the release URL in `releases.properties` is valid
   - Verify GitHub releases are accessible
   - Check network connectivity

2. **Extraction Failures**
   - Ensure `.7z` file is not corrupted
   - Verify 7-Zip is available on the runner
   - Check archive structure matches expected format

3. **Server Start Failures**
   - Review `postgresql.log` artifact
   - Check for port conflicts (default: 5432)
   - Verify data directory permissions

4. **Connection Failures**
   - Ensure server had enough time to start
   - Check authentication settings (trust mode)
   - Review server logs for errors

### Debugging

To debug a specific version:

1. Check the workflow run in GitHub Actions
2. Expand the failed step to see detailed output
3. Download the test results artifact
4. Review `postgresql.log` for server-side errors
5. Check `verify.json` for executable validation details

## Best Practices

1. **Always test before merging**: The workflow runs on PRs to catch issues early
2. **Review test summaries**: Check PR comments for test results
3. **Investigate failures**: Don't merge if tests fail without understanding why
4. **Keep versions updated**: Regularly update `releases.properties` with new PostgreSQL versions
5. **Monitor artifact storage**: Old artifacts are automatically cleaned up after retention period

## Related Documentation

- [PostgreSQL Official Documentation](https://www.postgresql.org/docs/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Bearsampp Project](https://github.com/Bearsampp)

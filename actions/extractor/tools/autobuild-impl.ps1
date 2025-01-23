if (($null -ne $env:LGTM_INDEX_INCLUDE) -or ($null -ne $env:LGTM_INDEX_EXCLUDE) -or ($null -ne $env:LGTM_INDEX_FILTERS)) {
    Write-Output 'Path filters set. Passing them through to the JavaScript extractor.' 
} else {
    Write-Output 'No path filters set. Using the default filters.'
    # Note: We're adding the `reusable_workflows` subdirectories to proactively
    # record workflows that were called cross-repo, check them out locally,
    # and enable an interprocedural analysis across the workflow files.
    # These workflows follow the convention `.github/reusable_workflows/<nwo>/*.ya?ml`
    $DefaultPathFilters = @(
        'exclude:**/*',
        'include:.github/workflows/*.yml',
        'include:.github/workflows/*.yaml',
        'include:.github/reusable_workflows/**/*.yml',
        'include:.github/reusable_workflows/**/*.yaml',
        'include:**/action.yml',
        'include:**/action.yaml'
    )

    $env:LGTM_INDEX_FILTERS = $DefaultPathFilters -join "`n"
}

# Find the JavaScript extractor directory via `codeql resolve extractor`.
$CodeQL = Join-Path $env:CODEQL_DIST 'codeql.exe'
$env:CODEQL_EXTRACTOR_JAVASCRIPT_ROOT = &$CodeQL resolve extractor --language javascript
if ($LASTEXITCODE -ne 0) {
    throw 'Failed to resolve JavaScript extractor.'
}

Write-Output "Found JavaScript extractor at '${env:CODEQL_EXTRACTOR_JAVASCRIPT_ROOT}'."

# Run the JavaScript autobuilder.
$JavaScriptAutoBuild = Join-Path $env:CODEQL_EXTRACTOR_JAVASCRIPT_ROOT 'tools\autobuild.cmd'
Write-Output "Running JavaScript autobuilder at '${JavaScriptAutoBuild}'."

# Copy the values of the Actions extractor environment variables to the JavaScript extractor environment variables.
$env:CODEQL_EXTRACTOR_JAVASCRIPT_DIAGNOSTIC_DIR = $env:CODEQL_EXTRACTOR_ACTIONS_DIAGNOSTIC_DIR
$env:CODEQL_EXTRACTOR_JAVASCRIPT_LOG_DIR = $env:CODEQL_EXTRACTOR_ACTIONS_LOG_DIR
$env:CODEQL_EXTRACTOR_JAVASCRIPT_SCRATCH_DIR = $env:CODEQL_EXTRACTOR_ACTIONS_SCRATCH_DIR
$env:CODEQL_EXTRACTOR_JAVASCRIPT_SOURCE_ARCHIVE_DIR = $env:CODEQL_EXTRACTOR_ACTIONS_SOURCE_ARCHIVE_DIR
$env:CODEQL_EXTRACTOR_JAVASCRIPT_TRAP_DIR = $env:CODEQL_EXTRACTOR_ACTIONS_TRAP_DIR
$env:CODEQL_EXTRACTOR_JAVASCRIPT_WIP_DATABASE = $env:CODEQL_EXTRACTOR_ACTIONS_WIP_DATABASE

&$JavaScriptAutoBuild
if ($LASTEXITCODE -ne 0) {
    throw "JavaScript autobuilder failed."
}

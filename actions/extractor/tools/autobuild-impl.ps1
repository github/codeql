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

if ($null -ne $env:LGTM_INDEX_FILTERS) {
    Write-Output 'LGTM_INDEX_FILTERS set. Using the default filters together with the user-provided filters, and passing through to the JavaScript extractor.'
    # Begin with the default path inclusions only,
    # followed by the user-provided filters.
    # If the user provided `paths`, those patterns override the default inclusions
    # (because `LGTM_INDEX_FILTERS` will begin with `exclude:**/*`).
    # If the user provided `paths-ignore`, those patterns are excluded.
    $PathFilters = ($DefaultPathFilters -join "`n") + "`n" + $env:LGTM_INDEX_FILTERS
    $env:LGTM_INDEX_FILTERS = $PathFilters
} else {
    Write-Output 'LGTM_INDEX_FILTERS not set. Using the default filters, and passing through to the JavaScript extractor.'
    $env:LGTM_INDEX_FILTERS = $DefaultPathFilters -join "`n"
}

# Find the JavaScript extractor directory via `codeql resolve extractor`.
$CodeQL = Join-Path $env:CODEQL_DIST 'codeql.exe'
$env:CODEQL_EXTRACTOR_JAVASCRIPT_ROOT = &"$CodeQL" resolve extractor --language javascript
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

&"$JavaScriptAutoBuild"
if ($LASTEXITCODE -ne 0) {
    throw "JavaScript autobuilder failed."
}

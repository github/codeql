$zip = [System.IO.Compression.ZipFile]::OpenRead("MyPath\to\archive.zip")

foreach ($entry in $zip.Entries) {
    $targetPath = Join-Path $extractPath $entry.FullName
    $fullTargetPath = [System.IO.Path]::GetFullPath($targetPath)

    # GOOD: Validate that the full path is within the intended extraction directory
    $extractRoot = [System.IO.Path]::GetFullPath($extractPath)
    if ($fullTargetPath.StartsWith($extractRoot)) {
        [System.IO.Compression.ZipFileExtensions]::ExtractToFile($entry, $fullTargetPath, $true)
    } else {
        Write-Warning "Skipping potentially malicious entry: $($entry.FullName)"
    }
}
$zip.Dispose()
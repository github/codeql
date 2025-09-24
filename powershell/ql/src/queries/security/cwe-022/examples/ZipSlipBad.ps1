$zip = [System.IO.Compression.ZipFile]::OpenRead("MyPath\to\archive.zip")

foreach ($entry in $zip.Entries) {
    $targetPath = Join-Path $extractPath $entry.FullName

    # BAD: No validation of $targetPath
    [System.IO.Compression.ZipFileExtensions]::ExtractToFile($entry, $targetPath)
}
$zip.Dispose()
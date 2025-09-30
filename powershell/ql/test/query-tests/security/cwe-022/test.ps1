Add-Type -AssemblyName System.IO.Compression.FileSystem

$zip = [System.IO.Compression.ZipFile]::OpenRead("MyPath\to\archive.zip")

foreach ($entry in $zip.Entries) {
    $targetPath = Join-Path $extractPath $entry.FullName
    $fullTargetPath = [System.IO.Path]::GetFullPath($targetPath)

    [System.IO.Compression.ZipFileExtensions]::ExtractToFile($entry, $fullTargetPath) # BAD
}

foreach ($entry in $zip.Entries) {
    $targetPath = Join-Path $extractPath $entry.FullName
    $fullTargetPath = [System.IO.Path]::GetFullPath($targetPath)

    $stream = [System.IO.File]::Open($fullTargetPath, 'Create') # BAD
    $entry.Open().CopyTo($stream)
    $stream.Close()
}

foreach ($entry in $zip.Entries) {
    $targetPath = Join-Path $extractPath $entry.FullName
    $fullTargetPath = [System.IO.Path]::GetFullPath($targetPath)

    $extractRoot = [System.IO.Path]::GetFullPath($extractPath)
    if ($fullTargetPath.StartsWith($extractRoot)) {
        [System.IO.Compression.ZipFileExtensions]::ExtractToFile($entry, $fullTargetPath) # GOOD [FALSE POSITIVE]
    }
}
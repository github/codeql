$filePath = "C:\Temp\example.txt"
$fileStream = [System.IO.File]::Open($filePath, [System.IO.FileMode]::OpenOrCreate, [System.IO.FileAccess]::ReadWrite) # $ type="file stream"
$fileStream2 = [System.IO.File]::OpenRead($filePath) # $ type="file stream"

$reader = [System.IO.File]::OpenText($filePath) # $ type="file stream"
$bytes = [System.IO.File]::ReadAllBytes($filePath) # $ type="file stream"
$lines = [System.IO.File]::ReadAllLines($filePath) # $ type="file stream"
$bytesTask = [System.IO.File]::ReadAllBytesAsync($filePath) # $ type="file stream"
$linesTask = [System.IO.File]::ReadAllLinesAsync($filePath) # $ type="file stream"
$stream = [System.IO.File]::ReadAllText($filePath) # $ type="file stream"
$streamTask = [System.IO.File]::ReadAllTextAsync($filePath) # $ type="file stream"
$lines2 = [System.IO.File]::ReadLines($filePath) # $ type="file stream"
$lines3 = [System.IO.File]::ReadLinesAsync($filePath) # $ type="file stream"


$fileInfo = [System.IO.FileInfo]::new("C:\Temp\example.txt")

# Open the file for reading and writing
$fileStream3 = $fileInfo.Open([System.IO.FileMode]::OpenOrCreate, [System.IO.FileAccess]::ReadWrite) # $ type="file stream"
$fileStream4 = $fileInfo.OpenRead() # $ type="file stream"
$reader2 = $fileInfo.OpenText() # $ type="file stream"

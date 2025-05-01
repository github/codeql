param (
    [Parameter(Mandatory=$true)][string]$cliFolder
)

$toolsWin64Folder = Join-Path (Join-Path (Join-Path $cliFolder "powershell") "tools") "win64"
dotnet publish (Join-Path "extractor" "powershell.sln" | Resolve-Path) -o $toolsWin64Folder
if ($LASTEXITCODE -ne 0) {
    Write-Host "Build failed"
    exit 1
}

$powershellFolder = Join-Path -Path $cliFolder -ChildPath "powershell"
Copy-Item -Path codeql-extractor.yml -Destination $powershellFolder -Force
$qlLibFolder = Join-Path -Path "ql" -ChildPath "lib"
Copy-Item -Path (Join-Path $qlLibFolder "semmlecode.powershell.dbscheme") -Destination $powershellFolder -Force
Copy-Item -Path (Join-Path $qlLibFolder "semmlecode.powershell.dbscheme.stats") -Destination $powershellFolder -Force
Copy-Item -Path "tools" -Destination $powershellFolder -Recurse -Force
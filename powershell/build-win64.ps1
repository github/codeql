param (
    [Parameter(Mandatory=$true)][string]$cliFolder
)

$toolsWin64Folder = Join-Path (Join-Path (Join-Path $cliFolder "powershell") "tools") "win64"
dotnet publish (Join-Path "$PSScriptRoot/extractor" "powershell.sln" | Resolve-Path) -o $toolsWin64Folder
if ($LASTEXITCODE -ne 0) {
    Write-Host "Build failed"
    exit 1
}

$powershellFolder = Join-Path -Path $cliFolder -ChildPath "powershell"
Copy-Item -Path "$PSScriptRoot/codeql-extractor.yml" -Destination $powershellFolder -Force
Copy-Item -Path "$PSScriptRoot/downgrades" -Destination $powershellFolder -Recurse -Force
$qlLibFolder = Join-Path -Path "$PSScriptRoot/ql" -ChildPath "lib"
Copy-Item -Path (Join-Path $qlLibFolder "semmlecode.powershell.dbscheme") -Destination $powershellFolder -Force
Copy-Item -Path (Join-Path $qlLibFolder "semmlecode.powershell.dbscheme.stats") -Destination $powershellFolder -Force
Copy-Item -Path "$PSScriptRoot/tools" -Destination $powershellFolder -Recurse -Force

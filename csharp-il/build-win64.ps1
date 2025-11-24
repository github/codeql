param (
  [Parameter(Mandatory=$true)]
  [string]$cliFolder
)

$toolsWin64Folder = Join-Path (Join-Path (Join-Path $cliFolder "cil") "tools") "win64"
dotnet build extractor/Semmle.Extraction.CSharp.IL -o $toolsWin64Folder -c Release --self-contained
if ($LASTEXITCODE -ne 0) {
    Write-Host "Build failed"
    exit 1
}

New-Item -ItemType Directory -Force -Path $toolsWin64Folder
$cilFolder = Join-Path -Path $cliFolder -ChildPath "cil"
New-Item -ItemType Directory -Force -Path $cilFolder
Copy-Item -Path "$PSScriptRoot/codeql-extractor.yml" -Destination $cilFolder -Force
Copy-Item -Path "$PSScriptRoot/downgrades" -Destination $cilFolder -Recurse -Force
$qlLibFolder = Join-Path -Path "$PSScriptRoot/ql" -ChildPath "lib"
Copy-Item -Path (Join-Path $qlLibFolder "semmlecode.cil.dbscheme") -Destination $cilFolder -Force
Copy-Item -Path (Join-Path $qlLibFolder "semmlecode.cil.dbscheme.stats") -Destination $cilFolder -Force
Copy-Item -Path "$PSScriptRoot/tools" -Destination $cilFolder -Recurse -Force
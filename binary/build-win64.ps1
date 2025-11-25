param (
  [Parameter(ParameterSetName = 'x86')]
  [Parameter(ParameterSetName = 'x86Clean')]
  [Parameter(ParameterSetName = 'x86Init')]
  [switch]$x86,

  [Parameter(ParameterSetName = 'cil')]
  [Parameter(ParameterSetName = 'cilClean')]
  [Parameter(ParameterSetName = 'cilInit')]
  [switch]$cil,

  [Parameter(Mandatory=$true, ParameterSetName = 'x86Init')]
  [Parameter(Mandatory=$true, ParameterSetName = 'cilInit')]
  [switch]$init,

  [Parameter(Mandatory=$true, ParameterSetName = 'x86')]
  [Parameter(Mandatory=$true, ParameterSetName = 'cil')]
  [Parameter(Mandatory=$true, ParameterSetName = 'x86Init')]
  [Parameter(Mandatory=$true, ParameterSetName = 'cilInit')]
  [string]$cliFolder,

  [Parameter(Mandatory = $true, ParameterSetName = 'x86Clean')]
  [Parameter(Mandatory = $true, ParameterSetName = 'cilClean')]
  [switch]$clean
)

function x86 {
  function init-lief {
    git clone https://github.com/lief-project/LIEF.git
    cd LIEF
    cmake -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DCMAKE_MSVC_RUNTIME_LIBRARY="MultiThreaded" .
    nmake
    nmake install
    cd ..
  }

  function init-zydis {
    git clone https://github.com/zyantific/zydis.git --recursive
    cd zydis
    cmake -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DCMAKE_MSVC_RUNTIME_LIBRARY="MultiThreaded" .
    nmake
    nmake install
    cd ..
  }

  function init-fmt {
    git clone https://github.com/fmtlib/fmt.git
  }

  function init-boost-library($name) {
    git clone https://github.com/boostorg/$name.git
    xcopy /E /I /Y $name\include\boost boost-minimal\boost
    Remove-Item -Path $name -Recurse -Force
  }

  function init-boost {
    if (-not (Test-Path boost-minimal)) {
      mkdir boost-minimal
    }
    init-boost-library algorithm
    init-boost-library mpl
    init-boost-library range
    init-boost-library preprocessor
    init-boost-library type_traits
    init-boost-library iterator
    init-boost-library assert
    init-boost-library mp11
    init-boost-library static_assert
    init-boost-library core
    init-boost-library concept_check
    init-boost-library utility
    init-boost-library function
    init-boost-library bind
    init-boost-library throw_exception
    init-boost-library optional
    init-boost-library config
  }

  function init-args {
    git clone https://github.com/Taywee/args.git
  }

  if($init) {
    Push-Location extractor/x86
      init-lief
      init-zydis
      init-fmt
      init-boost
      init-args
    Pop-Location
  }

  if($clean) {
    Push-Location extractor/x86
    if(Test-Path args) { Remove-Item -Path args -Recurse -Force }
    if(Test-Path boost-minimal) { Remove-Item -Path boost-minimal -Recurse -Force }
    if(Test-Path fmt) { Remove-Item -Path fmt -Recurse -Force }
    if(Test-Path LIEF) { Remove-Item -Path LIEF -Recurse -Force }
    if(Test-Path zydis) { Remove-Item -Path zydis -Recurse -Force }
    Pop-Location
  } else {
    Push-Location extractor/x86

    cl.exe /DFMT_HEADER_ONLY /DZYDIS_STATIC_BUILD /I zydis\include /I zydis\dependencies\zycore\include /I LIEF/include /I fmt/include /I boost-minimal /I args /utf-8 src/main.cpp zydis\Zydis.lib zydis/zycore/zycore.lib LIEF/LIEF.lib /EHsc /std:c++17 /link /out:extractor.exe

    if ($LASTEXITCODE -ne 0) {
        Write-Host "Build failed"
        Pop-Location
        exit 1
    }

    Pop-Location

    $toolsWin64Folder = Join-Path (Join-Path (Join-Path $cliFolder "binary") "tools") "win64"
    New-Item -ItemType Directory -Force -Path $toolsWin64Folder
    $binaryFolder = Join-Path -Path $cliFolder -ChildPath "binary"
    New-Item -ItemType Directory -Force -Path $binaryFolder
    Copy-Item -Path "$PSScriptRoot/extractor/x86/codeql-extractor.yml" -Destination $binaryFolder -Force
    Copy-Item -Path "$PSScriptRoot/downgrades" -Destination $binaryFolder -Recurse -Force
    $qlLibFolder = Join-Path -Path "$PSScriptRoot/ql" -ChildPath "lib"
    Copy-Item -Path (Join-Path $qlLibFolder "semmlecode.binary.dbscheme") -Destination $binaryFolder -Force
    Copy-Item -Path (Join-Path $qlLibFolder "semmlecode.binary.dbscheme.stats") -Destination $binaryFolder -Force
    Copy-Item -Path "$PSScriptRoot/tools/x86/*" -Destination (Join-Path $binaryFolder "tools") -Recurse -Force
    Copy-Item -Path "$PSScriptRoot/extractor/x86/extractor.exe" -Destination $toolsWin64Folder/extractor.exe
  }
}

function cil {
  Push-Location extractor/cil
  $toolsWin64Folder = Join-Path (Join-Path (Join-Path $cliFolder "cil") "tools") "win64"
  dotnet build Semmle.Extraction.CSharp.IL -o $toolsWin64Folder -c Release --self-contained
  if ($LASTEXITCODE -ne 0) {
      Write-Host "Build failed"
      Pop-Location
      exit 1
  }

  Pop-Location

  New-Item -ItemType Directory -Force -Path $toolsWin64Folder
  $cilFolder = Join-Path -Path $cliFolder -ChildPath "cil"
  New-Item -ItemType Directory -Force -Path $cilFolder
  Copy-Item -Path "$PSScriptRoot/extractor/cil/codeql-extractor.yml" -Destination $cilFolder -Force
  Copy-Item -Path "$PSScriptRoot/downgrades" -Destination $cilFolder -Recurse -Force
  $qlLibFolder = Join-Path -Path "$PSScriptRoot/ql" -ChildPath "lib"
  Copy-Item -Path (Join-Path $qlLibFolder "semmlecode.binary.dbscheme") -Destination $cilFolder -Force
  Copy-Item -Path (Join-Path $qlLibFolder "semmlecode.binary.dbscheme.stats") -Destination $cilFolder -Force
  Copy-Item -Path "$PSScriptRoot/tools/cil/*" -Destination (Join-Path $cilFolder "tools") -Recurse -Force
}

if($x86) {
  x86
}

if($cil) {
  cil
}
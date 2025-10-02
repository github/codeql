param (
  [Parameter(ParameterSetName = 'InitSet')]
  [switch]$initlief,

  [Parameter(ParameterSetName = 'InitSet')]
  [switch]$initzydis,
  
  [Parameter(ParameterSetName = 'InitSet')]
  [switch]$initfmt,

  [Parameter(ParameterSetName = 'InitSet')]
  [switch]$initboost,

  [Parameter(ParameterSetName = 'InitSet')]
  [switch]$initargs,

  [Parameter(ParameterSetName = 'InitSet')]
  [switch]$init,

  [Parameter(Mandatory=$true, ParameterSetName = 'InitSet')]
  [string]$cliFolder,

  [Parameter(ParameterSetName = 'CleanSet', Mandatory = $true)]
  [switch]$clean
)

function init-lief {
  git clone https://github.com/lief-project/LIEF.git
  cd LIEF
  cmake -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DCMAKE_MSVC_RUNTIME_LIBRARY="MultiThreaded" .
  nmake
  nmake install
  cd ..
}

function init-zydis {
  git clone https://github.com/zyantific/zydis.git
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

if($initlief) {
  cd extractor
  init-lief
  cd ..
}

if($initzydis) {
  cd extractor
  init-zydis
  cd ..
}

if($initfmt) {
  cd extractor
  init-fmt
  cd ..
}

if($initboost) {
  cd extractor
  init-boost
  cd ..
}

if($initargs) {
  cd extractor
  init-args
  cd ..
}

if($init) {
  cd extractor
    init-lief
    init-zydis
    init-fmt
    init-boost
    init-args
  cd ..
}

if($clean) {
  cd extractor
  if(Test-Path args) { Remove-Item -Path args -Recurse -Force }
  if(Test-Path boost-minimal) { Remove-Item -Path boost-minimal -Recurse -Force }
  if(Test-Path fmt) { Remove-Item -Path fmt -Recurse -Force }
  if(Test-Path LIEF) { Remove-Item -Path LIEF -Recurse -Force }
  if(Test-Path zydis) { Remove-Item -Path zydis -Recurse -Force }
  cd ..
} else {
  cd extractor

  cl.exe /DFMT_HEADER_ONLY /DZYDIS_STATIC_BUILD /I zydis\include /I zydis\dependencies\zycore\include /I LIEF/include /I fmt/include /I boost-minimal /I args /utf-8 src/main.cpp zydis\Zydis.lib zydis/zycore/zycore.lib LIEF/LIEF.lib /EHsc /std:c++17 /link /out:extractor.exe

  if ($LASTEXITCODE -ne 0) {
      Write-Host "Build failed"
      exit 1
  }

  cd ..

  $toolsWin64Folder = Join-Path (Join-Path (Join-Path $cliFolder "binary") "tools") "win64"
  New-Item -ItemType Directory -Force -Path $toolsWin64Folder
  $binaryFolder = Join-Path -Path $cliFolder -ChildPath "binary"
  New-Item -ItemType Directory -Force -Path $binaryFolder
  Copy-Item -Path "$PSScriptRoot/codeql-extractor.yml" -Destination $binaryFolder -Force
  Copy-Item -Path "$PSScriptRoot/downgrades" -Destination $binaryFolder -Recurse -Force
  $qlLibFolder = Join-Path -Path "$PSScriptRoot/ql" -ChildPath "lib"
  Copy-Item -Path (Join-Path $qlLibFolder "semmlecode.binary.dbscheme") -Destination $binaryFolder -Force
  Copy-Item -Path (Join-Path $qlLibFolder "semmlecode.binary.dbscheme.stats") -Destination $binaryFolder -Force
  Copy-Item -Path "$PSScriptRoot/tools" -Destination $binaryFolder -Recurse -Force
  Copy-Item -Path "$PSScriptRoot/extractor/extractor.exe" -Destination $toolsWin64Folder/extractor.exe
}
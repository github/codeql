# This script can be used to build a summary of the set of queries which are
# in each of the standard CodeQL query suites `code-scanning`, `security-and-quality`,
# and `security-extended`.
#
# This script assumes:
# * You clone this repository, as well as 
# https://github.com/github/codeql-go into the same directory 
# (for example `/github/codeql` and `/github/codeql-go`)
# * You have the CodeQL CLI installed into your PATH
# 
# Usage: ./resolve-queries.ps1 | Out-File query-lists.csv    


$langs = @('cpp', 'java', 'javascript', 'csharp', 'python', 'go')
$suites = @('code-scanning', 'security-and-quality', 'security-extended')

foreach ($suite in $suites) {
  foreach ($lang in $langs) { 
    
    $searchPath = ".:../codeql-go"

    $temp = codeql resolve queries $lang-$suite.qls --search-path $searchPath
    
    Write-Output "filename, suite, query name, id, kind, severity, precision
    
    foreach ($file in $temp) {
      $metadata = ConvertFrom-Json (codeql resolve metadata $file | out-string)

      $currentDirectory = (Get-Location).Path
      $file = $file.Replace($currentDirectory, "github/codeql");
      $line = "$file, $suite, $($metadata.name), $($metadata.id), $($metadata.kind), $($metadata.problem.severity), $($metadata.precision)"
      Write-Output $line 
    }
  }  
}


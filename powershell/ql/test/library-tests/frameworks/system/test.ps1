$char = [System.Console]::Read() # $ type="read from stdin"
$keyInfo = [System.Console]::ReadKey($true) # $ type="read from stdin"
$userName = [System.Console]::ReadLine() # $ type="read from stdin"
# $input = [System.Console]::ReadToEnd() # TODO we need to model this one

$path = "%USERPROFILE%\Documents"
$expandedPath = [System.Environment]::ExpandEnvironmentVariables($path) # $ type="environment variable"

$args = [System.Environment]::GetCommandLineArgs() # $ type="command line argument"
$variableValue = [System.Environment]::GetEnvironmentVariable("PATH") # $ type="environment variable"
$envVariables = [System.Environment]::GetEnvironmentVariables() # $ type="environment variable"

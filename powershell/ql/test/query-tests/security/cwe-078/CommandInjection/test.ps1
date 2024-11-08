param ($x)

Invoke-Expression -Command "Get-Process -Id $x" # BAD

$code = "$Env:MY_VAR"

& "$code --enabled" # BAD
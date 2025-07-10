Invoke-WebRequest -Uri "https://example.com/script.ps1" -OutFile "C:\Path\To\script.ps1"

# BAD: No warnings or prompts when running potentially unsafe scripts
Set-ExecutionPolicy Bypass
& "C:\Path\To\script.ps1" # Will never be blocked

# GOOD: Requires that scripts and configuration files downloaded from the Internet are signed
Set-ExecutionPolicy RemoteSigned
& "C:\Path\To\script.ps1" # Will not run unless script.ps1 is signed
# BAD: Using MD5 - cryptographically broken
$md5 = [System.Security.Cryptography.MD5]::Create()
$md5Hash = $md5.ComputeHash([System.Text.Encoding]::UTF8.GetBytes("password123"))

# BAD: Using MD5CryptoServiceProvider
$md5Provider = New-Object System.Security.Cryptography.MD5CryptoServiceProvider
$md5ProviderHash = $md5Provider.ComputeHash([System.Text.Encoding]::UTF8.GetBytes("secret"))

# BAD: Using SHA1 - cryptographically weak
$sha1 = [System.Security.Cryptography.SHA1]::Create()
$sha1Hash = $sha1.ComputeHash([System.Text.Encoding]::UTF8.GetBytes("password123"))

# BAD: Using SHA1CryptoServiceProvider
$sha1Provider = New-Object System.Security.Cryptography.SHA1CryptoServiceProvider
$sha1ProviderHash = $sha1Provider.ComputeHash([System.Text.Encoding]::UTF8.GetBytes("secret"))

# BAD: Creating weak hash algorithms from name
$o = [System.Security.Cryptography.CryptoConfig]::CreateFromName("MD5")
$o = [System.Security.Cryptography.CryptoConfig]::CreateFromName("System.Security.Cryptography.MD5")
$o = [System.Security.Cryptography.CryptoConfig]::CreateFromName("SHA1")
$o = [System.Security.Cryptography.CryptoConfig]::CreateFromName("System.Security.Cryptography.SHA1")


# BAD: Using Get-FileHash with MD5
Get-FileHash -Path "C:\file.txt" -Algorithm MD5

# BAD: Using Get-FileHash with SHA1
Get-FileHash -Path "C:\file.txt" -Algorithm SHA1

# ---------------------------------------------------------
# GOOD: Safe usage of cryptographically secure algorithms
# ---------------------------------------------------------

# GOOD: Using SHA256
$sha256 = [System.Security.Cryptography.SHA256]::Create()
$sha256Hash = $sha256.ComputeHash([System.Text.Encoding]::UTF8.GetBytes("password123"))

# GOOD: Using SHA256CryptoServiceProvider
$sha256Provider = New-Object System.Security.Cryptography.SHA256CryptoServiceProvider
$sha256ProviderHash = $sha256Provider.ComputeHash([System.Text.Encoding]::UTF8.GetBytes("secret"))

# GOOD: Using SHA256Managed
$sha256Managed = New-Object System.Security.Cryptography.SHA256Managed
$sha256ManagedHash = $sha256Managed.ComputeHash([System.Text.Encoding]::UTF8.GetBytes("data"))

# GOOD: Using SHA384
$sha384 = [System.Security.Cryptography.SHA384]::Create()
$sha384Hash = $sha384.ComputeHash([System.Text.Encoding]::UTF8.GetBytes("password123"))

# GOOD: Using SHA512
$sha512 = [System.Security.Cryptography.SHA512]::Create()
$sha512Hash = $sha512.ComputeHash([System.Text.Encoding]::UTF8.GetBytes("password123"))

# GOOD: Using Get-FileHash with SHA256
Get-FileHash -Path "C:\file.txt" -Algorithm SHA256

# GOOD: Using Get-FileHash with SHA384
Get-FileHash -Path "C:\file.txt" -Algorithm SHA384

# GOOD: Using Get-FileHash with SHA512
Get-FileHash -Path "C:\file.txt" -Algorithm SHA512

# GOOD: Using Get-FileHash without specifying algorithm (defaults to SHA256)
Get-FileHash -Path "C:\file.txt"

# BAD: Default iteration count (1000) and default hash algorithm (SHA1)
$kdf = [System.Security.Cryptography.Rfc2898DeriveBytes]::new($password, $salt)

# BAD: Low iteration count
$kdf = [System.Security.Cryptography.Rfc2898DeriveBytes]::new($password, $salt, 1000)

# BAD: Weak hash algorithm
$kdf = [System.Security.Cryptography.Rfc2898DeriveBytes]::new($password, $salt, 100000, [System.Security.Cryptography.HashAlgorithmName]::SHA1)

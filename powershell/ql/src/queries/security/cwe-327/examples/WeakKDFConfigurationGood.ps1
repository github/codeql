# GOOD: 100,000+ iterations with SHA-256
$kdf = [System.Security.Cryptography.Rfc2898DeriveBytes]::new($password, $salt, 600000, [System.Security.Cryptography.HashAlgorithmName]::SHA256)

# GOOD: Static Pbkdf2 with strong configuration
$key = [System.Security.Cryptography.Rfc2898DeriveBytes]::Pbkdf2($password, $salt, 600000, "SHA256", 32)

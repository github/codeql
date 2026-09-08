# ===================================================================
# ========== TRUE POSITIVES (should trigger alert) ==================
# ===================================================================

# --- Case 1: Default iteration count AND default algorithm ---
# BAD: Only password and salt, defaults to 1000 iterations and SHA1
$kdf = [System.Security.Cryptography.Rfc2898DeriveBytes]::new($password, $salt) # $ Alert $ Alert

# --- Case 2: Low iteration count AND default algorithm ---
# BAD: 1000 iterations is too low, and no algorithm specified
$kdf = [System.Security.Cryptography.Rfc2898DeriveBytes]::new($password, $salt, 1000) # $ Alert $ Alert

# BAD: 10000 iterations is still below 100k, and no algorithm specified
$kdf = [System.Security.Cryptography.Rfc2898DeriveBytes]::new($password, $salt, 10000) # $ Alert $ Alert

# BAD: 50000 iterations is still below 100k, and no algorithm specified
$kdf = [System.Security.Cryptography.Rfc2898DeriveBytes]::new($password, $salt, 50000) # $ Alert $ Alert

# --- Case 3: Default hash algorithm only (iterations are adequate) ---
# BAD: Has iterations but no algorithm, defaults to SHA1
$kdf = [System.Security.Cryptography.Rfc2898DeriveBytes]::new($password, $salt, 100000) # $ Alert

# --- Case 4: Weak hash algorithm explicitly specified ---
# BAD: SHA1 explicitly used
$kdf = [System.Security.Cryptography.Rfc2898DeriveBytes]::new($password, $salt, 100000, [System.Security.Cryptography.HashAlgorithmName]::SHA1) # $ Alert

# BAD: MD5 explicitly used
$kdf = [System.Security.Cryptography.Rfc2898DeriveBytes]::new($password, $salt, 100000, [System.Security.Cryptography.HashAlgorithmName]::MD5) # $ Alert

# --- Case 5: New-Object pattern (defaults to both issues) ---
# BAD: New-Object with low iteration count and default algorithm
$kdf = New-Object System.Security.Cryptography.Rfc2898DeriveBytes($password, $salt, 5000) # $ Alert $ Alert

# --- Case 6: New-Object pattern with no extra args ---
# BAD: New-Object with default iterations and algorithm
$kdf = New-Object System.Security.Cryptography.Rfc2898DeriveBytes($password, $salt) # $ Alert $ Alert

# BAD: Canonical New-Object forms with low iterations and weak algorithms
$kdf = New-Object System.Security.Cryptography.Rfc2898DeriveBytes -ArgumentList (
    $password, $salt, 5000, [System.Security.Cryptography.HashAlgorithmName]::SHA1
) # $ Alert $ Alert
$kdf = New-Object -TypeName System.Security.Cryptography.Rfc2898DeriveBytes -ArgumentList (
    $password, $salt, 5000, [System.Security.Cryptography.HashAlgorithmName]::SHA1
) # $ Alert $ Alert

# --- Case 7: Pbkdf2 static method with low iterations ---
# BAD: Static Pbkdf2 method with 1000 iterations
$key = [System.Security.Cryptography.Rfc2898DeriveBytes]::Pbkdf2($password, $salt, 1000, "SHA256", 32) # $ Alert

# --- Case 8: Pbkdf2 static method with weak hash ---
# BAD: Static Pbkdf2 method with SHA1
$key = [System.Security.Cryptography.Rfc2898DeriveBytes]::Pbkdf2($password, $salt, 100000, "SHA1", 32) # $ Alert

# --- Case 9: Combined issues - low iterations AND no algorithm ---
$kdf = [System.Security.Cryptography.Rfc2898DeriveBytes]::new($password, $salt, 500) # $ Alert $ Alert

# --- Case 10: Combined issues - low iterations AND weak algorithm ---
$kdf = [System.Security.Cryptography.Rfc2898DeriveBytes]::new($password, $salt, 500, [System.Security.Cryptography.HashAlgorithmName]::SHA1) # $ Alert $ Alert

# ===================================================================
# ========== TRUE NEGATIVES (should NOT trigger alert) ==============
# ===================================================================

# --- Safe: Proper iterations and strong hash ---
# GOOD: 100000 iterations with SHA256
$kdf = [System.Security.Cryptography.Rfc2898DeriveBytes]::new($password, $salt, 100000, [System.Security.Cryptography.HashAlgorithmName]::SHA256)

# GOOD: 200000 iterations with SHA512
$kdf = [System.Security.Cryptography.Rfc2898DeriveBytes]::new($password, $salt, 200000, [System.Security.Cryptography.HashAlgorithmName]::SHA512)

# GOOD: 600000 iterations with SHA256
$kdf = [System.Security.Cryptography.Rfc2898DeriveBytes]::new($password, $salt, 600000, [System.Security.Cryptography.HashAlgorithmName]::SHA256)

# GOOD: Multiline New-Object calls from Encrypt-SycamoreBundle.ps1 and Decrypt-SycamoreBundle.ps1
$encryptPbkdf2 = New-Object System.Security.Cryptography.Rfc2898DeriveBytes(
    $passwordBytes, $salt, 100000, [System.Security.Cryptography.HashAlgorithmName]::SHA256
)
$decryptPbkdf2 = New-Object System.Security.Cryptography.Rfc2898DeriveBytes(
    $passwordBytes, $salt, 100000, [System.Security.Cryptography.HashAlgorithmName]::SHA256
)

# GOOD: Canonical New-Object argument list forms
$kdf = New-Object System.Security.Cryptography.Rfc2898DeriveBytes -ArgumentList (
    $passwordBytes, $salt, 100000, [System.Security.Cryptography.HashAlgorithmName]::SHA256
)
$kdf = New-Object -TypeName System.Security.Cryptography.Rfc2898DeriveBytes -ArgumentList (
    $passwordBytes, $salt, 100000, [System.Security.Cryptography.HashAlgorithmName]::SHA256
)

# GOOD: An opaque argument list is not assumed to use default settings
$constructorArguments = @($passwordBytes, $salt, 100000, [System.Security.Cryptography.HashAlgorithmName]::SHA256)
$kdf = New-Object -TypeName System.Security.Cryptography.Rfc2898DeriveBytes -ArgumentList $constructorArguments

# --- Safe: Pbkdf2 with proper config ---
# GOOD: Static Pbkdf2 with adequate iterations and strong hash
$key = [System.Security.Cryptography.Rfc2898DeriveBytes]::Pbkdf2($password, $salt, 100000, "SHA256", 32)

# GOOD: Static Pbkdf2 with high iterations
$key = [System.Security.Cryptography.Rfc2898DeriveBytes]::Pbkdf2($password, $salt, 600000, "SHA512", 32)

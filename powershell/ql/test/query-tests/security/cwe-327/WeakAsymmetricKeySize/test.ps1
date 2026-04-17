# ===================================================================
# ========== TRUE POSITIVES (should trigger alert) ==================
# ===================================================================

# --- Case 1: RSA.Create with 1024-bit key ---
$rsa = [System.Security.Cryptography.RSA]::Create(1024) # $ Alert

# --- Case 2: RSA.Create with 512-bit key ---
$rsa = [System.Security.Cryptography.RSA]::Create(512) # $ Alert

# --- Case 3: RSACryptoServiceProvider with 1024-bit key via ::new() ---
$rsa = [System.Security.Cryptography.RSACryptoServiceProvider]::new(1024) # $ Alert

# ===================================================================
# ========== TRUE NEGATIVES (should NOT trigger alert) ==============
# ===================================================================

# --- Safe: RSA.Create with 2048-bit key ---
$rsa = [System.Security.Cryptography.RSA]::Create(2048) # GOOD

# --- Safe: RSA.Create with 4096-bit key ---
$rsa = [System.Security.Cryptography.RSA]::Create(4096) # GOOD

# --- Safe: RSA.Create with no argument (default key size) ---
$rsa = [System.Security.Cryptography.RSA]::Create() # GOOD

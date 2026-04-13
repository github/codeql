# ===================================================================
# ========== TRUE POSITIVES (should trigger alert) ==================
# ===================================================================

# --- Case 1: HMACMD5 via New-Object ---
$hmac = New-Object System.Security.Cryptography.HMACMD5 # BAD

# --- Case 2: HMACSHA1 via New-Object ---
$hmac = New-Object System.Security.Cryptography.HMACSHA1 # BAD

# --- Case 3: HMACMD5 via static Create ---
$hmac = [System.Security.Cryptography.HMACMD5]::Create() # BAD

# --- Case 4: HMACSHA1 via ::new() ---
$hmac = [System.Security.Cryptography.HMACSHA1]::new() # BAD

# ===================================================================
# ========== TRUE NEGATIVES (should NOT trigger alert) ==============
# ===================================================================

# --- Safe: HMACSHA256 ---
$hmac = New-Object System.Security.Cryptography.HMACSHA256 # GOOD

# --- Safe: HMACSHA384 ---
$hmac = [System.Security.Cryptography.HMACSHA384]::new() # GOOD

# --- Safe: HMACSHA512 ---
$hmac = [System.Security.Cryptography.HMACSHA512]::Create() # GOOD

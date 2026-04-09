# ===================================================================
# ========== TRUE POSITIVES (should trigger alert) ==================
# ===================================================================

# --- Case 1: PSJwt module with "none" algorithm ---
$token = New-Jwt -Algorithm "none" -Payload @{sub="user"} # BAD

# ===================================================================
# ========== TRUE NEGATIVES (should NOT trigger alert) ==============
# ===================================================================

# --- Safe: JWT with HS256 ---
$token = New-Jwt -Algorithm "HS256" -Payload @{sub="user"} -Secret $key # GOOD

# --- Safe: Unrelated string "none" ---
$value = "none" # GOOD

# ===================================================================
# ========== TRUE POSITIVES (should trigger alert) ==================
# ===================================================================

# --- Case 1: .NET JwtSecurityTokenHandler.CreateToken with "none" ---
$handler = [System.IdentityModel.Tokens.Jwt.JwtSecurityTokenHandler]::new()
$token = $handler.CreateToken("none") # $ Alert

# --- Case 2: .NET JwtSecurityTokenHandler.CreateEncodedJwt with "none" ---
$token = $handler.CreateEncodedJwt("none") # $ Alert

# ===================================================================
# ========== TRUE NEGATIVES (should NOT trigger alert) ==============
# ===================================================================

# --- Safe: .NET CreateToken with HS256 ---
$token = $handler.CreateToken("HS256") # GOOD

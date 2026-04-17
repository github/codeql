# ===================================================================
# ========== TRUE POSITIVES (should trigger alert) ==================
# ===================================================================

# --- Case 1: SSL 3.0 ---
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Ssl3 # $ Alert

# --- Case 2: TLS 1.0 ---
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls # $ Alert

# --- Case 3: TLS 1.1 ---
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls11 # $ Alert

# --- Case 4: Full namespace TLS 1.0 ---
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls # $ Alert

# ===================================================================
# ========== TRUE NEGATIVES (should NOT trigger alert) ==============
# ===================================================================

# --- Safe: TLS 1.2 ---
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 # GOOD

# --- Safe: TLS 1.3 ---
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls13 # GOOD

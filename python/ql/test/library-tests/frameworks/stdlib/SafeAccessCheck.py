s = "taintedString"

if s.startswith("tainted"):
    s2 = s  # $SafeAccessCheck=s
    pass

sw = s.startswith
if sw("safe"):
    s2 = s  # $ MISSING: SafeAccessCheck=s
    pass

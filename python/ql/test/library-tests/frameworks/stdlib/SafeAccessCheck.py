s = "taintedString"

if s.startswith("tainted"):  # $checks=s branch=true
    pass

sw = s.startswith
if sw("safe"):  # $ MISSING: checks=s branch=true
    pass

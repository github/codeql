s = "taintedString"

if s.startswith("tainted"):  # $checks=s branch=true
    pass

sw = s.startswith  # $ MISSING: checks=s branch=true
if sw("safe"):
    pass

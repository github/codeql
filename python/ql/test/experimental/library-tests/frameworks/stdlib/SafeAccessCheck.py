s = "taintedString"

if s.startswith("tainted"):  # $checks=s $branch=true
    pass

sw = s.startswith  # $f-:checks=s $f-:branch=true
if sw("safe"):
    pass

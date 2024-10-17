param([string]$Source1, [string]$Source2, [string]$Source3, [string]$Source4)

Sink $Source1 # $ hasValueFlow=1
Sink $Source2 # $ hasValueFlow=2
Sink $Source3 # $ hasValueFlow=3
Sink $Source4 # $ MISSING: hasValueFlow=4
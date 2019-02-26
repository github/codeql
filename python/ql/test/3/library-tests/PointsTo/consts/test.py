
import sys
PY3 = sys.version_info[0] == 3

if unknown():
    v1 = unknown()
    #v2 undefined
    k1 = True
elif unknown2():
    v1 = False
    v2 = True
    k1 = 1
else:
    v1 = False
    v2 = True
    k1 = 0.5

if unknown3():
    v3 = unknown()
    #v4 undefined
    k2 = None
elif unknown4():
    v3 = False
    v4 = True
    k2 = False
else:
    raise PruneAnEdge()

v1
v2
v3
v4
k1
k2

from module import PY2

PY2

# Single input "phi"-nodes (due to splitting and pruning).
if PY3:
    pass

if PY3:
    pass

if PY3:
    pass

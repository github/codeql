# Statements that do not contain any other statements.

pass

a = b

c : int = 1

d += e

del f

del f1, f2

global h

global h1, h2

nonlocal i

nonlocal i1, i2

import j

import j1, j2

import j3.j4.j5, j6.j7.j8 as j9

import j10.j11 as j12

from k import l

from ..k1.k2 import l1 as l2, l3

from __future__ import print_function, goto_statement

from . import l4

from l5 import *

from ..l6 import *
from ... import *

raise

raise m

raise m1 from m2

raise m3, m4

raise m5, m6, m7

assert n

assert n1, n2

return o

return *o1,

return 1, *o2

return 2, *o3,

yield p

yield from q

await r

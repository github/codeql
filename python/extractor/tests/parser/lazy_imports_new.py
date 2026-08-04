# Basic lazy imports (PEP 810)
lazy import a

lazy import b1, b2

lazy import c1.c2.c3

lazy import d1.d2 as d3

lazy from e import f

lazy from g1.g2 import h1, h2

lazy from i1 import j1 as j2, j3

lazy from ..k1.k2 import l1 as l2, l3

lazy from . import m

lazy from ... import n

lazy from o import *


# `lazy` used as a regular identifier (soft keyword behavior)
lazy = 1

lazy[2] = 3

lazy.foo = 4

lazy()

lazy[5] : case

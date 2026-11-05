"""Comparisons and evaluation order.

Comparison operands are evaluated left-to-right, followed by the comparison
node itself. Annotations record the *run-time* evaluation order, so this file
self-validates under CPython (``python3 test_comparison.py``).

Python short-circuits *chained* comparisons (in ``a < b < c`` the operand ``c``
is skipped once ``a < b`` is false), whereas the control-flow graph
conservatively evaluates every operand. That divergence cannot be expressed in
a single annotation, so the affected CFG queries report it (captured in the
ConsecutiveTimestamps and NewCfgConsecutivePredecessorTimestamps .expected
files).
"""

from timer import test, dead


@test
def test_two(t):
    # Both operands, then the comparison.
    (1 @ t[0] < 0 @ t[1]) @ t[2]


@test
def test_three(t):
    # Chained comparison, all comparisons hold: operands left-to-right, then
    # the comparison. Run time and CFG agree.
    (1 @ t[0] < 2 @ t[1] < 3 @ t[2]) @ t[3]


@test
def test_three_short_circuit(t):
    # ``1 > 2`` is false, so at run time Python short-circuits and never
    # evaluates ``3``; the comparison is reached at timestamp 2. The CFG still
    # evaluates ``3`` (dead at run time), which is why the CFG queries report a
    # gap around this comparison.
    (1 @ t[0] > 2 @ t[1] < 3 @ t[dead(2)]) @ t[2]

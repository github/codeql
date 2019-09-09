/**
 * @name Avoid floats in for loops
 * @description Floating point variables should not be used as loop counters. For loops are best suited to simple increments and termination conditions; while loops are preferable for more complex uses.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cpp/loop-variable-float
 * @tags correctness
 *       reliability
 *       external/jsf
 */

import cpp

from LoopCounter lc
where lc.getUnderlyingType() instanceof FloatingPointType
select lc, "Floating point variables should not be used as loop counters."

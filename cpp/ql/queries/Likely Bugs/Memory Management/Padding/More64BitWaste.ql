/**
 * @name Padding increased in 64-bit migration
 * @description Highlights structs for which the amount of padding would increase when migrating from a 32-bit architecture to 64-bit.
 * @kind problem
 * @id cpp/more-64-bit-waste
 * @problem.severity warning
 * @tags maintainability
 *       portability
 */

import semmle.code.cpp.padding.Padding

from PaddedType t, ILP32 ilp32, LP64 lp64, int w32, int w64
where
  w32 = t.wastedSpace(ilp32) - t.trailingPadding(ilp32) and
  w64 = t.wastedSpace(lp64) - t.trailingPadding(lp64) and
  w64 > w32 and
  t.isPrecise()
select t,
  t.getName() + " includes " + w32 + " bits of padding on ILP32, but " + w64 + " bits on LP64."

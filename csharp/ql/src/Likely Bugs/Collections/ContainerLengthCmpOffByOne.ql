/**
 * @name Off-by-one comparison against container length
 * @description The index is compared to be less than or equal to the container length, then used
 *              in an array indexing operation that could be out of bounds.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cs/index-out-of-bounds
 * @tags reliability
 *       correctness
 *       logic
  *      external/cwe/cwe-193
 */

import csharp
import semmle.code.csharp.controlflow.Guards

from RelationalOperation cmp, Variable array, Variable index, ElementAccess ea, VariableAccess indexAccess
// Look for `index <= array.Length` or `array.Length >= index`
where (cmp instanceof GEExpr or cmp instanceof LEExpr)
  and cmp.getGreaterOperand() = any(PropertyAccess pa | pa.getQualifier() = array.getAnAccess() and pa.getTarget().hasName("Length"))
  and cmp.getLesserOperand() = index.getAnAccess()
  // Look for `array[index]`
  and ea.getQualifier() = array.getAnAccess()
  and ea.getIndex(0) = indexAccess
  and indexAccess = index.getAnAccess()
  // Where the index access is guarded by the comparison
  and indexAccess.(GuardedExpr).isGuardedBy(cmp, index.getAnAccess(), true)
select cmp, "Off-by-one index comparison against length leads to possible out of bounds $@.", ea, ea.toString()

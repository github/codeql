/**
 * @name Array index out of bounds
 * @description Accessing an array with an index that is greater than or equal to the
 *              length of the array causes an 'ArrayIndexOutOfBoundsException'.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id java/index-out-of-bounds
 * @tags reliability
 *       correctness
 *       exceptions
 *       external/cwe/cwe-193
 */

import java
import semmle.code.java.dataflow.SSA
import semmle.code.java.dataflow.RangeUtils
import semmle.code.java.dataflow.RangeAnalysis

/**
 * Holds if the index expression of `aa` is less than or equal to the array length plus `k`.
 */
predicate boundedArrayAccess(ArrayAccess aa, int k) {
  exists(SsaVariable arr, Expr index, Bound b, int delta |
    aa.getIndexExpr() = index and
    aa.getArray() = arr.getAUse() and
    bounded(index, b, delta, true, _)
  |
    exists(FieldAccess len |
      len.getField() instanceof ArrayLengthField and
      len.getQualifier() = arr.getAUse() and
      b.getExpr() = len and
      k = delta
    )
    or
    exists(ArrayCreationExpr arraycreation | arraycreation = getArrayDef(arr) |
      k = delta and
      arraycreation.getDimension(0) = b.getExpr()
      or
      exists(int arrlen |
        arraycreation.getFirstDimensionSize() = arrlen and
        b instanceof ZeroBound and
        k = delta - arrlen
      )
    )
  )
}

/**
 * Holds if the index expression is less than or equal to the array length plus `k`,
 * but not necessarily less than or equal to the array length plus `k-1`.
 */
predicate bestArrayAccessBound(ArrayAccess aa, int k) {
  k = min(int k0 | boundedArrayAccess(aa, k0))
}

from ArrayAccess aa, int k, string kstr
where
  bestArrayAccessBound(aa, k) and
  k >= 0 and
  if k = 0 then kstr = "" else kstr = " + " + k
select aa,
  "This array access might be out of bounds, as the index might be equal to the array length" + kstr
    + "."

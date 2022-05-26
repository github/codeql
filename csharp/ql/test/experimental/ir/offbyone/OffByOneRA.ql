import csharp
import experimental.ir.IR
import experimental.ir.rangeanalysis.RangeAnalysis
import experimental.ir.rangeanalysis.RangeUtils

/**
 * Holds if the index expression of `aa` is less than or equal to the array length plus `k`.
 */
predicate boundedArrayAccess(ElementAccess aa, int k) {
  exists(Instruction index, Instruction usage, Bound b, int delta |
    (
      // indexer access
      usage.(CallInstruction).getAst() = aa
      or
      // array access
      usage.(PointerAddInstruction).getAst() = aa
    ) and
    usage.getAnOperand().getDef() = index and
    boundedInstruction(index, b, delta, true, _)
  |
    exists(PropertyAccess pa |
      k = delta and
      b.getInstruction().getAst() = pa and
      pa.getProperty().getName() = "Length" and
      pa.(QualifiableExpr).getQualifier().(VariableAccess).getTarget() =
        aa.getQualifier().(VariableAccess).getTarget()
    )
    or
    b instanceof ZeroBound and
    k = delta - getArrayDim(aa.getQualifier().(VariableAccess).getTarget())
  )
}

/**
 * Holds if the index expression is less than or equal to the array length plus `k`,
 * but not necessarily less than or equal to the array length plus `k-1`.
 */
predicate bestArrayAccessBound(ElementAccess aa, int k) {
  k = min(int k0 | boundedArrayAccess(aa, k0))
}

from ElementAccess aa, int k, string msg, string add
where
  bestArrayAccessBound(aa, k) and
  k >= 0 and
  (if k = 0 then add = "" else add = " + " + k) and
  msg =
    "This array access might be out of bounds, as the index might be equal to the array length" +
      add
select aa.getEnclosingCallable(), aa, msg

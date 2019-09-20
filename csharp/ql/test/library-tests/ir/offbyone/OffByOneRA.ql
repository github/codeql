import csharp
import semmle.code.csharp.ir.IR
import semmle.code.csharp.ir.rangeanalysis.RangeAnalysis

/**
 * Holds if the index expression of `aa` is less than or equal to the array length plus `k`.
 */
predicate boundedArrayAccess(ElementAccess aa, int k) {
  exists(Instruction index, Instruction usage, Bound b, int delta |
    (
      // indexer access
      usage.(CallInstruction).getAST() = aa
      or
      // array access
      usage.(PointerAddInstruction).getAST() = aa
    ) and
    usage.getAnOperand().getDef() = index and
    boundedInstruction(index, b, delta, true, _)
  |
    exists(PropertyAccess pa |
      k = delta and
      b.getInstruction().getAST() = pa and
      pa.getProperty().getName() = "Length" and
      pa.(QualifiableExpr).getQualifier().(VariableAccess).getTarget() = aa
            .getQualifier()
            .(VariableAccess)
            .getTarget()
    )
    or
    exists(ArrayCreation ac |
      ac.getParent().(LocalVariableDeclExpr).getVariable() = aa
            .getQualifier()
            .(VariableAccess)
            .getTarget() and
      b instanceof ZeroBound and
      if exists(ac.getLengthArgument(0))
      then k = delta - ac.getLengthArgument(0).getValue().toInt()
      else
        if exists(ac.getInitializer())
        then k = delta - ac.getInitializer().getNumberOfElements()
        else none()
    )
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
  (if k = 0 then add = "" else add = " + " + k) and
  (
    if k >= 0
    then
      msg = "This array access might be out of bounds, as the index might be equal to the array length"
          + add
    else msg = "This array access is ok, the index is at most the lenth of the array " + add
  )
select aa.getEnclosingCallable(), aa, msg

private import RangeAnalysisImpl
private import codeql.rangeanalysis.RangeAnalysis
private import semmle.code.cpp.rangeanalysis.new.internal.semantic.SemanticExpr
private import semmle.code.cpp.rangeanalysis.new.internal.semantic.SemanticType

module FloatOverflow implements OverflowSig<Sem> {
  predicate semExprDoesNotOverflow(boolean positively, SemExpr expr) {
    exists(float lb, float ub, QlBuiltins::BigInt delta |
      typeBounds(expr.getSemType(), lb, ub) and
      ConstantStage::initialBounded(expr, any(ConstantBounds::SemZeroBound b), delta, positively, _,
        _, _)
    |
      positively = true and delta < ub.toString().toBigInt()
      or
      positively = false and delta > lb.toString().toBigInt()
    )
  }

  additional predicate typeBounds(SemType t, float lb, float ub) {
    exists(SemIntegerType integralType, float limit |
      integralType = t and limit = 2.pow(8 * integralType.getByteSize())
    |
      if integralType instanceof SemBooleanType
      then lb = 0 and ub = 1
      else
        if integralType.isSigned()
        then (
          lb = -(limit / 2) and ub = (limit / 2) - 1
        ) else (
          lb = 0 and ub = limit - 1
        )
    )
    or
    // This covers all floating point types. The range is (-Inf, +Inf).
    t instanceof SemFloatingPointType and lb = -(1.0 / 0.0) and ub = 1.0 / 0.0
  }
}

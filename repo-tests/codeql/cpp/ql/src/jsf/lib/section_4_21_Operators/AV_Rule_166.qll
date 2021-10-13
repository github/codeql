import cpp

class IgnoreAllVolatileSpecifiersEverywhere extends Specifier {
  override string getName() { result = super.getName() and result != "volatile" }
}

class SizeofImpureExprOperator extends SizeofExprOperator {
  SizeofImpureExprOperator() {
    exists(Expr e |
      e = this.getExprOperand() and
      not e.isPure() and
      not e.isAffectedByMacro() and
      not e.(OverloadedPointerDereferenceExpr).getExpr().isPure() and
      not exists(OverloadedArrayExpr op | op = e |
        op.getArrayBase().isPure() and
        op.getArrayOffset().isPure()
      )
    )
  }
}

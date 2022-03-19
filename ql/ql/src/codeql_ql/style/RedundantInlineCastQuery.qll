import ql

class RedundantInlineCast extends AstNode instanceof InlineCast {
  Type t;

  RedundantInlineCast() {
    t = unique( | | super.getType()) and
    (
      // The cast is to the type the base expression already has
      t = unique( | | super.getBase().getType())
      or
      // The cast is to the same type as the other expression in an equality comparison
      exists(ComparisonFormula comp, Expr other | comp.getOperator() = "=" |
        this = comp.getAnOperand() and
        other = comp.getAnOperand() and
        this != other and
        t = unique( | | other.getType()) and
        not other instanceof InlineCast // we don't want to risk both sides being "redundant"
      )
      or
      exists(Call call, int i, Predicate target |
        this = call.getArgument(i) and
        target = unique( | | call.getTarget()) and
        t = unique( | | target.getParameterType(i))
      )
    ) and
    // noopt can require explicit casts
    not exists(Annotation annon | annon = this.getEnclosingPredicate().getAnAnnotation() |
      annon.getName() = "pragma" and
      annon.getArgs(0).getValue() = "noopt"
    )
  }

  TypeExpr getTypeExpr() { result = super.getTypeExpr() }
}

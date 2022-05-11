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
    not this.getEnclosingPredicate().getAnAnnotation() instanceof NoOpt
  }

  TypeExpr getTypeExpr() { result = super.getTypeExpr() }
}

// `any(Bar b)`.
private class AnyCast extends AstNode instanceof FullAggregate {
  TypeExpr type;

  AnyCast() {
    super.getKind() = "any" and
    not exists(super.getRange()) and
    not exists(super.getExpr(_)) and
    count(super.getArgument(_)) = 1 and
    type = super.getArgument(0).getTypeExpr()
  }

  TypeExpr getTypeExpr() { result = type }
}

// `foo = any(Bar b)` is effectively a cast to `Bar`.
class RedundantAnyCast extends AstNode instanceof ComparisonFormula {
  AnyCast cast;
  Expr operand;

  RedundantAnyCast() {
    super.getOperator() = "=" and
    super.getAnOperand() = cast and
    super.getAnOperand() = operand and
    cast != operand and
    unique( | | operand.getType()).getASuperType*() =
      unique( | | cast.getTypeExpr().getResolvedType()) and
    not this.getEnclosingPredicate().getAnAnnotation() instanceof NoOpt
  }

  TypeExpr getTypeExpr() { result = cast.getTypeExpr() }
}

// foo instanceof Bar
class RedundantInstanceof extends AstNode instanceof InstanceOf {
  RedundantInstanceof() {
    unique( | | super.getExpr().getType()).getASuperType*() =
      unique( | | super.getType().getResolvedType()) and
    not this.getEnclosingPredicate().getAnAnnotation() instanceof NoOpt
  }

  TypeExpr getTypeExpr() { result = super.getType() }
}

predicate redundantCast(AstNode n, TypeExpr type) {
  n.(RedundantInlineCast).getTypeExpr() = type
  or
  n.(RedundantAnyCast).getTypeExpr() = type
  or
  n.(RedundantInstanceof).getTypeExpr() = type
}

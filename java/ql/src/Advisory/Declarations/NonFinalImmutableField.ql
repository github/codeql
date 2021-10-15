/**
 * @name Non-final immutable field
 * @description A field of immutable type that is assigned to only in a constructor or static
 *              initializer of its declaring type, but is not declared 'final', may lead to defects
 *              and makes code less readable.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id java/non-final-immutable-field
 * @tags reliability
 */

import java

class Initialization extends Callable {
  Initialization() {
    this instanceof Constructor or
    this instanceof InitializerMethod
  }
}

/** A binary or unary assignment. */
class AnyAssignment extends Expr {
  AnyAssignment() {
    this instanceof Assignment or
    this instanceof UnaryAssignExpr
  }

  /** The expression modified by this assignment. */
  Expr getDest() {
    this.(Assignment).getDest() = result or
    this.(UnaryAssignExpr).getExpr() = result
  }
}

class ImmutableField extends Field {
  ImmutableField() {
    this.fromSource() and
    not this instanceof EnumConstant and
    this.getType() instanceof ImmutableType and
    // The field is only assigned to in a constructor or static initializer of the type it is declared in.
    forall(FieldAccess fw, AnyAssignment ae |
      fw.getField().getSourceDeclaration() = this and
      fw = ae.getDest()
    |
      ae.getEnclosingCallable().getDeclaringType() = this.getDeclaringType() and
      ae.getEnclosingCallable() instanceof Initialization
    )
  }
}

from ImmutableField f
where not f.isFinal()
select f,
  "This immutable field is not declared final but is only assigned to during initialization."

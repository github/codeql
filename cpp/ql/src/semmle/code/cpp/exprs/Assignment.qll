import semmle.code.cpp.exprs.Expr
import semmle.code.cpp.exprs.ArithmeticOperation
import semmle.code.cpp.exprs.BitwiseOperation

/**
 * A non-overloaded binary assignment operation, including `=`, `+=`, `&=`,
 * etc. A C++ overloaded operation looks syntactically identical but is instead
 * a `FunctionCall`.
 */
abstract class Assignment extends Operation {
  /** Gets the lvalue of this assignment. */
  Expr getLValue() { this.hasChild(result, 0) }

  /** Gets the rvalue of this assignment. */
  Expr getRValue() { this.hasChild(result, 1) }

  override int getPrecedence() { result = 2 }

  override predicate mayBeGloballyImpure() {
    this.getRValue().mayBeGloballyImpure()
    or
    not exists(VariableAccess va, LocalScopeVariable v |
      va = this.getLValue() and
      v = va.getTarget() and
      not va.getConversion+() instanceof ReferenceDereferenceExpr and
      not v.isStatic()
    )
  }
}

/**
 * A non-overloaded assignment operation with the operator `=`.
 */
class AssignExpr extends Assignment, @assignexpr {
  override string getOperator() { result = "=" }

  override string getCanonicalQLClass() { result = "AssignExpr" }

  /** Gets a textual representation of this assignment. */
  override string toString() { result = "... = ..." }
}

/**
 * A non-overloaded binary assignment operation other than `=`.
 */
abstract class AssignOperation extends Assignment {
  override string toString() { result = "... " + this.getOperator() + " ..." }
}

/**
 * A non-overloaded arithmetic assignment operation on a non-pointer lvalue:
 * `+=`, `-=`, `*=`, `/=` and `%=`.
 */
abstract class AssignArithmeticOperation extends AssignOperation { }

/**
 * A non-overloaded `+=` assignment expression on a non-pointer lvalue.
 */
class AssignAddExpr extends AssignArithmeticOperation, @assignaddexpr {
  override string getCanonicalQLClass() { result = "AssignAddExpr" }

  override string getOperator() { result = "+=" }
}

/**
 * A non-overloaded `-=` assignment expression on a non-pointer lvalue.
 */
class AssignSubExpr extends AssignArithmeticOperation, @assignsubexpr {
  override string getCanonicalQLClass() { result = "AssignSubExpr" }

  override string getOperator() { result = "-=" }
}

/**
 * A non-overloaded `*=` assignment expression.
 */
class AssignMulExpr extends AssignArithmeticOperation, @assignmulexpr {
  override string getCanonicalQLClass() { result = "AssignMulExpr" }

  override string getOperator() { result = "*=" }
}

/**
 * A non-overloaded `/=` assignment expression.
 */
class AssignDivExpr extends AssignArithmeticOperation, @assigndivexpr {
  override string getCanonicalQLClass() { result = "AssignDivExpr" }

  override string getOperator() { result = "/=" }
}

/**
 * A non-overloaded `%=` assignment expression.
 */
class AssignRemExpr extends AssignArithmeticOperation, @assignremexpr {
  override string getCanonicalQLClass() { result = "AssignRemExpr" }

  override string getOperator() { result = "%=" }
}

/**
 * A non-overloaded bitwise assignment operation:
 * `&=`, `|=`, `^=`, `<<=`, and `>>=`.
 */
abstract class AssignBitwiseOperation extends AssignOperation { }

/**
 * A non-overloaded `&=` assignment expression.
 */
class AssignAndExpr extends AssignBitwiseOperation, @assignandexpr {
  override string getCanonicalQLClass() { result = "AssignAndExpr" }

  override string getOperator() { result = "&=" }
}

/**
 * A non-overloaded `|=` assignment expression.
 */
class AssignOrExpr extends AssignBitwiseOperation, @assignorexpr {
  override string getCanonicalQLClass() { result = "AssignOrExpr" }

  override string getOperator() { result = "|=" }
}

/**
 * A non-overloaded `^=` assignment expression.
 */
class AssignXorExpr extends AssignBitwiseOperation, @assignxorexpr {
  override string getCanonicalQLClass() { result = "AssignXorExpr" }

  override string getOperator() { result = "^=" }
}

/**
 * A non-overloaded `<<=` assignment expression.
 */
class AssignLShiftExpr extends AssignBitwiseOperation, @assignlshiftexpr {
  override string getCanonicalQLClass() { result = "AssignLShiftExpr" }

  override string getOperator() { result = "<<=" }
}

/**
 * A non-overloaded `>>=` assignment expression.
 */
class AssignRShiftExpr extends AssignBitwiseOperation, @assignrshiftexpr {
  override string getCanonicalQLClass() { result = "AssignRShiftExpr" }

  override string getOperator() { result = ">>=" }
}

/**
 * A non-overloaded `+=` pointer assignment expression.
 */
class AssignPointerAddExpr extends AssignOperation, @assignpaddexpr {
  override string getCanonicalQLClass() { result = "AssignPointerAddExpr" }

  override string getOperator() { result = "+=" }
}

/**
 * A non-overloaded `-=` pointer assignment expression.
 */
class AssignPointerSubExpr extends AssignOperation, @assignpsubexpr {
  override string getCanonicalQLClass() { result = "AssignPointerSubExpr" }

  override string getOperator() { result = "-=" }
}

/**
 * A C++ variable declaration in an expression where a condition is expected.
 * For example, on the `ConditionDeclExpr` in `if (bool c = x < y)`,
 * `getVariableAccess()` is an access to `c` (with possible casts),
 * `getVariable()` is the variable `c` (which has an initializer `x < y`), and
 * `getInitializingExpr()` is `x < y`.
 */
class ConditionDeclExpr extends Expr, @condition_decl {
  /**
   * DEPRECATED: Use `getVariableAccess()` or `getInitializingExpr()` instead.
   *
   * Gets the access using the condition for this declaration.
   */
  deprecated Expr getExpr() { result = this.getChild(0) }

  override string getCanonicalQLClass() { result = "ConditionDeclExpr" }

  /**
   * Gets the compiler-generated variable access that conceptually occurs after
   * the initialization of the declared variable.
   */
  VariableAccess getVariableAccess() { result = this.getChild(0) }

  /**
   * Gets the expression that initializes the declared variable. This predicate
   * always has a result.
   */
  Expr getInitializingExpr() { result = this.getVariable().getInitializer().getExpr() }

  /** Gets the variable that is declared. */
  Variable getVariable() { condition_decl_bind(underlyingElement(this), unresolveElement(result)) }

  override string toString() { result = "(condition decl)" }
}

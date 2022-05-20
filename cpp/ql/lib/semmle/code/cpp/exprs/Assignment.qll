import semmle.code.cpp.exprs.Expr
import semmle.code.cpp.exprs.ArithmeticOperation
import semmle.code.cpp.exprs.BitwiseOperation

/**
 * A non-overloaded binary assignment operation, including `=`, `+=`, `&=`,
 * etc. A C++ overloaded assignment operation looks syntactically identical but is instead
 * a `FunctionCall`. This class does _not_ include variable initializers. To get a variable
 * initializer, use `Initializer` instead.
 *
 * This is a QL base class for all (non-overloaded) assignments.
 */
class Assignment extends Operation, @assign_expr {
  /** Gets the _lvalue_ of this assignment. */
  Expr getLValue() { this.hasChild(result, 0) }

  /** Gets the rvalue of this assignment. */
  Expr getRValue() { this.hasChild(result, 1) }

  override int getPrecedence() { result = 2 }

  override predicate mayBeGloballyImpure() {
    this.getRValue().mayBeGloballyImpure()
    or
    not exists(VariableAccess va, StackVariable v |
      va = this.getLValue() and
      v = va.getTarget() and
      not va.getConversion+() instanceof ReferenceDereferenceExpr
    )
  }
}

/**
 * A non-overloaded assignment operation with the operator `=`.
 * ```
 * a = b;
 * ```
 * Note that `int a = b;` is _not_ an `AssignExpr`. It is a `Variable`,
 * and `b` can be obtained using `Variable.getInitializer()`.
 */
class AssignExpr extends Assignment, @assignexpr {
  override string getOperator() { result = "=" }

  override string getAPrimaryQlClass() { result = "AssignExpr" }

  /** Gets a textual representation of this assignment. */
  override string toString() { result = "... = ..." }
}

/**
 * A non-overloaded binary assignment operation other than `=`.
 *
 * This class does _not_ include variable initializers. To get a variable
 * initializer, use `Initializer` instead.
 */
class AssignOperation extends Assignment, @assign_op_expr {
  override string toString() { result = "... " + this.getOperator() + " ..." }
}

/**
 * A non-overloaded arithmetic assignment operation on a non-pointer _lvalue_:
 * `+=`, `-=`, `*=`, `/=` and `%=`.
 */
class AssignArithmeticOperation extends AssignOperation, @assign_arith_expr { }

/**
 * A non-overloaded `+=` assignment expression on a non-pointer _lvalue_.
 * ```
 * a += b;
 * ```
 */
class AssignAddExpr extends AssignArithmeticOperation, @assignaddexpr {
  override string getAPrimaryQlClass() { result = "AssignAddExpr" }

  override string getOperator() { result = "+=" }
}

/**
 * A non-overloaded `-=` assignment expression on a non-pointer _lvalue_.
 * ```
 * a -= b;
 * ```
 */
class AssignSubExpr extends AssignArithmeticOperation, @assignsubexpr {
  override string getAPrimaryQlClass() { result = "AssignSubExpr" }

  override string getOperator() { result = "-=" }
}

/**
 * A non-overloaded `*=` assignment expression.
 * ```
 * a *= b;
 * ```
 */
class AssignMulExpr extends AssignArithmeticOperation, @assignmulexpr {
  override string getAPrimaryQlClass() { result = "AssignMulExpr" }

  override string getOperator() { result = "*=" }
}

/**
 * A non-overloaded `/=` assignment expression.
 * ```
 * a /= b;
 * ```
 */
class AssignDivExpr extends AssignArithmeticOperation, @assigndivexpr {
  override string getAPrimaryQlClass() { result = "AssignDivExpr" }

  override string getOperator() { result = "/=" }
}

/**
 * A non-overloaded `%=` assignment expression.
 * ```
 * a %= b;
 * ```
 */
class AssignRemExpr extends AssignArithmeticOperation, @assignremexpr {
  override string getAPrimaryQlClass() { result = "AssignRemExpr" }

  override string getOperator() { result = "%=" }
}

/**
 * A non-overloaded bitwise assignment operation:
 * `&=`, `|=`, `^=`, `<<=`, and `>>=`.
 */
class AssignBitwiseOperation extends AssignOperation, @assign_bitwise_expr { }

/**
 * A non-overloaded AND (`&=`) assignment expression.
 * ```
 * a &= b;
 * ```
 */
class AssignAndExpr extends AssignBitwiseOperation, @assignandexpr {
  override string getAPrimaryQlClass() { result = "AssignAndExpr" }

  override string getOperator() { result = "&=" }
}

/**
 * A non-overloaded OR (`|=`) assignment expression.
 * ```
 * a |= b;
 * ```
 */
class AssignOrExpr extends AssignBitwiseOperation, @assignorexpr {
  override string getAPrimaryQlClass() { result = "AssignOrExpr" }

  override string getOperator() { result = "|=" }
}

/**
 * A non-overloaded XOR (`^=`) assignment expression.
 * ```
 * a ^= b;
 * ```
 */
class AssignXorExpr extends AssignBitwiseOperation, @assignxorexpr {
  override string getAPrimaryQlClass() { result = "AssignXorExpr" }

  override string getOperator() { result = "^=" }
}

/**
 * A non-overloaded `<<=` assignment expression.
 * ```
 * a <<= b;
 * ```
 */
class AssignLShiftExpr extends AssignBitwiseOperation, @assignlshiftexpr {
  override string getAPrimaryQlClass() { result = "AssignLShiftExpr" }

  override string getOperator() { result = "<<=" }
}

/**
 * A non-overloaded `>>=` assignment expression.
 * ```
 * a >>= b;
 * ```
 */
class AssignRShiftExpr extends AssignBitwiseOperation, @assignrshiftexpr {
  override string getAPrimaryQlClass() { result = "AssignRShiftExpr" }

  override string getOperator() { result = ">>=" }
}

/**
 * A non-overloaded `+=` pointer assignment expression.
 * ```
 * ptr += index;
 * ```
 */
class AssignPointerAddExpr extends AssignOperation, @assignpaddexpr {
  override string getAPrimaryQlClass() { result = "AssignPointerAddExpr" }

  override string getOperator() { result = "+=" }
}

/**
 * A non-overloaded `-=` pointer assignment expression.
 * ```
 * ptr -= index;
 * ```
 */
class AssignPointerSubExpr extends AssignOperation, @assignpsubexpr {
  override string getAPrimaryQlClass() { result = "AssignPointerSubExpr" }

  override string getOperator() { result = "-=" }
}

/**
 * A C++ variable declaration inside the conditional expression of a `while`, `if` or
 * `for` compound statement.  Declaring a variable this way narrows its lifetime and
 * scope to be strictly the compound statement itself.  For example:
 * ```
 * extern int x, y;
 * if (bool c = x < y) { do_something_with(c); }
 * // c is no longer in scope
 * while (int d = x - y) { do_something_else_with(d); }
 * // d is no longer is scope
 * ```
 */
class ConditionDeclExpr extends Expr, @condition_decl {
  override string getAPrimaryQlClass() { result = "ConditionDeclExpr" }

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

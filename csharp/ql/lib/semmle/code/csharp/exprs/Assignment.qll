/**
 * Provides all assignment classes.
 *
 * All assignments have the common base class `Assignment`.
 */

import Expr

/**
 * An assignment. Either a local variable initialization
 * (`LocalVariableDeclAndInitExpr`), a simple assignment (`AssignExpr`), or
 * an assignment operation (`AssignOperation`).
 */
class Assignment extends BinaryOperation, @assign_expr {
  Assignment() {
    this instanceof LocalVariableDeclExpr
    implies
    // Same as `this.(LocalVariableDeclExpr).hasInitializer()` but avoids
    // negative recursion
    expr_parent(_, 1, this)
  }

  /**
   * DEPRECATED: Use `getLeftOperand` instead.
   *
   * Gets the left operand of this assignment.
   */
  deprecated Expr getLValue() { result = this.getLeftOperand() }

  /**
   * DEPRECATED: Use `getRightOperand` instead.
   *
   * Gets the right operand of this assignment.
   */
  deprecated Expr getRValue() { result = this.getRightOperand() }

  /** Gets the variable being assigned to, if any. */
  Variable getTargetVariable() { result.getAnAccess() = this.getLeftOperand() }

  override string getOperator() { none() }
}

/**
 * A local variable initialization, for example `int x = 0`.
 */
class LocalVariableDeclAndInitExpr extends LocalVariableDeclExpr, Assignment {
  override string getOperator() { result = "=" }

  override LocalVariable getTargetVariable() { result = this.getVariable() }

  /**
   * DEPRECATED: Use `getLeftOperand` instead.
   */
  deprecated override LocalVariableAccess getLValue() { result = this.getLeftOperand() }

  override LocalVariableAccess getLeftOperand() { result = Assignment.super.getLeftOperand() }

  override string toString() { result = LocalVariableDeclExpr.super.toString() + " = ..." }

  override string getAPrimaryQlClass() { result = "LocalVariableDeclAndInitExpr" }
}

/**
 * A simple assignment, for example `x = 0`.
 */
class AssignExpr extends Assignment, @simple_assign_expr {
  override string getOperator() { result = "=" }

  override string toString() { result = "... = ..." }

  override string getAPrimaryQlClass() { result = "AssignExpr" }
}

/**
 * An assignment operation. Either an arithmetic assignment expression
 * (`AssignArithmeticExpr`), a bitwise assignment expression
 * (`AssignBitwiseExpr`), an event assignment (`AddOrRemoveEventExpr`), or
 * a null-coalescing assignment (`AssignCoalesceExpr`).
 */
class AssignOperation extends Assignment, @assign_op_expr {
  override string getOperator() { none() }

  /**
   * Expanded versions of compound assignments are no longer extracted.
   */
  deprecated AssignExpr getExpandedAssignment() { none() }

  /**
   * Expanded versions of compound assignments are no longer extracted.
   */
  deprecated predicate hasExpandedAssignment() { none() }

  override string toString() { result = "... " + this.getOperator() + " ..." }
}

/**
 * A compound assignment expression that invokes an operator.
 *
 * (1) `x += y` invokes the compound assignment operator `+=` (if it exists).
 * (2) `x += y` invokes the operator `+` and assigns `x + y` to `x`.
 *
 * Either an arithmetic assignment expression (`AssignArithmeticExpr`) or a bitwise
 * assignment expression (`AssignBitwiseExpr`).
 */
class AssignCallExpr extends AssignOperation, OperatorCall, QualifiableExpr, @assign_op_call_expr {
  override string toString() { result = AssignOperation.super.toString() }
}

/**
 * DEPRECATED: Use `AssignCallExpr` instead.
 */
deprecated class AssignCallOperation = AssignCallExpr;

/**
 * An arithmetic assignment expression. Either an addition assignment expression
 * (`AssignAddExpr`), a subtraction assignment expression (`AssignSubExpr`), a
 * multiplication assignment expression (`AssignMulExpr`), a division assignment
 * expression (`AssignDivExpr`), or a remainder assignment expression
 * (`AssignRemExpr`).
 */
class AssignArithmeticExpr extends AssignCallExpr, @assign_arith_expr { }

/**
 * DEPRECATED: Use `AssignArithmeticExpr` instead.
 */
deprecated class AssignArithmeticOperation = AssignArithmeticExpr;

/**
 * An addition assignment expression, for example `x += y`.
 */
class AssignAddExpr extends AssignArithmeticExpr, AddOperation, @assign_add_expr {
  override string getOperator() { result = "+=" }

  override string getAPrimaryQlClass() { result = "AssignAddExpr" }
}

/**
 * A subtraction assignment expression, for example `x -= y`.
 */
class AssignSubExpr extends AssignArithmeticExpr, SubOperation, @assign_sub_expr {
  override string getOperator() { result = "-=" }

  override string getAPrimaryQlClass() { result = "AssignSubExpr" }
}

/**
 * A multiplication assignment expression, for example `x *= y`.
 */
class AssignMulExpr extends AssignArithmeticExpr, MulOperation, @assign_mul_expr {
  override string getOperator() { result = "*=" }

  override string getAPrimaryQlClass() { result = "AssignMulExpr" }
}

/**
 * A division assignment expression, for example `x /= y`.
 */
class AssignDivExpr extends AssignArithmeticExpr, DivOperation, @assign_div_expr {
  override string getOperator() { result = "/=" }

  override string getAPrimaryQlClass() { result = "AssignDivExpr" }
}

/**
 * A remainder assignment expression, for example `x %= y`.
 */
class AssignRemExpr extends AssignArithmeticExpr, RemOperation, @assign_rem_expr {
  override string getOperator() { result = "%=" }

  override string getAPrimaryQlClass() { result = "AssignRemExpr" }
}

/**
 * A bitwise assignment expression. Either a bitwise-and assignment
 * expression (`AssignAndExpr`), a bitwise-or assignment
 * expression (`AssignOrExpr`), a bitwise exclusive-or assignment
 * expression (`AssignXorExpr`), a left-shift assignment
 * expression (`AssignLeftShiftExpr`), or a right-shift assignment
 * expression (`AssignRightShiftExpr`), or an unsigned right-shift assignment
 * expression (`AssignUnsignedRightShiftExpr`).
 */
class AssignBitwiseExpr extends AssignCallExpr, @assign_bitwise_expr { }

/**
 * DEPRECATED: Use `AssignBitwiseExpr` instead.
 */
deprecated class AssignBitwiseOperation = AssignBitwiseExpr;

/**
 * A bitwise-and assignment expression, for example `x &= y`.
 */
class AssignAndExpr extends AssignBitwiseExpr, BitwiseAndOperation, @assign_and_expr {
  override string getOperator() { result = "&=" }

  override string getAPrimaryQlClass() { result = "AssignAndExpr" }
}

/**
 * A bitwise-or assignment expression, for example `x |= y`.
 */
class AssignOrExpr extends AssignBitwiseExpr, BitwiseOrOperation, @assign_or_expr {
  override string getOperator() { result = "|=" }

  override string getAPrimaryQlClass() { result = "AssignOrExpr" }
}

/**
 * A bitwise exclusive-or assignment expression, for example `x ^= y`.
 */
class AssignXorExpr extends AssignBitwiseExpr, BitwiseXorOperation, @assign_xor_expr {
  override string getOperator() { result = "^=" }

  override string getAPrimaryQlClass() { result = "AssignXorExpr" }
}

/**
 * A left-shift assignment expression, for example `x <<= y`.
 */
class AssignLeftShiftExpr extends AssignBitwiseExpr, LeftShiftOperation, @assign_lshift_expr {
  override string getOperator() { result = "<<=" }

  override string getAPrimaryQlClass() { result = "AssignLeftShiftExpr" }
}

/**
 * A right-shift assignment expression, for example `x >>= y`.
 */
class AssignRightShiftExpr extends AssignBitwiseExpr, RightShiftOperation, @assign_rshift_expr {
  override string getOperator() { result = ">>=" }

  override string getAPrimaryQlClass() { result = "AssignRightShiftExpr" }
}

/**
 * An unsigned right-shift assignment expression, for example `x >>>= y`.
 */
class AssignUnsignedRightShiftExpr extends AssignBitwiseExpr, UnsignedRightShiftOperation,
  @assign_urshift_expr
{
  override string getOperator() { result = ">>>=" }

  override string getAPrimaryQlClass() { result = "AssignUnsignedRightShiftExpr" }
}

/**
 *  DEPRECATED: Use `AssignUnsignedRightShiftExpr` instead.
 */
deprecated class AssignUnsighedRightShiftExpr = AssignUnsignedRightShiftExpr;

/**
 * An event assignment. Either an event addition (`AddEventExpr`) or an event
 * removal (`RemoveEventExpr`).
 */
class AddOrRemoveEventExpr extends AssignOperation, @assign_event_expr {
  /** Gets the event targeted by this event assignment. */
  Event getTarget() { result = this.getLeftOperand().getTarget() }

  /**
   * DEPRECATED: Use `getLeftOperand` instead.
   */
  deprecated override EventAccess getLValue() { result = this.getLeftOperand() }

  override EventAccess getLeftOperand() { result = this.getChild(0) }
}

/**
 * An event addition, for example line 9 in
 *
 * ```csharp
 * class A {
 *   public delegate void EventHandler(object sender, object e);
 *
 *   public event EventHandler Click;
 *
 *   void A_Click(object sender, object e) {  }
 *
 *   void AddEvent() {
 *     Click += A_Click;
 *   }
 * }
 * ```
 */
class AddEventExpr extends AddOrRemoveEventExpr, @add_event_expr {
  override string toString() { result = "... += ..." }

  override string getAPrimaryQlClass() { result = "AddEventExpr" }
}

/**
 * An event removal, for example line 9 in
 *
 * ```csharp
 * class A {
 *   public delegate void EventHandler(object sender, object e);
 *
 *   public event EventHandler Click;
 *
 *   void A_Click(object sender, object e) {  }
 *
 *   void RemoveEvent() {
 *     Click -= A_Click;
 *   }
 * }
 * ```
 */
class RemoveEventExpr extends AddOrRemoveEventExpr, @remove_event_expr {
  override string toString() { result = "... -= ..." }

  override string getAPrimaryQlClass() { result = "RemoveEventExpr" }
}

/**
 * A null-coalescing assignment expression, for example `x ??= y`.
 */
class AssignCoalesceExpr extends AssignOperation, NullCoalescingOperation, @assign_coalesce_expr {
  override string getOperator() { result = "??=" }

  override string getAPrimaryQlClass() { result = "AssignCoalesceExpr" }
}

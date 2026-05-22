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
 * An assignment operation. Either an arithmetic assignment operation
 * (`AssignArithmeticOperation`), a bitwise assignment operation
 * (`AssignBitwiseOperation`), an event assignment (`AddOrRemoveEventExpr`), or
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
 * A compound assignment operation that invokes an operator.
 *
 * (1) `x += y` invokes the compound assignment operator `+=` (if it exists).
 * (2) `x += y` invokes the operator `+` and assigns `x + y` to `x`.
 *
 * Either an arithmetic assignment operation (`AssignArithmeticOperation`) or a bitwise
 * assignment operation (`AssignBitwiseOperation`).
 */
class AssignCallOperation extends AssignOperation, OperatorCall, QualifiableExpr,
  @assign_op_call_expr
{
  override string toString() { result = AssignOperation.super.toString() }
}

/**
 * An arithmetic assignment operation. Either an addition assignment operation
 * (`AssignAddExpr`), a subtraction assignment operation (`AssignSubExpr`), a
 * multiplication assignment operation (`AssignMulExpr`), a division assignment
 * operation (`AssignDivExpr`), or a remainder assignment operation
 * (`AssignRemExpr`).
 */
class AssignArithmeticOperation extends AssignCallOperation, @assign_arith_expr { }

/**
 * An addition assignment operation, for example `x += y`.
 */
class AssignAddExpr extends AssignArithmeticOperation, AddOperation, @assign_add_expr {
  override string getOperator() { result = "+=" }

  override string getAPrimaryQlClass() { result = "AssignAddExpr" }
}

/**
 * A subtraction assignment operation, for example `x -= y`.
 */
class AssignSubExpr extends AssignArithmeticOperation, SubOperation, @assign_sub_expr {
  override string getOperator() { result = "-=" }

  override string getAPrimaryQlClass() { result = "AssignSubExpr" }
}

/**
 * An multiplication assignment operation, for example `x *= y`.
 */
class AssignMulExpr extends AssignArithmeticOperation, MulOperation, @assign_mul_expr {
  override string getOperator() { result = "*=" }

  override string getAPrimaryQlClass() { result = "AssignMulExpr" }
}

/**
 * An division assignment operation, for example `x /= y`.
 */
class AssignDivExpr extends AssignArithmeticOperation, DivOperation, @assign_div_expr {
  override string getOperator() { result = "/=" }

  override string getAPrimaryQlClass() { result = "AssignDivExpr" }
}

/**
 * A remainder assignment operation, for example `x %= y`.
 */
class AssignRemExpr extends AssignArithmeticOperation, RemOperation, @assign_rem_expr {
  override string getOperator() { result = "%=" }

  override string getAPrimaryQlClass() { result = "AssignRemExpr" }
}

/**
 * A bitwise assignment operation. Either a bitwise-and assignment
 * operation (`AssignAndExpr`), a bitwise-or assignment
 * operation (`AssignOrExpr`), a bitwise exclusive-or assignment
 * operation (`AssignXorExpr`), a left-shift assignment
 * operation (`AssignLeftShiftExpr`), or a right-shift assignment
 * operation (`AssignRightShiftExpr`), or an unsigned right-shift assignment
 * operation (`AssignUnsignedRightShiftExpr`).
 */
class AssignBitwiseOperation extends AssignCallOperation, @assign_bitwise_expr { }

/**
 * A bitwise-and assignment operation, for example `x &= y`.
 */
class AssignAndExpr extends AssignBitwiseOperation, BitwiseAndOperation, @assign_and_expr {
  override string getOperator() { result = "&=" }

  override string getAPrimaryQlClass() { result = "AssignAndExpr" }
}

/**
 * A bitwise-or assignment operation, for example `x |= y`.
 */
class AssignOrExpr extends AssignBitwiseOperation, BitwiseOrOperation, @assign_or_expr {
  override string getOperator() { result = "|=" }

  override string getAPrimaryQlClass() { result = "AssignOrExpr" }
}

/**
 * A bitwise exclusive-or assignment operation, for example `x ^= y`.
 */
class AssignXorExpr extends AssignBitwiseOperation, BitwiseXorOperation, @assign_xor_expr {
  override string getOperator() { result = "^=" }

  override string getAPrimaryQlClass() { result = "AssignXorExpr" }
}

/**
 * A left-shift assignment operation, for example `x <<= y`.
 */
class AssignLeftShiftExpr extends AssignBitwiseOperation, LeftShiftOperation, @assign_lshift_expr {
  override string getOperator() { result = "<<=" }

  override string getAPrimaryQlClass() { result = "AssignLeftShiftExpr" }
}

/**
 * A right-shift assignment operation, for example `x >>= y`.
 */
class AssignRightShiftExpr extends AssignBitwiseOperation, RightShiftOperation, @assign_rshift_expr {
  override string getOperator() { result = ">>=" }

  override string getAPrimaryQlClass() { result = "AssignRightShiftExpr" }
}

/**
 * An unsigned right-shift assignment operation, for example `x >>>= y`.
 */
class AssignUnsignedRightShiftExpr extends AssignBitwiseOperation, UnsignedRightShiftOperation,
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
 * A null-coalescing assignment operation, for example `x ??= y`.
 */
class AssignCoalesceExpr extends AssignOperation, NullCoalescingOperation, @assign_coalesce_expr {
  override string toString() { result = "... ??= ..." }

  override string getAPrimaryQlClass() { result = "AssignCoalesceExpr" }
}

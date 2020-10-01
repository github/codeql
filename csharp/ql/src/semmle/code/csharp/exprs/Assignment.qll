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
class Assignment extends Operation, @assign_expr {
  Assignment() {
    this instanceof LocalVariableDeclExpr
    implies
    // Same as `this.(LocalVariableDeclExpr).hasInitializer()` but avoids
    // negative recursion
    expr_parent(_, 0, this)
  }

  /** Gets the left operand of this assignment. */
  Expr getLValue() { result = this.getChild(1) }

  /** Gets the right operand of this assignment. */
  Expr getRValue() { result = this.getChild(0) }

  /** Gets the variable being assigned to, if any. */
  Variable getTargetVariable() { result.getAnAccess() = getLValue() }

  override string getOperator() { none() }
}

/**
 * A local variable initialization, for example `int x = 0`.
 */
class LocalVariableDeclAndInitExpr extends LocalVariableDeclExpr, Assignment {
  override string getOperator() { result = "=" }

  override LocalVariable getTargetVariable() { result = getVariable() }

  override LocalVariableAccess getLValue() { result = Assignment.super.getLValue() }

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
 * (`AssignBitwiseOperation`), or an event assignment (`AddOrRemoveEventExpr`).
 */
class AssignOperation extends Assignment, @assign_op_expr {
  override string getOperator() { none() }

  /**
   * Gets the expanded version of this assignment operation, if any.
   *
   * For example, if this assignment operation is `x += y` then
   * the expanded assignment is `x = x + y`.
   *
   * If an expanded version exists, then it is used in the control
   * flow graph.
   */
  AssignExpr getExpandedAssignment() { expr_parent(result, 2, this) }

  /**
   * Holds if this assignment operation has an expanded version.
   *
   * For example, if this assignment operation is `x += y` then
   * it has the expanded version `x = x + y`.
   *
   * If an expanded version exists, then it is used in the control
   * flow graph.
   */
  predicate hasExpandedAssignment() { exists(getExpandedAssignment()) }

  override string toString() { result = "... " + this.getOperator() + " ..." }
}

/**
 * An arithmetic assignment operation. Either an addition assignment operation
 * (`AssignAddExpr`), a subtraction assignment operation (`AssignSubExpr`), a
 * multiplication assignment operation (`AssignMulExpr`), a division assignment
 * operation (`AssignDivExpr`), or a remainder assignment operation
 * (`AssignRemExpr`).
 */
class AssignArithmeticOperation extends AssignOperation, @assign_arith_expr { }

/**
 * An addition assignment operation, for example `x += y`.
 */
class AssignAddExpr extends AssignArithmeticOperation, @assign_add_expr {
  override string getOperator() { result = "+=" }

  override string getAPrimaryQlClass() { result = "AssignAddExpr" }
}

/**
 * A subtraction assignment operation, for example `x -= y`.
 */
class AssignSubExpr extends AssignArithmeticOperation, @assign_sub_expr {
  override string getOperator() { result = "-=" }

  override string getAPrimaryQlClass() { result = "AssignSubExpr" }
}

/**
 * An multiplication assignment operation, for example `x *= y`.
 */
class AssignMulExpr extends AssignArithmeticOperation, @assign_mul_expr {
  override string getOperator() { result = "*=" }

  override string getAPrimaryQlClass() { result = "AssignMulExpr" }
}

/**
 * An division assignment operation, for example `x /= y`.
 */
class AssignDivExpr extends AssignArithmeticOperation, @assign_div_expr {
  override string getOperator() { result = "/=" }

  override string getAPrimaryQlClass() { result = "AssignDivExpr" }
}

/**
 * A remainder assignment operation, for example `x %= y`.
 */
class AssignRemExpr extends AssignArithmeticOperation, @assign_rem_expr {
  override string getOperator() { result = "%=" }

  override string getAPrimaryQlClass() { result = "AssignRemExpr" }
}

/**
 * A bitwise assignment operation. Either a bitwise-and assignment
 * operation (`AssignAndExpr`), a bitwise-or assignment
 * operation (`AssignOrExpr`), a bitwise exclusive-or assignment
 * operation (`AssignXorExpr`), a left-shift assignment
 * operation (`AssignLShiftExpr`), or a right-shift assignment
 * operation (`AssignRShiftExpr`).
 */
class AssignBitwiseOperation extends AssignOperation, @assign_bitwise_expr { }

/**
 * A bitwise-and assignment operation, for example `x &= y`.
 */
class AssignAndExpr extends AssignBitwiseOperation, @assign_and_expr {
  override string getOperator() { result = "&=" }

  override string getAPrimaryQlClass() { result = "AssignAndExpr" }
}

/**
 * A bitwise-or assignment operation, for example `x |= y`.
 */
class AssignOrExpr extends AssignBitwiseOperation, @assign_or_expr {
  override string getOperator() { result = "|=" }

  override string getAPrimaryQlClass() { result = "AssignOrExpr" }
}

/**
 * A bitwise exclusive-or assignment operation, for example `x ^= y`.
 */
class AssignXorExpr extends AssignBitwiseOperation, @assign_xor_expr {
  override string getOperator() { result = "^=" }

  override string getAPrimaryQlClass() { result = "AssignXorExpr" }
}

/**
 * A left-shift assignment operation, for example `x <<= y`.
 */
class AssignLShiftExpr extends AssignBitwiseOperation, @assign_lshift_expr {
  override string getOperator() { result = "<<=" }

  override string getAPrimaryQlClass() { result = "AssignLShiftExpr" }
}

/**
 * A right-shift assignment operation, for example `x >>= y`.
 */
class AssignRShiftExpr extends AssignBitwiseOperation, @assign_rshift_expr {
  override string getOperator() { result = ">>=" }

  override string getAPrimaryQlClass() { result = "AssignRShiftExpr" }
}

/**
 * An event assignment. Either an event addition (`AddEventExpr`) or an event
 * removal (`RemoveEventExpr`).
 */
class AddOrRemoveEventExpr extends AssignOperation, @assign_event_expr {
  /** Gets the event targeted by this event assignment. */
  Event getTarget() { result = this.getLValue().getTarget() }

  override EventAccess getLValue() { result = this.getChild(1) }

  override Expr getRValue() { result = this.getChild(0) }
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
class AssignCoalesceExpr extends AssignOperation, @assign_coalesce_expr {
  override string toString() { result = "... ??= ..." }

  override string getAPrimaryQlClass() { result = "AssignCoalesceExpr" }
}

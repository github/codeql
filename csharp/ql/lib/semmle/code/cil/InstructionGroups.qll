/**
 * Provides classes representing various classes of expression
 * and other instructions.
 */

private import CIL
private import dotnet

/**
 * An instruction that pushes a value onto the stack.
 */
class Expr extends DotNet::Expr, Instruction, @cil_expr {
  override int getPushCount() { result = 1 }

  override Type getType() { result = Instruction.super.getType() }

  override Method getEnclosingCallable() { result = this.getImplementation().getMethod() }

  /**
   * The "parent" of a CIL expression is taken to be the instruction
   * that consumes the value pushed by this instruction.
   */
  override Expr getParent() { this = result.getAnOperand() }
}

/** An instruction that changes control flow. */
class Branch extends Instruction, @cil_jump {
  /** Gets the instruction that is jumped to. */
  Instruction getTarget() { cil_jump(this, result) }

  override string getExtra() { result = this.getTarget().getIndex() + ":" }
}

/** An instruction that unconditionally jumps to another instruction. */
class UnconditionalBranch extends Branch, @cil_unconditional_jump {
  override Instruction getASuccessorType(FlowType t) {
    t instanceof NormalFlow and result = this.getTarget()
  }

  override predicate canFlowNext() { none() }
}

/** An instruction that jumps to a target based on a condition. */
class ConditionalBranch extends Branch, @cil_conditional_jump {
  override Instruction getASuccessorType(FlowType t) {
    t instanceof TrueFlow and result = this.getTarget()
    or
    t instanceof FalseFlow and result = this.getImplementation().getInstruction(this.getIndex() + 1)
  }

  override int getPushCount() { result = 0 }
}

/** An expression with two operands. */
class BinaryExpr extends Expr, @cil_binary_expr {
  override int getPopCount() { result = 2 }
}

/** An expression with one operand. */
class UnaryExpr extends Expr, @cil_unary_expr {
  override int getPopCount() { result = 1 }

  /** Gets the operand of this unary expression. */
  Expr getOperand() { result = this.getOperand(0) }
}

/** A binary expression that compares two values. */
class ComparisonOperation extends BinaryExpr, @cil_comparison_operation {
  override BoolType getType() { exists(result) }
}

/** A binary arithmetic expression. */
class BinaryArithmeticExpr extends BinaryExpr, @cil_binary_arithmetic_operation {
  override Type getType() {
    exists(Type t0, Type t1 |
      t0 = this.getOperandType(0).getUnderlyingType() and
      t1 = this.getOperandType(1).getUnderlyingType()
    |
      t0 = t1 and result = t0
      or
      t0.getConversionIndex() < t1.getConversionIndex() and result = t1
      or
      t0.getConversionIndex() > t1.getConversionIndex() and result = t0
    )
  }
}

/** A binary bitwise expression. */
class BinaryBitwiseOperation extends BinaryExpr, @cil_binary_bitwise_operation {
  // This is wrong but efficient - should depend on the types of the operands.
  override IntType getType() { exists(result) }
}

/** A unary bitwise expression. */
class UnaryBitwiseOperation extends UnaryExpr, @cil_unary_bitwise_operation {
  // This is wrong but efficient - should depend on the types of the operands.
  override IntType getType() { exists(result) }
}

/** A unary expression that converts a value from one primitive type to another. */
class Conversion extends UnaryExpr, @cil_conversion_operation {
  /** Gets the expression being converted. */
  Expr getExpr() { result = this.getOperand(0) }
}

/** A branch that leaves the scope of a `Handler`. */
class Leave extends UnconditionalBranch, @cil_leave_any { }

/** An expression that pushes a literal value onto the stack. */
class Literal extends DotNet::Literal, Expr, @cil_literal {
  /** Gets the pushed value. */
  override string getValue() { cil_value(this, result) }

  override string getExtra() { result = this.getValue() }
}

/** An integer literal. */
class IntLiteral extends Literal, @cil_ldc_i {
  override string getExtra() { none() }

  override IntType getType() { exists(result) }
}

/** An expression that pushes a `float`/`Single`. */
class FloatLiteral extends Literal, @cil_ldc_r { }

/** An expression that pushes a `null` value onto the stack. */
class NullLiteral extends Literal, @cil_ldnull { }

/** An expression that pushes a string onto the stack. */
class StringLiteral extends Literal, @cil_ldstr { }

/** A branch with one operand. */
class UnaryBranch extends ConditionalBranch, @cil_unary_jump {
  override int getPopCount() { result = 1 }

  override int getPushCount() { result = 0 }
}

/** A branch with two operands. */
class BinaryBranch extends ConditionalBranch, @cil_binary_jump {
  override int getPopCount() { result = 2 }

  override int getPushCount() { result = 0 }
}

/** A call. */
class Call extends Expr, DotNet::Call, @cil_call_any {
  /** Gets the method that is called. */
  override Method getTarget() { cil_access(this, result) }

  override Method getARuntimeTarget() { result = this.getTarget().getAnOverrider*() }

  override string getExtra() { result = this.getTarget().getQualifiedName() }

  /**
   * Gets the return type of the call. Methods that do not return a value
   * return the `void` type, `System.Void`, although the value of `getPushCount` is
   * 0 in this case.
   */
  override Type getType() { result = this.getTarget().getReturnType() }

  // The number of items popped/pushed from the stack
  // depends on the target of the call.
  override int getPopCount() { result = this.getTarget().getCallPopCount() }

  override int getPushCount() { result = this.getTarget().getCallPushCount() }

  /**
   * Holds if this is a "tail call", meaning that control does not return to the
   * calling method.
   */
  predicate isTailCall() {
    this.getImplementation().getInstruction(this.getIndex() - 1) instanceof Opcodes::Tail
  }

  /** Holds if this call is virtual and could go to an overriding method. */
  predicate isVirtual() { none() }

  override Expr getRawArgument(int i) { result = this.getOperand(this.getPopCount() - i - 1) }

  /** Gets the qualifier of this call, if any. */
  Expr getQualifier() { result = this.getRawArgument(0) and not this.getTarget().isStatic() }

  override Expr getArgument(int i) {
    if this.getTarget().isStatic()
    then result = this.getRawArgument(i)
    else (
      result = this.getRawArgument(i + 1) and i >= 0
    )
  }

  override Expr getArgumentForParameter(DotNet::Parameter param) {
    exists(int index |
      result = this.getRawArgument(index) and param = this.getTarget().getRawParameter(index)
    )
  }
}

/** A tail call. */
class TailCall extends Call {
  TailCall() { this.isTailCall() }

  override predicate canFlowNext() { none() }
}

/** A call to a static target. */
class StaticCall extends Call {
  StaticCall() { not this.isVirtual() }
}

/** A call to a virtual target. */
class VirtualCall extends Call {
  VirtualCall() { this.isVirtual() }
}

/** A read of an array element. */
class ReadArrayElement extends BinaryExpr, @cil_read_array {
  /** Gets the array being read. */
  Expr getArray() { result = this.getOperand(1) }

  /** Gets the index into the array. */
  Expr getArrayIndex() { result = this.getOperand(0) }
}

/** A write of an array element. */
class WriteArrayElement extends Instruction, @cil_write_array {
  override int getPushCount() { result = 0 }

  override int getPopCount() { result = 3 }
}

/** A `return` statement. */
class Return extends Instruction, @cil_ret {
  /** Gets the expression being returned, if any. */
  Expr getExpr() { result = this.getOperand(0) }

  override predicate canFlowNext() { none() }
}

/** A `throw` statement. */
class Throw extends Instruction, DotNet::Throw, @cil_throw_any {
  override Expr getExpr() { result = this.getOperand(0) }

  /** Gets the type of the exception being thrown. */
  Type getExceptionType() { result = this.getOperandType(0) }

  override predicate canFlowNext() { none() }
}

/** Stores a value at an address/location. */
class StoreIndirect extends Instruction, @cil_stind {
  override int getPopCount() { result = 2 }

  /** Gets the location to store the value at. */
  Expr getAddress() { result = this.getOperand(1) }

  /** Gets the value to store. */
  Expr getExpr() { result = this.getOperand(0) }
}

/** Loads a value from an address/location. */
class LoadIndirect extends UnaryExpr, @cil_ldind { }

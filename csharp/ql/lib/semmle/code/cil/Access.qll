/**
 * Provides classes for accesses.
 *
 * An access is any read or write of a variable.
 */

private import CIL

/** An instruction that accesses a variable. */
deprecated class Access extends Instruction, @cil_access {
  /** Gets the declaration referenced by this instruction. */
  Variable getTarget() { cil_access(this, result) }
}

/**
 * An instruction that accesses a variable.
 * This class is provided for consistency with the C# data model.
 */
deprecated class VariableAccess extends Access, @cil_access { }

/** An instruction that reads a variable. */
deprecated class ReadAccess extends VariableAccess, Expr, @cil_read_access {
  override Type getType() { result = this.getTarget().getType() }
}

/** An instruction yielding an address. */
deprecated class ReadRef extends Expr, @cil_read_ref { }

/** An instruction that reads the address of a variable. */
deprecated class ReadRefAccess extends ReadAccess, ReadRef { }

/** An instruction that writes a variable. */
deprecated class WriteAccess extends VariableAccess, @cil_write_access {
  /** Gets the expression whose value is used in this variable write. */
  Expr getExpr() { none() }
}

/** An instruction that accesses a parameter. */
deprecated class ParameterAccess extends StackVariableAccess, @cil_arg_access {
  override MethodParameter getTarget() { result = StackVariableAccess.super.getTarget() }
}

/** An instruction that reads a parameter. */
deprecated class ParameterReadAccess extends ParameterAccess, ReadAccess {
  override int getPopCount() { result = 0 }
}

/** An instruction that writes to a parameter. */
deprecated class ParameterWriteAccess extends ParameterAccess, WriteAccess {
  override int getPopCount() { result = 1 }

  override Expr getExpr() { result = this.getOperand(0) }
}

/** An access to the `this` parameter. */
deprecated class ThisAccess extends ParameterReadAccess {
  ThisAccess() { this.getTarget() instanceof ThisParameter }
}

/** An instruction that accesses a stack variable. */
deprecated class StackVariableAccess extends VariableAccess, @cil_stack_access {
  override StackVariable getTarget() { result = VariableAccess.super.getTarget() }
}

/** An instruction that accesses a local variable. */
deprecated class LocalVariableAccess extends StackVariableAccess, @cil_local_access {
  override LocalVariable getTarget() { result = StackVariableAccess.super.getTarget() }
}

/** An instruction that writes to a local variable. */
deprecated class LocalVariableWriteAccess extends LocalVariableAccess, WriteAccess {
  override int getPopCount() { result = 1 }

  override Expr getExpr() { result = this.getOperand(0) }

  override string getExtra() { result = "L" + this.getTarget().getIndex() }
}

/** An instruction that reads a local variable. */
deprecated class LocalVariableReadAccess extends LocalVariableAccess, ReadAccess {
  override int getPopCount() { result = 0 }
}

/** An instruction that accesses a field. */
deprecated class FieldAccess extends VariableAccess, @cil_field_access {
  override Field getTarget() { result = VariableAccess.super.getTarget() }

  override string getExtra() { result = this.getTarget().getName() }

  /** Gets the qualifier of the access, if any. */
  abstract Expr getQualifier();
}

/** An instruction that reads a field. */
abstract deprecated class FieldReadAccess extends FieldAccess, ReadAccess { }

/** An instruction that writes a field. */
abstract deprecated class FieldWriteAccess extends FieldAccess, WriteAccess { }

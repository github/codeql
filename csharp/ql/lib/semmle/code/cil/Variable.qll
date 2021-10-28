/**
 * Provides classes for variables.
 */

private import CIL
private import dotnet

/** A variable. Either a stack variable (`StackVariable`) or a field (`Field`). */
class Variable extends DotNet::Variable, Declaration, DataFlowNode, @cil_variable {
  /** Gets the type of this variable. */
  override Type getType() { none() }

  /** Gets a textual representation of this variable including type information. */
  override string toStringWithTypes() { none() }

  /** Gets an access to this variable, if any. */
  VariableAccess getAnAccess() { result.getTarget() = this }

  /** Gets a read access to this variable, if any. */
  ReadAccess getARead() { result = this.getAnAccess() }

  /** Gets a write access to this variable, if any. */
  WriteAccess getAWrite() { result = this.getAnAccess() }

  override string toString() { result = Declaration.super.toString() }

  override Location getLocation() { result = Declaration.super.getLocation() }
}

/** A stack variable. Either a local variable (`LocalVariable`) or a parameter (`Parameter`). */
class StackVariable extends Variable, @cil_stack_variable {
  override predicate hasQualifiedName(string qualifier, string name) { none() }
}

/**
 * A local variable.
 *
 * Each method in CIL has a number of typed local variables, in addition to the evaluation stack.
 */
class LocalVariable extends StackVariable, @cil_local_variable {
  override string toString() {
    result =
      "Local variable " + this.getIndex() + " of method " +
        this.getImplementation().getMethod().getName()
  }

  /** Gets the method implementation defining this local variable. */
  MethodImplementation getImplementation() { this = result.getALocalVariable() }

  /** Gets the index number of this local variable. This is not usually significant. */
  int getIndex() { this = this.getImplementation().getLocalVariable(result) }

  override Type getType() { cil_local_variable(this, _, _, result) }

  override Location getLocation() { result = this.getImplementation().getLocation() }

  override Method getMethod() { result = this.getImplementation().getMethod() }
}

/** A parameter of a `Method` or `FunctionPointerType`. */
class Parameter extends DotNet::Parameter, CustomModifierReceiver, @cil_parameter {
  override Parameterizable getDeclaringElement() { cil_parameter(this, result, _, _) }

  /** Gets the index of this parameter. */
  int getIndex() { cil_parameter(this, _, result, _) }

  override string toString() {
    result = "Parameter " + this.getIndex() + " of " + this.getDeclaringElement().getName()
  }

  override Type getType() { cil_parameter(this, _, _, result) }

  /**
   * Holds if this parameter has an "out" flag, meaning that it will
   * be passed by reference and written to.
   */
  predicate hasOutFlag() { cil_parameter_out(this) }

  /**
   * Holds if this parameter has an "in" flag, meaning that it will
   * be passed by reference and may be read from and written to.
   */
  predicate hasInFlag() { cil_parameter_in(this) }

  /** Holds if this parameter has C# `out` semantics. */
  override predicate isOut() { this.hasOutFlag() and not this.hasInFlag() }

  /** Holds if this parameter has C# `ref` semantics. */
  override predicate isRef() { this.hasOutFlag() and this.hasInFlag() }

  override string toStringWithTypes() {
    result = this.getPrefix() + this.getType().toStringWithTypes()
  }

  private string getPrefix() {
    if this.isOut()
    then result = "out "
    else
      if this.isRef()
      then result = "ref "
      else result = ""
  }

  override Location getLocation() { result = this.getDeclaringElement().getLocation() }
}

/** A method parameter. */
class MethodParameter extends Parameter, StackVariable {
  /** Gets the method declaring this parameter. */
  override Method getMethod() { this = result.getARawParameter() }

  override ParameterAccess getAnAccess() { result.getTarget() = this }

  /** Gets a parameter in an overridden method. */
  MethodParameter getOverriddenParameter() {
    result = this.getMethod().getOverriddenMethod().getRawParameter(this.getRawPosition())
  }

  override MethodParameter getUnboundDeclaration() {
    result = this.getMethod().getUnboundDeclaration().getRawParameter(this.getRawPosition())
  }

  override string toString() { result = Parameter.super.toString() }

  override string toStringWithTypes() { result = Parameter.super.toStringWithTypes() }

  override Type getType() { result = Parameter.super.getType() }

  override Location getLocation() { result = Parameter.super.getLocation() }
}

/** A parameter corresponding to `this`. */
class ThisParameter extends MethodParameter {
  ThisParameter() {
    not this.getMethod().isStatic() and
    this.getIndex() = 0
  }
}

/** A field. */
class Field extends DotNet::Field, Variable, Member, CustomModifierReceiver, @cil_field {
  override string toString() { result = this.getName() }

  override string toStringWithTypes() {
    result = this.getDeclaringType().toStringWithTypes() + "." + this.getName()
  }

  override string getName() { cil_field(this, _, result, _) }

  override Type getType() { cil_field(this, _, _, result) }

  override ValueOrRefType getDeclaringType() { cil_field(this, result, _, _) }

  override Location getLocation() { result = this.getDeclaringType().getLocation() }
}

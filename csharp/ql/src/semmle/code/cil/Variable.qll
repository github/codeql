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
  ReadAccess getARead() { result = getAnAccess() }

  /** Gets a write access to this variable, if any. */
  WriteAccess getAWrite() { result = getAnAccess() }

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
      "Local variable " + getIndex() + " of method " + getImplementation().getMethod().getName()
  }

  /** Gets the method implementation defining this local variable. */
  MethodImplementation getImplementation() { this = result.getALocalVariable() }

  /** Gets the index number of this local variable. This is not usually significant. */
  int getIndex() { this = getImplementation().getLocalVariable(result) }

  override Type getType() { cil_local_variable(this, _, _, result) }

  override Location getLocation() { result = getImplementation().getLocation() }

  override Method getMethod() { result = getImplementation().getMethod() }
}

/** A method parameter. */
class Parameter extends DotNet::Parameter, StackVariable, @cil_parameter {
  /** Gets the method declaring this parameter. */
  override Method getMethod() { this = result.getARawParameter() }

  override Method getCallable() { result = getMethod() }

  /** Gets the index of this parameter. */
  int getIndex() { cil_parameter(this, _, result, _) }

  override string toString() { result = "Parameter " + getIndex() + " of " + getMethod().getName() }

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
  override predicate isOut() { hasOutFlag() and not hasInFlag() }

  /** Holds if this parameter has C# `ref` semantics. */
  override predicate isRef() { hasOutFlag() and hasInFlag() }

  override string toStringWithTypes() { result = getPrefix() + getType().toStringWithTypes() }

  private string getPrefix() {
    if isOut()
    then result = "out "
    else
      if isRef()
      then result = "ref "
      else result = ""
  }

  override Location getLocation() { result = getMethod().getLocation() }

  override ParameterAccess getAnAccess() { result.getTarget() = this }

  /** Gets a parameter in an overridden method. */
  Parameter getOverriddenParameter() {
    result = getMethod().getOverriddenMethod().getRawParameter(getRawPosition())
  }

  override Parameter getSourceDeclaration() {
    result = getMethod().getSourceDeclaration().getRawParameter(getRawPosition())
  }
}

/** A parameter corresponding to `this`. */
class ThisParameter extends Parameter {
  ThisParameter() {
    not this.getMethod().isStatic() and
    this.getIndex() = 0
  }
}

/** A field. */
class Field extends DotNet::Field, Variable, Member, @cil_field {
  override string toString() { result = getName() }

  override string toStringWithTypes() {
    result = getDeclaringType().toStringWithTypes() + "." + getName()
  }

  override string getName() { cil_field(this, _, result, _) }

  override Type getType() { cil_field(this, _, _, result) }

  override ValueOrRefType getDeclaringType() { cil_field(this, result, _, _) }

  override Location getLocation() { result = getDeclaringType().getLocation() }
}

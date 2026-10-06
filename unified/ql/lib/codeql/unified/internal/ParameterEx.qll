/**
 * Provides logic for synthesizing parameters.
 */

private import unified
private import AstPlugin
private import NameBinding

private newtype TParameterEx =
  TAstParameter(Parameter p) or
  TImplicitReceiverParameter(Callable c) {
    exists(LocalVariable v | v.isImplicitReceiverParameter(c))
  } or
  TDefaultConstructorParameter(ConstructorDeclaration cd, int i, string name) {
    cd.hasModifier("generated") and
    defaultConstructorParameter(cd, i, name)
  }

final class ParameterEx = ParameterExImpl;

/**
 * A parameter from source code or a synthesized parameter.
 */
abstract private class ParameterExImpl extends TParameterEx {
  /**
   * Gets the source code parameter that this entity represents, if any.
   */
  Parameter asParameter() { this = TAstParameter(result) }

  /**
   * Holds if this entity represents a regular parameter from source code.
   */
  predicate isParameter() { exists(this.asParameter()) }

  /**
   * Holds if this entity represents an implicit receiver parameter of `c`.
   */
  predicate isImplicitReceiverParameter(Callable c) { this = TImplicitReceiverParameter(c) }

  /**
   * Holds if this entity represents the `i`th parameter of the default
   * constructor `cd` with name `name`.
   */
  predicate isDefaultConstructorParameter(ConstructorDeclaration cd, int i, string name) {
    this = TDefaultConstructorParameter(cd, i, name)
  }

  /** Gets the callable that this parameter belongs to. */
  Callable getCallable() {
    this.asParameter() =
      [
        result.(FunctionDeclaration).getAParameter(),
        result.(ConstructorDeclaration).getAParameter(),
        result.(AccessorDeclaration).getAParameter(),
        result.(FunctionExpr).getAParameter()
      ]
    or
    this.isImplicitReceiverParameter(result)
    or
    this.isDefaultConstructorParameter(result, _, _)
  }

  /** Gets a textual representation of this parameter. */
  abstract string toString();

  /** Gets the location of this parameter. */
  abstract Location getLocation();
}

private class AstParameterEx extends ParameterExImpl, TAstParameter {
  Parameter p;

  AstParameterEx() { this = TAstParameter(p) }

  override string toString() { result = p.toString() }

  override Location getLocation() { result = p.getLocation() }
}

private class ImplicitReceiverParameterEx extends ParameterExImpl, TImplicitReceiverParameter {
  Callable c;

  ImplicitReceiverParameterEx() { this = TImplicitReceiverParameter(c) }

  override string toString() {
    exists(LocalVariable v |
      v.isImplicitReceiverParameter(c) and
      result = v.getName()
    )
  }

  override Location getLocation() { result = c.getLocation() }
}

private class DefaultConstructorParameterEx extends ParameterExImpl, TDefaultConstructorParameter {
  ConstructorDeclaration cd;
  int i;
  string name;

  DefaultConstructorParameterEx() { this = TDefaultConstructorParameter(cd, i, name) }

  override string toString() { result = name + " [" + cd.getName() + " default constructor]" }

  override Location getLocation() { result = cd.getLocation() }
}

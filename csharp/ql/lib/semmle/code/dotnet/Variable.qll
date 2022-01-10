/** Provides classes for .Net variables, such as fields and parameters. */

import Declaration
import Callable

/** A .Net variable. */
class Variable extends Declaration, @dotnet_variable {
  /** Gets the type of this variable. */
  Type getType() { none() }
}

/** A .Net field. */
class Field extends Variable, Member, @dotnet_field { }

/** A parameter to a .Net callable, property or function pointer type. */
class Parameter extends Variable, @dotnet_parameter {
  /** Gets the raw position of this parameter, including the `this` parameter at index 0. */
  final int getRawPosition() { this = this.getDeclaringElement().getRawParameter(result) }

  /** Gets the position of this parameter, excluding the `this` parameter. */
  int getPosition() { this = this.getDeclaringElement().getParameter(result) }

  /** Gets the callable defining this parameter, if any. */
  Callable getCallable() { result = this.getDeclaringElement() }

  /** Gets the declaring `Parameterizable`. */
  Parameterizable getDeclaringElement() { none() }

  /** Holds if this is an `out` parameter. */
  predicate isOut() { none() }

  /** Holds if this is a `ref` parameter. */
  predicate isRef() { none() }
}

/**
 * Provides a general parameterizable entity to represent constructs that might
 * have parameters.
 */

import Declaration

/**
 * A general parameterizable entity, such as a callable, delegate type, accessor,
 * indexer, or function pointer type.
 */
class Parameterizable extends Declaration, @dotnet_parameterizable {
  /** Gets raw parameter `i`, including the `this` parameter at index 0. */
  Parameter getRawParameter(int i) { none() }

  /** Gets the `i`th parameter, excluding the `this` parameter. */
  Parameter getParameter(int i) { none() }

  /** Gets the number of parameters of this callable. */
  int getNumberOfParameters() { result = count(this.getAParameter()) }

  /** Holds if this declaration has no parameters. */
  predicate hasNoParameters() { not exists(this.getAParameter()) }

  /** Gets a parameter, if any. */
  Parameter getAParameter() { result = this.getParameter(_) }

  /** Gets a raw parameter (including the qualifier), if any. */
  final Parameter getARawParameter() { result = this.getRawParameter(_) }
}

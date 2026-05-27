/**
 * This module provides a hand-modifiable wrapper around the generated class `ParamBase`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.ParamBase
private import codeql.rust.elements.Callable

/**
 * INTERNAL: This module contains the customizable definition of `ParamBase` and should not
 * be referenced directly.
 */
module Impl {
  /**
   * A normal parameter, `Param`, or a self parameter `SelfParam`.
   */
  class ParamBase extends Generated::ParamBase {
    /** Gets the callable this parameter belongs to. */
    Callable getCallable() { this = result.getParamList().getAParamBase() }
  }
}

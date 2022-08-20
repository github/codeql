/**
 * Provides an implementation class modeling the POSIX function `getenv`.
 */

import cpp
import semmle.code.cpp.models.interfaces.FlowSource

/**
 * The POSIX function `getenv`.
 */
class Getenv extends LocalFlowSourceFunction {
  Getenv() { this.hasGlobalOrStdOrBslName("getenv") }

  override predicate hasLocalFlowSource(FunctionOutput output, string description) {
    (
      output.isReturnValueDeref() or
      output.isReturnValue()
    ) and
    description = "an environment variable"
  }
}

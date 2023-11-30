/**
 * Provides an implementation class modeling the POSIX function `getenv` and
 * various similar functions.
 */

import cpp
import semmle.code.cpp.models.interfaces.FlowSource

/**
 * The POSIX function `getenv`, the GNU function `secure_getenv`, and the
 * Windows function `_wgetenv`.
 */
class Getenv extends LocalFlowSourceFunction {
  Getenv() {
    this.hasGlobalOrStdOrBslName("getenv") or this.hasGlobalName(["secure_getenv", "_wgetenv"])
  }

  override predicate hasLocalFlowSource(FunctionOutput output, string description) {
    output.isReturnValueDeref() and
    description = "an environment variable"
  }
}

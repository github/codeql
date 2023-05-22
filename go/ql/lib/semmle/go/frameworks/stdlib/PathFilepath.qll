/**
 * Provides classes modeling security-relevant aspects of the `path/filepath` package.
 */

import go

// These are expressed using TaintTracking::FunctionModel because varargs functions don't work with Models-as-Data sumamries yet.
/** Provides models of commonly used functions in the `path/filepath` package. */
module PathFilepath {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func Join(elem ...string) string
      this.hasQualifiedName("path/filepath", "Join") and
      (inp.isParameter(_) and outp.isResult())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}

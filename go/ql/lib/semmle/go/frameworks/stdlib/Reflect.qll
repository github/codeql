/**
 * Provides classes modeling security-relevant aspects of the `reflect` package.
 */

import go

// These are expressed using TaintTracking::FunctionModel because varargs functions don't work with Models-as-Data sumamries yet.
/** Provides models of commonly used functions in the `reflect` package. */
module Reflect {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func Append(s Value, x ...Value) Value
      this.hasQualifiedName("reflect", "Append") and
      (inp.isParameter(_) and outp.isResult())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}

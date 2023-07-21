/**
 * Provides classes modeling security-relevant aspects of the `errors` package.
 */

import go

/** Provides models of commonly used functions in the `errors` package. */
module Errors {
  // These are expressed using TaintTracking::FunctionModel because varargs functions don't work with Models-as-Data sumamries yet.
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func Join(errs ...error) error
      this.hasQualifiedName("errors", "Join") and
      (inp.isParameter(_) and outp.isResult())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}

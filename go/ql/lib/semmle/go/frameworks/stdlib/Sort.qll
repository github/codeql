/**
 * Provides classes modeling security-relevant aspects of the `sort` package.
 */

import go

/** Provides models of commonly used functions in the `sort` package. */
module Sort {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func Reverse(data Interface) Interface
      hasQualifiedName("sort", "Reverse") and
      (inp.isParameter(0) and outp.isResult())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}

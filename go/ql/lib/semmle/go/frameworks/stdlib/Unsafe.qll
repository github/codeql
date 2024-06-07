/**
 * Provides classes modeling security-relevant aspects of the `unsafe` package.
 */

import go

/** Provides models of commonly used functions in the `unsafe` package. */
module Unsafe {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      this.hasQualifiedName("unsafe", ["String", "StringData", "Slice", "SliceData"]) and
      (inp.isParameter(0) and outp.isResult())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}

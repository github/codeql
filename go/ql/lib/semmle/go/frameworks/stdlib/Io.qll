/**
 * Provides classes modeling security-relevant aspects of the `io` package.
 */

import go

// These models are not implemented using Models-as-Data because they represent reverse flow, or are variadic.
/** Provides models of commonly used functions in the `io` package. */
module Io {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func MultiReader(readers ...Reader) Reader
      this.hasQualifiedName("io", "MultiReader") and
      (inp.isParameter(_) and outp.isResult())
      or
      // signature: func MultiWriter(writers ...Writer) Writer
      this.hasQualifiedName("io", "MultiWriter") and
      (inp.isResult() and outp.isParameter(_))
      or
      // signature: func Pipe() (*PipeReader, *PipeWriter)
      this.hasQualifiedName("io", "Pipe") and
      (inp.isResult(1) and outp.isResult(0))
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}

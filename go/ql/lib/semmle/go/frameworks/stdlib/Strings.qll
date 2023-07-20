/**
 * Provides classes modeling security-relevant aspects of the `strings` package.
 */

import go

// These are expressed using TaintTracking::FunctionModel because varargs functions don't work with Models-as-Data sumamries yet.
/** Provides models of commonly used functions in the `strings` package. */
module Strings {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func NewReplacer(oldnew ...string) *Replacer
      this.hasQualifiedName("strings", "NewReplacer") and
      (inp.isParameter(_) and outp.isResult())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}

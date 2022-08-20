/**
 * Provides classes modeling security-relevant aspects of the `path` package.
 */

import go

/** Provides models of commonly used functions in the `path` package. */
module Path {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func Base(path string) string
      hasQualifiedName("path", "Base") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func Clean(path string) string
      hasQualifiedName("path", "Clean") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func Dir(path string) string
      hasQualifiedName("path", "Dir") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func Ext(path string) string
      hasQualifiedName("path", "Ext") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func Join(elem ...string) string
      hasQualifiedName("path", "Join") and
      (inp.isParameter(_) and outp.isResult())
      or
      // signature: func Split(path string) (dir string, file string)
      hasQualifiedName("path", "Split") and
      (inp.isParameter(0) and outp.isResult(_))
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}

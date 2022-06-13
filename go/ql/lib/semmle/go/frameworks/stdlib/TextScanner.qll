/**
 * Provides classes modeling security-relevant aspects of the `text/scanner` package.
 */

import go

/** Provides models of commonly used functions in the `text/scanner` package. */
module TextScanner {
  private class MethodModels extends TaintTracking::FunctionModel, Method {
    FunctionInput inp;
    FunctionOutput outp;

    MethodModels() {
      // signature: func (*Scanner) Init(src io.Reader) *Scanner
      hasQualifiedName("text/scanner", "Scanner", "Init") and
      (
        inp.isParameter(0) and
        (outp.isReceiver() or outp.isResult())
      )
      or
      // signature: func (*Scanner) TokenText() string
      hasQualifiedName("text/scanner", "Scanner", "TokenText") and
      (inp.isReceiver() and outp.isResult())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}

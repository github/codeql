/**
 * Provides classes modeling security-relevant aspects of the `context` package.
 */

import go

/** Provides models of commonly used functions in the `context` package. */
module Context {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func WithCancel(parent Context) (ctx Context, cancel CancelFunc)
      hasQualifiedName("context", "WithCancel") and
      (inp.isParameter(0) and outp.isResult(0))
      or
      // signature: func WithDeadline(parent Context, d time.Time) (Context, CancelFunc)
      hasQualifiedName("context", "WithDeadline") and
      (inp.isParameter(0) and outp.isResult(0))
      or
      // signature: func WithTimeout(parent Context, timeout time.Duration) (Context, CancelFunc)
      hasQualifiedName("context", "WithTimeout") and
      (inp.isParameter(0) and outp.isResult(0))
      or
      // signature: func WithValue(parent Context, key interface{}, val interface{}) Context
      hasQualifiedName("context", "WithValue") and
      (inp.isParameter(_) and outp.isResult())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }

  private class MethodModels extends TaintTracking::FunctionModel, Method {
    FunctionInput inp;
    FunctionOutput outp;

    MethodModels() {
      // signature: func (Context).Value(key interface{}) interface{}
      implements("context", "Context", "Value") and
      (inp.isReceiver() and outp.isResult())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}

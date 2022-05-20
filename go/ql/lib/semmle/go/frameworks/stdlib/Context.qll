/**
 * Provides classes modeling security-relevant aspects of the `context` package.
 */

import go

/** Provides models of commonly used functions in the `context` package. */
module Context {
  /**
   * Gets the package name `context` or `golang.org/x/net/context`.
   *
   * The two packages are identical; before Go 1.7 it was only available
   * under `golang.org/x`; as of Go 1.7 it is included in the standard library.
   */
  private string packagePath() { result = ["context", package("golang.org/x/net", "context")] }

  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func WithCancel(parent Context) (ctx Context, cancel CancelFunc)
      hasQualifiedName(packagePath(), "WithCancel") and
      (inp.isParameter(0) and outp.isResult(0))
      or
      // signature: func WithDeadline(parent Context, d time.Time) (Context, CancelFunc)
      hasQualifiedName(packagePath(), "WithDeadline") and
      (inp.isParameter(0) and outp.isResult(0))
      or
      // signature: func WithTimeout(parent Context, timeout time.Duration) (Context, CancelFunc)
      hasQualifiedName(packagePath(), "WithTimeout") and
      (inp.isParameter(0) and outp.isResult(0))
      or
      // signature: func WithValue(parent Context, key interface{}, val interface{}) Context
      hasQualifiedName(packagePath(), "WithValue") and
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
      // signature: func (Context) Value(key interface{}) interface{}
      implements(packagePath(), "Context", "Value") and
      (inp.isReceiver() and outp.isResult())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}

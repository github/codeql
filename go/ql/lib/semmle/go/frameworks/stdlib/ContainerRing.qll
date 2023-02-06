/**
 * Provides classes modeling security-relevant aspects of the `container/ring` package.
 */

import go

/** Provides models of commonly used functions in the `container/ring` package. */
module ContainerRing {
  private class MethodModels extends TaintTracking::FunctionModel, Method {
    FunctionInput inp;
    FunctionOutput outp;

    MethodModels() {
      // signature: func (*Ring) Link(s *Ring) *Ring
      hasQualifiedName("container/ring", "Ring", "Link") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func (*Ring) Move(n int) *Ring
      hasQualifiedName("container/ring", "Ring", "Move") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (*Ring) Next() *Ring
      hasQualifiedName("container/ring", "Ring", "Next") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (*Ring) Prev() *Ring
      hasQualifiedName("container/ring", "Ring", "Prev") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (*Ring) Unlink(n int) *Ring
      hasQualifiedName("container/ring", "Ring", "Unlink") and
      (inp.isReceiver() and outp.isResult())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}

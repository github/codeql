/**
 * Provides classes modeling security-relevant aspects of the `container/heap` package.
 */

import go

/** Provides models of commonly used functions in the `container/heap` package. */
module ContainerHeap {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func Pop(h Interface) interface{}
      hasQualifiedName("container/heap", "Pop") and
      (inp.isParameter(0) and outp.isResult())
      or
      // signature: func Push(h Interface, x interface{})
      hasQualifiedName("container/heap", "Push") and
      (inp.isParameter(1) and outp.isParameter(0))
      or
      // signature: func Remove(h Interface, i int) interface{}
      hasQualifiedName("container/heap", "Remove") and
      (inp.isParameter(0) and outp.isResult())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }

  private class MethodModels extends TaintTracking::FunctionModel, Method {
    FunctionInput inp;
    FunctionOutput outp;

    MethodModels() {
      // signature: func (Interface) Pop() interface{}
      implements("container/heap", "Interface", "Pop") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (Interface) Push(x interface{})
      implements("container/heap", "Interface", "Push") and
      (inp.isParameter(0) and outp.isReceiver())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}

/**
 * Provides classes modeling security-relevant aspects of the `sync` package.
 */

import go

/** Provides models of commonly used functions in the `sync` package. */
module Sync {
  private class MethodModels extends TaintTracking::FunctionModel, Method {
    FunctionInput inp;
    FunctionOutput outp;

    MethodModels() {
      // signature: func (*Map) Load(key interface{}) (value interface{}, ok bool)
      hasQualifiedName("sync", "Map", "Load") and
      (inp.isReceiver() and outp.isResult(0))
      or
      // signature: func (*Map) LoadOrStore(key interface{}, value interface{}) (actual interface{}, loaded bool)
      hasQualifiedName("sync", "Map", "LoadOrStore") and
      (
        inp.isReceiver() and outp.isResult(0)
        or
        inp.isParameter(_) and
        (outp.isReceiver() or outp.isResult(0))
      )
      or
      // signature: func (*Map) Store(key interface{}, value interface{})
      hasQualifiedName("sync", "Map", "Store") and
      (inp.isParameter(_) and outp.isReceiver())
      or
      // signature: func (*Pool) Get() interface{}
      hasQualifiedName("sync", "Pool", "Get") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (*Pool) Put(x interface{})
      hasQualifiedName("sync", "Pool", "Put") and
      (inp.isParameter(0) and outp.isReceiver())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}

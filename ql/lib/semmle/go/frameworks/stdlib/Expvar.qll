/**
 * Provides classes modeling security-relevant aspects of the `expvar` package.
 */

import go

/** Provides models of commonly used functions in the `expvar` package. */
module Expvar {
  private class MethodModels extends TaintTracking::FunctionModel, Method {
    FunctionInput inp;
    FunctionOutput outp;

    MethodModels() {
      // signature: func (Func) Value() interface{}
      hasQualifiedName("expvar", "Func", "Value") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (*Map) Get(key string) Var
      hasQualifiedName("expvar", "Map", "Get") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (*Map) Set(key string, av Var)
      hasQualifiedName("expvar", "Map", "Set") and
      (inp.isParameter(_) and outp.isReceiver())
      or
      // signature: func (*String) Set(value string)
      hasQualifiedName("expvar", "String", "Set") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (*String) Value() string
      hasQualifiedName("expvar", "String", "Value") and
      (inp.isReceiver() and outp.isResult())
      or
      // signature: func (Var) String() string
      implements("expvar", "Var", "String") and
      (inp.isReceiver() and outp.isResult())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}

/**
 * Provides classes modeling security-relevant aspects of the `crypto` package.
 */

import go

/** Provides models of commonly used functions in the `crypto` package. */
module Crypto {
  private class MethodModels extends TaintTracking::FunctionModel, Method {
    FunctionInput inp;
    FunctionOutput outp;

    MethodModels() {
      // signature: func (Decrypter) Decrypt(rand io.Reader, msg []byte, opts DecrypterOpts) (plaintext []byte, err error)
      implements("crypto", "Decrypter", "Decrypt") and
      (inp.isParameter(1) and outp.isResult(0))
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}

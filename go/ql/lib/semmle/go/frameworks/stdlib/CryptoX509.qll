/**
 * Provides classes modeling security-relevant aspects of the `crypto/x509` package.
 */

import go

/** Provides models of commonly used functions in the `crypto/x509` package. */
module CryptoX509 {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func DecryptPEMBlock(b *encoding/pem.Block, password []byte) ([]byte, error)
      hasQualifiedName("crypto/x509", "DecryptPEMBlock") and
      (inp.isParameter(0) and outp.isResult(0))
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}

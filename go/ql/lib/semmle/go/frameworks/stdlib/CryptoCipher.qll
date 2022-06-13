/**
 * Provides classes modeling security-relevant aspects of the `crypto/cipher` package.
 */

import go

/** Provides models of commonly used functions in the `crypto/cipher` package. */
module CryptoCipher {
  private class MethodModels extends TaintTracking::FunctionModel, Method {
    FunctionInput inp;
    FunctionOutput outp;

    MethodModels() {
      // signature: func (Block) Decrypt(dst []byte, src []byte)
      implements("crypto/cipher", "Block", "Decrypt") and
      (inp.isParameter(1) and outp.isParameter(0))
      or
      // signature: func (AEAD) Open(dst []byte, nonce []byte, ciphertext []byte, additionalData []byte) ([]byte, error)
      implements("crypto/cipher", "AEAD", "Open") and
      (
        inp.isParameter(2) and
        (outp.isParameter(0) or outp.isResult(0))
      )
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}

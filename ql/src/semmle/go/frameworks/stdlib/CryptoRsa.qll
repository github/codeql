/**
 * Provides classes modeling security-relevant aspects of the `crypto/rsa` package.
 */

import go

/** Provides models of commonly used functions in the `crypto/rsa` package. */
module CryptoRsa {
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func DecryptOAEP(hash hash.Hash, random io.Reader, priv *PrivateKey, ciphertext []byte, label []byte) ([]byte, error)
      hasQualifiedName("crypto/rsa", "DecryptOAEP") and
      (inp.isParameter(3) and outp.isResult(0))
      or
      // signature: func DecryptPKCS1v15(rand io.Reader, priv *PrivateKey, ciphertext []byte) ([]byte, error)
      hasQualifiedName("crypto/rsa", "DecryptPKCS1v15") and
      (inp.isParameter(2) and outp.isResult(0))
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }

  private class MethodModels extends TaintTracking::FunctionModel, Method {
    FunctionInput inp;
    FunctionOutput outp;

    MethodModels() {
      // signature: func (*PrivateKey) Decrypt(rand io.Reader, ciphertext []byte, opts crypto.DecrypterOpts) (plaintext []byte, err error)
      hasQualifiedName("crypto/rsa", "PrivateKey", "Decrypt") and
      (inp.isParameter(1) and outp.isResult(0))
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}

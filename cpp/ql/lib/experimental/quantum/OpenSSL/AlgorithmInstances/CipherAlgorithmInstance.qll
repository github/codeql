import cpp
private import experimental.quantum.Language
private import KnownAlgorithmConstants
private import Crypto::KeyOpAlg as KeyOpAlg
private import OpenSSLAlgorithmInstanceBase
private import PaddingAlgorithmInstance
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumerBase
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.DirectAlgorithmValueConsumer
private import AlgToAVCFlow
private import BlockAlgorithmInstance

/**
 * Given a `KnownOpenSslCipherAlgorithmExpr`, converts this to a cipher family type.
 * Does not bind if there is no mapping (no mapping to 'unknown' or 'other').
 */
predicate knownOpenSslConstantToCipherFamilyType(
  KnownOpenSslCipherAlgorithmExpr e, Crypto::KeyOpAlg::TAlgorithm type
) {
  exists(string name |
    name = e.(KnownOpenSslAlgorithmExpr).getNormalizedName() and
    (
      name.matches("AES%") and type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::AES())
      or
      name.matches("ARIA%") and type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::ARIA())
      or
      name.matches("BLOWFISH%") and type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::BLOWFISH())
      or
      name.matches("BF%") and type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::BLOWFISH())
      or
      name.matches("CAMELLIA%") and type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::CAMELLIA())
      or
      name.matches("CHACHA20%") and type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::CHACHA20())
      or
      name.matches("CAST5%") and type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::CAST5())
      or
      name.matches("2DES%") and type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::DOUBLE_DES())
      or
      name.matches("3DES%") and type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::TRIPLE_DES())
      or
      name.matches("DES%") and type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::DES())
      or
      name.matches("DESX%") and type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::DESX())
      or
      name.matches("GOST%") and type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::GOST())
      or
      name.matches("IDEA%") and type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::IDEA())
      or
      name.matches("KUZNYECHIK%") and type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::KUZNYECHIK())
      or
      name.matches("MAGMA%") and type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::MAGMA())
      or
      name.matches("RC2%") and type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::RC2())
      or
      name.matches("RC4%") and type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::RC4())
      or
      name.matches("RC5%") and type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::RC5())
      or
      name.matches("RSA%") and type = KeyOpAlg::TAsymmetricCipher(KeyOpAlg::RSA())
      or
      name.matches("SEED%") and type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::SEED())
      or
      name.matches("SM4%") and type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::SM4())
    )
  )
}

class KnownOpenSslCipherConstantAlgorithmInstance extends OpenSslAlgorithmInstance,
  Crypto::KeyOperationAlgorithmInstance instanceof KnownOpenSslCipherAlgorithmExpr
{
  OpenSslAlgorithmValueConsumer getterCall;

  KnownOpenSslCipherConstantAlgorithmInstance() {
    // Two possibilities:
    // 1) The source is a literal and flows to a getter, then we know we have an instance
    // 2) The source is a KnownOpenSslAlgorithm is call, and we know we have an instance immediately from that
    // Possibility 1:
    this instanceof OpenSslAlgorithmLiteral and
    exists(DataFlow::Node src, DataFlow::Node sink |
      // Sink is an argument to a CipherGetterCall
      sink = getterCall.getInputNode() and
      // Source is `this`
      src.asExpr() = this and
      // This traces to a getter
      KnownOpenSslAlgorithmToAlgorithmValueConsumerFlow::flow(src, sink)
    )
    or
    // Possibility 2:
    this instanceof OpenSslAlgorithmCall and
    getterCall = this
  }

  override Crypto::ModeOfOperationAlgorithmInstance getModeOfOperationAlgorithm() {
    // if there is a block mode associated with the same element, then that's the block mode
    // note, if none are associated, we may need to parse if the cipher is a block cipher
    // to determine if this is an unknown vs not relevant.
    result = this
  }

  override Crypto::PaddingAlgorithmInstance getPaddingAlgorithm() {
    //TODO: the padding is either self, or it flows through getter ctx to a set padding call
    // like EVP_PKEY_CTX_set_rsa_padding
    result = this
    // TODO or trace through getter ctx to set padding
  }

  override string getRawAlgorithmName() {
    result = this.(Literal).getValue().toString()
    or
    result = this.(Call).getTarget().getName()
  }

  override int getKeySizeFixed() {
    this.(KnownOpenSslCipherAlgorithmExpr).getExplicitKeySize() = result
  }

  override KeyOpAlg::AlgorithmType getAlgorithmType() {
    knownOpenSslConstantToCipherFamilyType(this, result)
    or
    not knownOpenSslConstantToCipherFamilyType(this, _) and
    result = Crypto::KeyOpAlg::TUnknownKeyOperationAlgorithmType()
  }

  override OpenSslAlgorithmValueConsumer getAvc() { result = getterCall }

  override Crypto::ConsumerInputDataFlowNode getKeySizeConsumer() {
    // TODO: trace to any key size initializer, symmetric and asymmetric
    none()
  }
}

import cpp
private import experimental.quantum.Language
private import KnownAlgorithmConstants
private import Crypto::KeyOpAlg as KeyOpAlg
private import experimental.quantum.OpenSSL.Operations.OpenSSLOperationBase
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumers
private import OpenSSLAlgorithmInstances
private import AlgToAVCFlow

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
      name.startsWith("AES") and type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::AES())
      or
      name.startsWith("ARIA") and type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::ARIA())
      or
      name.startsWith("BLOWFISH") and type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::BLOWFISH())
      or
      name.startsWith("BF") and type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::BLOWFISH())
      or
      name.startsWith("CAMELLIA") and type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::CAMELLIA())
      or
      name.startsWith("CHACHA20") and type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::CHACHA20())
      or
      name.startsWith("CAST5") and type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::CAST5())
      or
      name.startsWith("2DES") and type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::DOUBLE_DES())
      or
      name.startsWith("3DES") and type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::TRIPLE_DES())
      or
      name.startsWith("DES") and type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::DES())
      or
      name.startsWith("DESX") and type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::DESX())
      or
      name.startsWith("GOST") and type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::GOST())
      or
      name.startsWith("IDEA") and type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::IDEA())
      or
      name.startsWith("KUZNYECHIK") and type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::KUZNYECHIK())
      or
      name.startsWith("MAGMA") and type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::MAGMA())
      or
      name.startsWith("RC2") and type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::RC2())
      or
      name.startsWith("RC4") and type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::RC4())
      or
      name.startsWith("RC5") and type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::RC5())
      or
      name.startsWith("RSA") and type = KeyOpAlg::TAsymmetricCipher(KeyOpAlg::RSA())
      or
      name.startsWith("SEED") and type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::SEED())
      or
      name.startsWith("SM4") and type = KeyOpAlg::TSymmetricCipher(KeyOpAlg::SM4())
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
      // NOTE: src literals can be ints or strings, so need to consider asExpr and asIndirectExpr
      this = [src.asExpr(), src.asIndirectExpr()] and
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
    result = this
    or
    exists(OperationStep s |
      this.getAvc().(AvcContextCreationStep).flowsToOperationStep(s) and
      s.getAlgorithmValueConsumerForInput(PaddingAlgorithmIO()) =
        result.(OpenSslAlgorithmInstance).getAvc()
    )
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
    result = Crypto::KeyOpAlg::TOtherKeyOperationAlgorithmType()
  }

  override OpenSslAlgorithmValueConsumer getAvc() { result = getterCall }

  override Crypto::ConsumerInputDataFlowNode getKeySizeConsumer() {
    // TODO: trace to any key size initializer, symmetric and asymmetric
    none()
  }
}

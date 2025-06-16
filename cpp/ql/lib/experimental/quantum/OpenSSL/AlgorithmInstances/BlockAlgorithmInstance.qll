import cpp
private import experimental.quantum.Language
private import OpenSSLAlgorithmInstanceBase
private import experimental.quantum.OpenSSL.AlgorithmInstances.KnownAlgorithmConstants
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.DirectAlgorithmValueConsumer
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumerBase
private import AlgToAVCFlow

/**
 * Given a `KnownOpenSslBlockModeAlgorithmExpr`, converts this to a block family type.
 * Does not bind if there is no mapping (no mapping to 'unknown' or 'other').
 */
predicate knownOpenSslConstantToBlockModeFamilyType(
  KnownOpenSslBlockModeAlgorithmExpr e, Crypto::TBlockCipherModeOfOperationType type
) {
  exists(string name |
    name = e.(KnownOpenSslAlgorithmExpr).getNormalizedName() and
    (
      name.matches("CBC") and type instanceof Crypto::CBC
      or
      name.matches("CFB%") and type instanceof Crypto::CFB
      or
      name.matches("CTR") and type instanceof Crypto::CTR
      or
      name.matches("GCM") and type instanceof Crypto::GCM
      or
      name.matches("OFB") and type instanceof Crypto::OFB
      or
      name.matches("XTS") and type instanceof Crypto::XTS
      or
      name.matches("CCM") and type instanceof Crypto::CCM
      or
      name.matches("GCM") and type instanceof Crypto::GCM
      or
      name.matches("CCM") and type instanceof Crypto::CCM
      or
      name.matches("ECB") and type instanceof Crypto::ECB
    )
  )
}

class KnownOpenSslBlockModeConstantAlgorithmInstance extends OpenSslAlgorithmInstance,
  Crypto::ModeOfOperationAlgorithmInstance instanceof KnownOpenSslBlockModeAlgorithmExpr
{
  OpenSslAlgorithmValueConsumer getterCall;

  KnownOpenSslBlockModeConstantAlgorithmInstance() {
    // Two possibilities:
    // 1) The source is a literal and flows to a getter, then we know we have an instance
    // 2) The source is a KnownOpenSslAlgorithm is call, and we know we have an instance immediately from that
    // Possibility 1:
    this instanceof OpenSslAlgorithmLiteral and
    exists(DataFlow::Node src, DataFlow::Node sink |
      // Sink is an argument to a CipherGetterCall
      sink = getterCall.(OpenSslAlgorithmValueConsumer).getInputNode() and
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

  override Crypto::TBlockCipherModeOfOperationType getModeType() {
    knownOpenSslConstantToBlockModeFamilyType(this, result)
    or
    not knownOpenSslConstantToBlockModeFamilyType(this, _) and result = Crypto::OtherMode()
  }

  // NOTE: I'm not going to attempt to parse out the mode specific part, so returning
  // the same as the raw name for now.
  override string getRawModeAlgorithmName() {
    result = this.(Literal).getValue().toString()
    or
    result = this.(Call).getTarget().getName()
  }

  override OpenSslAlgorithmValueConsumer getAvc() { result = getterCall }
}

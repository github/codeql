import cpp
private import experimental.quantum.Language
private import OpenSSLAlgorithmInstanceBase
private import experimental.quantum.OpenSSL.AlgorithmInstances.KnownAlgorithmConstants
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.DirectAlgorithmValueConsumer
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumerBase
private import AlgToAVCFlow

/**
 * Given a `KnownOpenSSLBlockModeAlgorithmConstant`, converts this to a block family type.
 * Does not bind if there is know mapping (no mapping to 'unknown' or 'other').
 */
predicate knownOpenSSLConstantToBlockModeFamilyType(
  KnownOpenSSLBlockModeAlgorithmConstant e, Crypto::TBlockCipherModeOfOperationType type
) {
  exists(string name |
    name = e.getNormalizedName() and
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

class KnownOpenSSLBlockModeConstantAlgorithmInstance extends OpenSSLAlgorithmInstance,
  Crypto::ModeOfOperationAlgorithmInstance instanceof KnownOpenSSLBlockModeAlgorithmConstant
{
  OpenSSLAlgorithmValueConsumer getterCall;

  KnownOpenSSLBlockModeConstantAlgorithmInstance() {
    // Two possibilities:
    // 1) The source is a literal and flows to a getter, then we know we have an instance
    // 2) The source is a KnownOpenSSLAlgorithm is call, and we know we have an instance immediately from that
    // Possibility 1:
    this instanceof Literal and
    exists(DataFlow::Node src, DataFlow::Node sink |
      // Sink is an argument to a CipherGetterCall
      sink = getterCall.(OpenSSLAlgorithmValueConsumer).getInputNode() and
      // Source is `this`
      src.asExpr() = this and
      // This traces to a getter
      KnownOpenSSLAlgorithmToAlgorithmValueConsumerFlow::flow(src, sink)
    )
    or
    // Possibility 2:
    this instanceof DirectAlgorithmValueConsumer and getterCall = this
  }

  override Crypto::TBlockCipherModeOfOperationType getModeType() {
    knownOpenSSLConstantToBlockModeFamilyType(this, result)
    or
    not knownOpenSSLConstantToBlockModeFamilyType(this, _) and result = Crypto::OtherMode()
  }

  // NOTE: I'm not going to attempt to parse out the mode specific part, so returning
  // the same as the raw name for now.
  override string getRawModeAlgorithmName() { result = this.(Literal).getValue().toString() }

  override OpenSSLAlgorithmValueConsumer getAVC() { result = getterCall }
}

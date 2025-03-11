import cpp
import experimental.Quantum.Language
import EVPCipherConsumers
import OpenSSLAlgorithmGetter

/**
 * Given a `KnownOpenSSLAlgorithmConstant`, converts this to a cipher family type.
 * Does not bind if there is know mapping (no mapping to 'unknown' or 'other').
 */
predicate knownOpenSSLConstantToCipherFamilyType(
  KnownOpenSSLAlgorithmConstant e, Crypto::TCipherType type
) {
  exists(string name | e.getAlgType().toLowerCase().matches("%encryption") |
    name = e.getNormalizedName() and
    (
      name.matches("AES%") and type instanceof Crypto::AES
      or
      name.matches("ARIA") and type instanceof Crypto::ARIA
      or
      name.matches("BLOWFISH") and type instanceof Crypto::BLOWFISH
      or
      name.matches("BF") and type instanceof Crypto::BLOWFISH
      or
      name.matches("CAMELLIA%") and type instanceof Crypto::CAMELLIA
      or
      name.matches("CHACHA20") and type instanceof Crypto::CHACHA20
      or
      name.matches("CAST5") and type instanceof Crypto::CAST5
      or
      name.matches("2DES") and type instanceof Crypto::DoubleDES
      or
      name.matches(["3DES", "TRIPLEDES"]) and type instanceof Crypto::TripleDES
      or
      name.matches("DES") and type instanceof Crypto::DES
      or
      name.matches("DESX") and type instanceof Crypto::DESX
      or
      name.matches("GOST%") and type instanceof Crypto::GOST
      or
      name.matches("IDEA") and type instanceof Crypto::IDEA
      or
      name.matches("KUZNYECHIK") and type instanceof Crypto::KUZNYECHIK
      or
      name.matches("MAGMA") and type instanceof Crypto::MAGMA
      or
      name.matches("RC2") and type instanceof Crypto::RC2
      or
      name.matches("RC4") and type instanceof Crypto::RC4
      or
      name.matches("RC5") and type instanceof Crypto::RC5
      or
      name.matches("RSA") and type instanceof Crypto::RSA
      or
      name.matches("SEED") and type instanceof Crypto::SEED
      or
      name.matches("SM4") and type instanceof Crypto::SM4
    )
  )
}

class KnownOpenSSLCipherConstantAlgorithmInstance extends Crypto::CipherAlgorithmInstance instanceof KnownOpenSSLAlgorithmConstant
{
  OpenSSLAlgorithmGetterCall getterCall;

  KnownOpenSSLCipherConstantAlgorithmInstance() {
    // Not just any known value, but specifically a known cipher operation
    this.(KnownOpenSSLAlgorithmConstant).getAlgType().toLowerCase().matches("%encryption") and
    (
      // Two possibilities:
      // 1) The source is a literal and flows to a getter, then we know we have an instance
      // 2) The source is a KnownOpenSSLAlgorithm is call, and we know we have an instance immediately from that
      // Possibility 1:
      this instanceof Literal and
      exists(DataFlow::Node src, DataFlow::Node sink |
        // Sink is an argument to a CipherGetterCall
        sink = getterCall.(OpenSSLAlgorithmGetterCall).getValueArgNode() and
        // Source is `this`
        src.asExpr() = this and
        // This traces to a getter
        KnownOpenSSLAlgorithmToAlgorithmGetterFlow::flow(src, sink)
      )
      or
      // Possibility 2:
      this instanceof DirectGetterCall and getterCall = this
    )
  }

  Crypto::AlgorithmConsumer getConsumer() {
    AlgGetterToAlgConsumerFlow::flow(getterCall.getResultNode(), DataFlow::exprNode(result))
  }

  override Crypto::ModeOfOperationAlgorithmInstance getModeOfOperationAlgorithm() {
    // if there is a block mode associated with the same element, then that's the block mode
    // note, if none are associated, we may need to parse if the cipher is a block cipher
    // to determine if this is an unknown vs not relevant.
    result = this
  }

  override Crypto::PaddingAlgorithmInstance getPaddingAlgorithm() { none() }

  override string getRawAlgorithmName() { result = this.(Literal).getValue().toString() }

  override Crypto::TCipherType getCipherFamily() {
    knownOpenSSLConstantToCipherFamilyType(this, result)
    or
    not knownOpenSSLConstantToCipherFamilyType(this, _) and result = Crypto::OtherCipherType()
  }
}

/**
 * Given a `KnownOpenSSLAlgorithmConstant`, converts this to a cipher family type.
 * Does not bind if there is know mapping (no mapping to 'unknown' or 'other').
 */
predicate knownOpenSSLConstantToBlockModeFamilyType(
  KnownOpenSSLAlgorithmConstant e, Crypto::TBlockCipherModeOperationType type
) {
  exists(string name | e.getAlgType().toLowerCase().matches("block_mode") |
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

class KnownOpenSSLBlockModeConstantAlgorithmInstance extends Crypto::ModeOfOperationAlgorithmInstance instanceof KnownOpenSSLAlgorithmConstant
{
  OpenSSLAlgorithmGetterCall getterCall;

  KnownOpenSSLBlockModeConstantAlgorithmInstance() {
    // Not just any known value, but specifically a known cipher operation
    this.(KnownOpenSSLAlgorithmConstant).getAlgType().toLowerCase().matches("block_mode") and
    (
      // Two possibilities:
      // 1) The source is a literal and flows to a getter, then we know we have an instance
      // 2) The source is a KnownOpenSSLAlgorithm is call, and we know we have an instance immediately from that
      // Possibility 1:
      this instanceof Literal and
      exists(DataFlow::Node src, DataFlow::Node sink |
        // Sink is an argument to a CipherGetterCall
        sink = getterCall.(OpenSSLAlgorithmGetterCall).getValueArgNode() and
        // Source is `this`
        src.asExpr() = this and
        // This traces to a getter
        KnownOpenSSLAlgorithmToAlgorithmGetterFlow::flow(src, sink)
      )
      or
      // Possibility 2:
      this instanceof DirectGetterCall and getterCall = this
    )
  }

  override Crypto::TBlockCipherModeOperationType getModeType() {
    knownOpenSSLConstantToBlockModeFamilyType(this, result)
    or
    not knownOpenSSLConstantToBlockModeFamilyType(this, _) and result = Crypto::OtherMode()
  }

  // NOTE: I'm not going to attempt to parse out the mode specific part, so returning
  // the same as the raw name for now.
  override string getRawModeAlgorithmName() { result = this.(Literal).getValue().toString() }

  override string getRawAlgorithmName() { result = this.getRawModeAlgorithmName() }
}

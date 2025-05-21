import cpp
private import experimental.quantum.Language
private import KnownAlgorithmConstants
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumers
private import experimental.quantum.OpenSSL.AlgorithmInstances.OpenSSLAlgorithmInstanceBase
private import AlgToAVCFlow

predicate knownOpenSSLConstantToHashFamilyType(
  KnownOpenSSLHashAlgorithmConstant e, Crypto::THashType type
) {
  exists(string name |
    name = e.getNormalizedName() and
    (
      name.matches("BLAKE2B") and type instanceof Crypto::BLAKE2B
      or
      name.matches("BLAKE2S") and type instanceof Crypto::BLAKE2S
      or
      name.matches("GOST%") and type instanceof Crypto::GOSTHash
      or
      name.matches("MD2") and type instanceof Crypto::MD2
      or
      name.matches("MD4") and type instanceof Crypto::MD4
      or
      name.matches("MD5") and type instanceof Crypto::MD5
      or
      name.matches("MDC2") and type instanceof Crypto::MDC2
      or
      name.matches("POLY1305") and type instanceof Crypto::POLY1305
      or
      name.matches(["SHA", "SHA1"]) and type instanceof Crypto::SHA1
      or
      name.matches("SHA+%") and not name.matches(["SHA1", "SHA3-"]) and type instanceof Crypto::SHA2
      or
      name.matches("SHA3-%") and type instanceof Crypto::SHA3
      or
      name.matches(["SHAKE"]) and type instanceof Crypto::SHAKE
      or
      name.matches("SM3") and type instanceof Crypto::SM3
      or
      name.matches("RIPEMD160") and type instanceof Crypto::RIPEMD160
      or
      name.matches("WHIRLPOOL") and type instanceof Crypto::WHIRLPOOL
    )
  )
}

class KnownOpenSSLHashConstantAlgorithmInstance extends OpenSSLAlgorithmInstance,
  Crypto::HashAlgorithmInstance instanceof KnownOpenSSLHashAlgorithmConstant
{
  OpenSSLAlgorithmValueConsumer getterCall;

  KnownOpenSSLHashConstantAlgorithmInstance() {
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

  override OpenSSLAlgorithmValueConsumer getAVC() { result = getterCall }

  override Crypto::THashType getHashFamily() {
    knownOpenSSLConstantToHashFamilyType(this, result)
    or
    not knownOpenSSLConstantToHashFamilyType(this, _) and result = Crypto::OtherHashType()
  }

  override string getRawHashAlgorithmName() { result = this.(Literal).getValue().toString() }

  override int getFixedDigestLength() {
    this.(KnownOpenSSLHashAlgorithmConstant).getExplicitDigestLength() = result
  }
}

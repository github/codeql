import cpp
private import experimental.quantum.Language
private import KnownAlgorithmConstants
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumers
private import experimental.quantum.OpenSSL.AlgorithmInstances.OpenSSLAlgorithmInstanceBase
private import AlgToAVCFlow

predicate knownOpenSslConstantToHashFamilyType(
  KnownOpenSslHashAlgorithmExpr e, Crypto::THashType type
) {
  exists(string name |
    name = e.(KnownOpenSslAlgorithmExpr).getNormalizedName() and
    (
      name = "BLAKE2B" and type instanceof Crypto::BLAKE2B
      or
      name = "BLAKE2S" and type instanceof Crypto::BLAKE2S
      or
      name.matches("GOST%") and type instanceof Crypto::GOSTHash
      or
      name = "MD2" and type instanceof Crypto::MD2
      or
      name = "MD4" and type instanceof Crypto::MD4
      or
      name = "MD5" and type instanceof Crypto::MD5
      or
      name = "MDC2" and type instanceof Crypto::MDC2
      or
      name = "POLY1305" and type instanceof Crypto::POLY1305
      or
      name.matches(["SHA", "SHA1"]) and type instanceof Crypto::SHA1
      or
      name.matches("SHA_%") and not name.matches(["SHA1", "SHA3-"]) and type instanceof Crypto::SHA2
      or
      name.matches("SHA3-%") and type instanceof Crypto::SHA3
      or
      name = "SHAKE" and type instanceof Crypto::SHAKE
      or
      name = "SM3" and type instanceof Crypto::SM3
      or
      name = "RIPEMD160" and type instanceof Crypto::RIPEMD160
      or
      name = "WHIRLPOOL" and type instanceof Crypto::WHIRLPOOL
    )
  )
}

class KnownOpenSslHashConstantAlgorithmInstance extends OpenSslAlgorithmInstance,
  Crypto::HashAlgorithmInstance instanceof KnownOpenSslHashAlgorithmExpr
{
  OpenSslAlgorithmValueConsumer getterCall;

  KnownOpenSslHashConstantAlgorithmInstance() {
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

  override OpenSslAlgorithmValueConsumer getAvc() { result = getterCall }

  override Crypto::THashType getHashFamily() {
    knownOpenSslConstantToHashFamilyType(this, result)
    or
    not knownOpenSslConstantToHashFamilyType(this, _) and result = Crypto::OtherHashType()
  }

  override string getRawHashAlgorithmName() {
    result = this.(Literal).getValue().toString()
    or
    result = this.(Call).getTarget().getName()
  }

  override int getFixedDigestLength() {
    this.(KnownOpenSslHashAlgorithmExpr).getExplicitDigestLength() = result
  }
}

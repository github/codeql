import cpp
import experimental.Quantum.Language
import OpenSSLAlgorithmGetter

predicate knownOpenSSLConstantToHashFamilyType(KnownOpenSSLAlgorithmConstant e, Crypto::THashType type) {
  exists(string name | e.getAlgType().toLowerCase().matches("hash") |
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

class KnownOpenSSLHashConstantAlgorithmInstance extends Crypto::HashAlgorithmInstance instanceof KnownOpenSSLAlgorithmConstant
{
  OpenSSLAlgorithmGetterCall getterCall;

  KnownOpenSSLHashConstantAlgorithmInstance() {
    // Not just any known value, but specifically a known hash
    this.(KnownOpenSSLAlgorithmConstant).getAlgType().toLowerCase().matches("hash") and
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

  override Crypto::THashType getHashFamily() { 
    knownOpenSSLConstantToHashFamilyType(this, result) or
    not knownOpenSSLConstantToHashFamilyType(this, _) and result = Crypto::OtherHashType()
  }

  override string getRawAlgorithmName() { result = this.(Literal).getValue().toString() }

  override int getHashSize() { none() } //TODO
}

import cpp
import experimental.Quantum.Language
import EVPCipherConsumers
import OpenSSLAlgorithmGetter

predicate literalToHashFamilyType(Literal e, Crypto::THashType type) {
  exists(string name, string algType | algType.toLowerCase().matches("%hash") |
    resolveAlgorithmFromLiteral(e, name, algType) and
    (
      name.matches("BLAKE2B") and type instanceof Crypto::BLAKE2B
      or
      name.matches("BLAKE2S") and type instanceof Crypto::BLAKE2S
      or
      name.matches("RIPEMD160") and type instanceof Crypto::RIPEMD160
      or
      name.matches("MD2") and type instanceof Crypto::MD2
      or
      name.matches("MD4") and type instanceof Crypto::MD4
      or
      name.matches("MD5") and type instanceof Crypto::MD5
      or
      name.matches("POLY1305") and type instanceof Crypto::POLY1305
      or
      name.matches(["SHA1", "SHA"]) and type instanceof Crypto::SHA1
      or
      name.matches("SHA2") and type instanceof Crypto::SHA2
      or
      name.matches("SHA3") and type instanceof Crypto::SHA3
      or
      name.matches("SHAKE") and type instanceof Crypto::SHAKE
      or
      name.matches("SM3") and type instanceof Crypto::SM3
      or
      name.matches("WHIRLPOOL") and type instanceof Crypto::WHIRLPOOL
      // TODO: what about MD_GOST?
    )
  )
}

class HashKnownAlgorithmLiteralAlgorithmInstance extends Crypto::HashAlgorithmInstance instanceof Literal
{
  OpenSSLAlgorithmGetterCall cipherGetterCall;

  HashKnownAlgorithmLiteralAlgorithmInstance() {
    exists(DataFlow::Node src, DataFlow::Node sink |
      sink = cipherGetterCall.getValueArgNode() and
      src.asExpr() = this and
      KnownAlgorithmLiteralToAlgorithmGetterFlow::flow(src, sink) and
      // Not just any known value, but specifically a known cipher operation
      exists(string algType |
        resolveAlgorithmFromLiteral(src.asExpr(), _, algType) and
        algType.toLowerCase().matches("hash")
      )
    )
  }

  // TODO: should this not be part of the abstract algorithm definition?
  Crypto::AlgorithmConsumer getConsumer() {
    AlgGetterToAlgConsumerFlow::flow(cipherGetterCall.getResultNode(), DataFlow::exprNode(result))
  }

  override Crypto::THashType getHashFamily() { literalToHashFamilyType(this, result) }

  override string getRawAlgorithmName() { result = this.(Literal).getValue().toString() }
}

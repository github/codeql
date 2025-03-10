import cpp
import experimental.Quantum.Language
import EVPCipherConsumers
import OpenSSLAlgorithmGetter

predicate literalToCipherFamilyType(Literal e, Crypto::TCipherType type) { 
  exists(string name, string algType | algType.toLowerCase().matches("%encryption") |
    resolveAlgorithmFromLiteral(e, name, algType) and
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

class CipherKnownAlgorithmLiteralAlgorithmInstance extends Crypto::CipherAlgorithmInstance instanceof Literal
{
  OpenSSLAlgorithmGetterCall cipherGetterCall;
  CipherKnownAlgorithmLiteralAlgorithmInstance() {
    exists(DataFlow::Node src, DataFlow::Node sink |
      sink = cipherGetterCall.getValueArgNode() and
      src.asExpr() = this and
      KnownAlgorithmLiteralToAlgorithmGetterFlow::flow(src, sink) and
      // Not just any known value, but specifically a known cipher operation
      exists(string algType |
        resolveAlgorithmFromLiteral(src.asExpr(), _, algType) and
        algType.toLowerCase().matches("%encryption")
      )
    )
  }

  Crypto::AlgorithmConsumer getConsumer() { 
    AlgGetterToAlgConsumerFlow::flow(cipherGetterCall.getResultNode(), DataFlow::exprNode(result))
  } 

  override Crypto::ModeOfOperationAlgorithmInstance getModeOfOperationAlgorithm() {
    none() // TODO: provider defaults
  }

  override Crypto::PaddingAlgorithmInstance getPaddingAlgorithm() { none() }

  override string getRawAlgorithmName() { result = this.(Literal).getValue().toString() }

  override Crypto::TCipherType getCipherFamily() { literalToCipherFamilyType(this, result) }
}

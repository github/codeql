import cpp
import experimental.Quantum.Language
import EVPCipherConsumers
import OpenSSLAlgorithmGetter

/**
 * Given a literal `e`, converts this to a cipher family type.
 * The literal must be a known literal representing a cipher algorithm.
 * If the literal does not represent any known cipher algorithm,
 * this predicate will not hold (i.e., it will not bind an unknown to an unknown cipher type)
 */
predicate knownOpenSSLConstantToCipherFamilyType(KnownOpenSSLAlgorithmConstant e, Crypto::TCipherType type) {
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
    none() // TODO: provider defaults
  }

  override Crypto::PaddingAlgorithmInstance getPaddingAlgorithm() { none() }

  override string getRawAlgorithmName() { result = this.(Literal).getValue().toString() }

  override Crypto::TCipherType getCipherFamily() { 
    knownOpenSSLConstantToCipherFamilyType(this, result) 
    or
    not knownOpenSSLConstantToCipherFamilyType(this, _) and result = Crypto::OtherCipherType()
  }
}
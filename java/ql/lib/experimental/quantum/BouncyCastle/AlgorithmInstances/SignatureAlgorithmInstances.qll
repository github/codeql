import java
import experimental.quantum.Language

/**
 * Signature algorithms are implicitly defined by the constructor.
 */
private abstract class SignatureAlgorithmValueConsumer extends Crypto::AlgorithmValueConsumer { 
  override Crypto::AlgorithmInstance getAKnownAlgorithmSource() {
    result = this
  }

  override Crypto::ConsumerInputDataFlowNode getInputNode() { 
    none()
  }
}

class SignatureAlgorithmInstance extends Crypto::KeyOperationAlgorithmInstance, SignatureAlgorithmValueConsumer instanceof ClassInstanceExpr {
  SignatureAlgorithmInstance() {
    super.getConstructedType().getPackage().getName() = "org.bouncycastle.crypto.signers" and
    super.getConstructedType().getName().matches("%Signer")

  }

   // TODO: Could potentially be used to model signature modes like Ed25519ph and Ed25519ctx.
  override Crypto::ModeOfOperationAlgorithmInstance getModeOfOperationAlgorithm() { none() }

  override Crypto::PaddingAlgorithmInstance getPaddingAlgorithm() { none() }
  
  override Crypto::ConsumerInputDataFlowNode getKeySizeConsumer() { none() }

  override Crypto::KeyOpAlg::Algorithm getAlgorithmType() {
    nameToTypeAndKeySizeMapping(this.getRawAlgorithmName(), _, result)
  }

  override string getRawAlgorithmName() { 
    result = super.getConstructedType().getName().splitAt("Signer", 0)
  }

  override string getKeySizeFixed() { 
    nameToTypeAndKeySizeMapping(this.getRawAlgorithmName(), result, _)
  }
}

predicate nameToTypeAndKeySizeMapping(string name, string keySize, Crypto::KeyOpAlg::Algorithm algorithm) {
  name = "Ed25519" and keySize = "256" and algorithm = Crypto::KeyOpAlg::TSignature(Crypto::KeyOpAlg::Ed25519())
  or
  name = "Ed448" and keySize = "448" and algorithm = Crypto::KeyOpAlg::TSignature(Crypto::KeyOpAlg::Ed448())
}




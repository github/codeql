import java
import experimental.quantum.Language

abstract class SignatureAlgorithmInstance extends Crypto::KeyOperationAlgorithmInstance {

  // TODO: Could potentially be used to model signature modes like Ed25519ph and Ed25519ctx.
  override Crypto::ModeOfOperationAlgorithmInstance getModeOfOperationAlgorithm() { none() }

  override Crypto::PaddingAlgorithmInstance getPaddingAlgorithm() { none() }
  
  override Crypto::ConsumerInputDataFlowNode getKeySizeConsumer() { none() }
}

class Ed25519AlgorithmInstance extends SignatureAlgorithmInstance instanceof ClassInstanceExpr {
  Ed25519AlgorithmInstance() {
    this.getConstructedType().hasQualifiedName("org.bouncycastle.crypto.signers", "Ed25519Signer")
  }

  override string getRawAlgorithmName() { result = "Ed25519" }

  override Crypto::KeyOpAlg::Algorithm getAlgorithmType() { 
    result = Crypto::KeyOpAlg::TSignature(Crypto::KeyOpAlg::Ed25519()) 
  }

  // TODO: May be redundant.
  override string getKeySizeFixed() { result = "256" }
}

class Ed448AlgorithmInstance extends SignatureAlgorithmInstance instanceof ClassInstanceExpr {
  Ed448AlgorithmInstance() {
    this.getConstructedType().hasQualifiedName("org.bouncycastle.crypto.signers", "Ed448Signer")
  }

  override string getRawAlgorithmName() { result = "Ed448" }

  override Crypto::KeyOpAlg::Algorithm getAlgorithmType() { 
    result = Crypto::KeyOpAlg::TSignature(Crypto::KeyOpAlg::Ed448()) 
  }

  // TODO: May be redundant.
  override string getKeySizeFixed() { result = "448" }
}



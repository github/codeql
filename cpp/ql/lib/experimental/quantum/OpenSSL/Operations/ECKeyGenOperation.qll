private import experimental.quantum.Language
private import OpenSSLOperationBase
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumers
private import semmle.code.cpp.dataflow.new.DataFlow

class ECKeyGenOperation extends OpenSslOperation, Crypto::KeyGenerationOperationInstance {
  ECKeyGenOperation() { this.(Call).getTarget().getName() = "EC_KEY_generate_key" }

  override Expr getAlgorithmArg() { result = this.(Call).getArgument(0) }

  override Crypto::KeyArtifactType getOutputKeyType() { result = Crypto::TAsymmetricKeyType() }

  override Crypto::ArtifactOutputDataFlowNode getOutputKeyArtifact() {
    result.asExpr() = this.(Call).getArgument(0)
  }

  override Crypto::ConsumerInputDataFlowNode getKeySizeConsumer() {
    none() // no explicit key size, inferred from algorithm
  }

  override int getKeySizeFixed() {
    none()
    // TODO: marked as none as the operation itself has no key size, it
    // comes from the algorithm source, but note we could grab the
    // algorithm source and get the key size (see below).
    // We may need to reconsider what is the best approach here.
    // result =
    //   this.getAnAlgorithmValueConsumer()
    //       .getAKnownAlgorithmSource()
    //       .(Crypto::EllipticCurveInstance)
    //       .getKeySize()
  }
}

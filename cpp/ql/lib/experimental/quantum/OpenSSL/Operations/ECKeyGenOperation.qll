private import experimental.quantum.Language
private import experimental.quantum.OpenSSL.CtxFlow as CTXFlow
private import OpenSSLOperationBase
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumers
private import semmle.code.cpp.dataflow.new.DataFlow

private module AlgGetterToAlgConsumerConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(OpenSSLAlgorithmValueConsumer c | c.getResultNode() = source)
  }

  predicate isSink(DataFlow::Node sink) {
    exists(ECKeyGenOperation c | c.getAlgorithmArg() = sink.asExpr())
  }
}

private module AlgGetterToAlgConsumerFlow = DataFlow::Global<AlgGetterToAlgConsumerConfig>;

class ECKeyGenOperation extends Crypto::KeyGenerationOperationInstance {
  ECKeyGenOperation() { this.(Call).getTarget().getName() = "EC_KEY_generate_key" }

  Expr getAlgorithmArg() { result = this.(Call).getArgument(0) }

  override Crypto::KeyArtifactType getOutputKeyType() { result = Crypto::TAsymmetricKeyType() }

  override Crypto::ArtifactOutputDataFlowNode getOutputKeyArtifact() {
    result.asExpr() = this.(Call)
  }

  override Crypto::AlgorithmValueConsumer getAnAlgorithmValueConsumer() {
    AlgGetterToAlgConsumerFlow::flow(result.(OpenSSLAlgorithmValueConsumer).getResultNode(),
      DataFlow::exprNode(this.getAlgorithmArg()))
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

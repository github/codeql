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

class ECKeyGenOperation extends OpenSSLOperation, Crypto::KeyGenerationOperationInstance {
  ECKeyGenOperation() { this.(Call).getTarget().getName() = "EC_KEY_generate_key" }

  override Expr getOutputArg() {
    result = this.(Call) // return value of call
  }

  Expr getAlgorithmArg() { result = this.(Call).getArgument(0) }

  override Expr getInputArg() {
    // there is no 'input', in the sense that no data is being manipulated by the operation.
    // There is an input of an algorithm, but that is not the intention of the operation input arg.
    none()
  }

  override Crypto::KeyArtifactType getOutputKeyType() { result = Crypto::TAsymmetricKeyType() }

  override Crypto::ArtifactOutputDataFlowNode getOutputKeyArtifact() {
    result = this.getOutputNode()
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

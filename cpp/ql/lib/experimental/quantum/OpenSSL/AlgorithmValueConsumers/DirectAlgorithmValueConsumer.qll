import cpp
import experimental.quantum.Language
import experimental.quantum.OpenSSL.AlgorithmInstances.KnownAlgorithmConstants
import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumerBase

// TODO: can self referential to itself, which is also an algorithm (Known algorithm)
/**
 * Cases like EVP_MD5(),
 * there is no input, rather it directly gets an algorithm
 * and returns it.
 */
class DirectAlgorithmValueConsumer extends OpenSSLAlgorithmValueConsumer {
  DataFlow::Node resultNode;
  Expr resultExpr;

  DirectAlgorithmValueConsumer() {
    this instanceof KnownOpenSSLAlgorithmConstant and
    this instanceof Call and
    resultExpr = this and
    resultNode.asExpr() = resultExpr
  }

  /**
   * These cases take in no explicit value (the value is implicit)
   */
  override Crypto::ConsumerInputDataFlowNode getInputNode() { none() }

  override DataFlow::Node getResultNode() { result = resultNode }

  //   override DataFlow::Node getOutputNode() { result = resultNode }
  override Crypto::AlgorithmInstance getAKnownAlgorithmSource() {
    // Note: algorithm source definitions enforces that
    // this class will be a known algorithm source
    result = this
  }
}

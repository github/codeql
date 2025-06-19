import cpp
private import experimental.quantum.Language
private import experimental.quantum.OpenSSL.AlgorithmInstances.KnownAlgorithmConstants
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumerBase

/**
 * Cases like EVP_MD5(),
 * there is no input, rather it directly gets an algorithm
 * and returns it.
 * Also includes operations directly using an algorithm
 * like AES_encrypt().
 */
class DirectAlgorithmValueConsumer extends OpenSslAlgorithmValueConsumer instanceof OpenSslAlgorithmCall
{
  /**
   * These cases take in no explicit value (the value is implicit)
   */
  override Crypto::ConsumerInputDataFlowNode getInputNode() { none() }

  /**
   * Gets the DataFlow node represeting the output algorithm entity
   * created as a result of this call.
   */
  override DataFlow::Node getResultNode() {
    this instanceof OpenSslDirectAlgorithmFetchCall and
    result.asExpr() = this
    // NOTE: if instanceof OpenSslDirectAlgorithmOperationCall then there is no algorithm generated
    // the algorithm is directly used
  }

  override Crypto::AlgorithmInstance getAKnownAlgorithmSource() {
    // Note: algorithm source definitions enforces that
    // this class will be a known algorithm source
    result = this
  }
}

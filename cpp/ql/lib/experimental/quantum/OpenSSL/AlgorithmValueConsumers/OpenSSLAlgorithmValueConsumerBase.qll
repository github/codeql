import experimental.quantum.Language
import semmle.code.cpp.dataflow.new.DataFlow

abstract class OpenSSLAlgorithmValueConsumer extends Crypto::AlgorithmValueConsumer instanceof Call {
  /**
   * Returns the node representing the resulting algorithm
   */
  abstract DataFlow::Node getResultNode();
}

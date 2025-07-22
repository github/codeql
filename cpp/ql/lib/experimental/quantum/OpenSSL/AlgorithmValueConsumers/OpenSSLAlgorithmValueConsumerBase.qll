private import experimental.quantum.Language

abstract class OpenSslAlgorithmValueConsumer extends Crypto::AlgorithmValueConsumer instanceof Call {
  /**
   * Returns the node representing the resulting algorithm
   */
  abstract DataFlow::Node getResultNode();
}

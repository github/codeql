import java
import experimental.quantum.Language

abstract class HashAlgorithmValueConsumer extends Crypto::AlgorithmValueConsumer { }

abstract class CipherAlgorithmValueConsumer extends Crypto::AlgorithmValueConsumer { }

abstract class EllipticCurveAlgorithmValueConsumer extends Crypto::AlgorithmValueConsumer { }

/**
 * Signature algorithms are implicitly defined by the constructor.
 */
abstract class SignatureAlgorithmValueConsumer extends Crypto::AlgorithmValueConsumer {
  override Crypto::AlgorithmInstance getAKnownAlgorithmSource() { result = this }

  override Crypto::ConsumerInputDataFlowNode getInputNode() { none() }
}

/**
 * Key generation algorithms are implicitly defined by the constructor.
 */
abstract class KeyGenerationAlgorithmValueConsumer extends Crypto::AlgorithmValueConsumer {
  override Crypto::AlgorithmInstance getAKnownAlgorithmSource() { result = this }

  override Crypto::ConsumerInputDataFlowNode getInputNode() { none() }
}

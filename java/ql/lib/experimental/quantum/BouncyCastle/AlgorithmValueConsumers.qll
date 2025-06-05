import java
import AlgorithmInstances

abstract class HashAlgorithmValueConsumer extends Crypto::AlgorithmValueConsumer { }

abstract class CipherAlgorithmValueConsumer extends Crypto::AlgorithmValueConsumer { }

abstract class EllipticCurveAlgorithmValueConsumer extends Crypto::AlgorithmValueConsumer { }

class EllipticCurveStringLiteralArg extends EllipticCurveAlgorithmValueConsumer instanceof Expr {
  EllipticCurveStringLiteralArg() {
    this = any(Params::ParametersInstantiation params).getAlgorithmArg()
  }

  override Crypto::ConsumerInputDataFlowNode getInputNode() { result.asExpr() = this }

  override Crypto::AlgorithmInstance getAKnownAlgorithmSource() {
    result.(EllipticCurveStringLiteralInstance).getConsumer() = this
  }
}

/**
 * The AVC for a signature algorithm where the algorithm is implicitly defined
 * by the constructor.
 */
abstract class SignatureAlgorithmValueConsumer extends Crypto::AlgorithmValueConsumer {
  override Crypto::AlgorithmInstance getAKnownAlgorithmSource() { result = this }

  override Crypto::ConsumerInputDataFlowNode getInputNode() { none() }
}

/**
 * The AVC for a key generation algorithm where the algorithm is implicitly
 * defined by the constructor.
 */
abstract class KeyGenerationAlgorithmValueConsumer extends Crypto::AlgorithmValueConsumer {
  override Crypto::AlgorithmInstance getAKnownAlgorithmSource() { result = this }

  override Crypto::ConsumerInputDataFlowNode getInputNode() { none() }
}

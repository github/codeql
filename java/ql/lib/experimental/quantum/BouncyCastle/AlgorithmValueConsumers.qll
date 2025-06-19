private import java
private import experimental.quantum.Language
private import AlgorithmValueConsumers
private import AlgorithmInstances

abstract class EllipticCurveAlgorithmValueConsumer extends Crypto::AlgorithmValueConsumer { }

/**
 * An AVC for an elliptic curve algorithm where the algorithm is defined by an
 * elliptic curve string literal.
 */
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
 * An AVC representing the block cipher argument passed to an block cipher mode
 * constructor.
 */
class BlockCipherAlgorithmArg extends Crypto::AlgorithmValueConsumer instanceof Expr {
  BlockCipherAlgorithmArg() {
    this = any(BlockCipherModeAlgorithmInstance mode).getBlockCipherArg()
  }

  override Crypto::ConsumerInputDataFlowNode getInputNode() { result.asExpr() = this }

  override Crypto::AlgorithmInstance getAKnownAlgorithmSource() {
    result.(BlockCipherAlgorithmInstance).getConsumer() = this
  }
}

/**
 * An AVC for an algorithm that is implicitly defined by the instance.
 */
abstract class ImplicitAlgorithmValueConsumer extends Crypto::AlgorithmValueConsumer {
  override Crypto::AlgorithmInstance getAKnownAlgorithmSource() { result = this }

  override Crypto::ConsumerInputDataFlowNode getInputNode() { none() }
}

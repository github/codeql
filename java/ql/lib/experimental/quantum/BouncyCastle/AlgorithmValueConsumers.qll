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
 * An AVC for a signature algorithm where the algorithm is implicitly defined by
 * the constructor.
 */
abstract class SignatureAlgorithmValueConsumer extends Crypto::AlgorithmValueConsumer {
  override Crypto::AlgorithmInstance getAKnownAlgorithmSource() { result = this }

  override Crypto::ConsumerInputDataFlowNode getInputNode() { none() }
}

/**
 * An AVC for a key generation algorithm where the algorithm is implicitly
 * defined by the constructor.
 */
abstract class KeyGenerationAlgorithmValueConsumer extends Crypto::AlgorithmValueConsumer {
  override Crypto::AlgorithmInstance getAKnownAlgorithmSource() { result = this }

  override Crypto::ConsumerInputDataFlowNode getInputNode() { none() }
}

/**
 * A block cipher argument passed to an block cipher mode constructor.
 */
class BlockCipherAlgorithmValueConsumer extends Crypto::AlgorithmValueConsumer instanceof Expr {
  BlockCipherAlgorithmValueConsumer() {
    this = any(BlockCipherModeAlgorithmInstance mode).getBlockCipherArg()
  }

  override Crypto::ConsumerInputDataFlowNode getInputNode() { result.asExpr() = this }

  override Crypto::AlgorithmInstance getAKnownAlgorithmSource() {
    result.(BlockCipherAlgorithmInstance).getConsumer() = this
  }
}

/**
 * An AVC for a block cipher mode implicitly defined by the constructor.
 */
abstract class BlockCipherModeAlgorithmValueConsumer extends Crypto::AlgorithmValueConsumer instanceof ClassInstanceExpr
{
  BlockCipherModeAlgorithmValueConsumer() {
    this.getType() instanceof Modes::UnpaddedBlockCipherMode
  }

  override Crypto::AlgorithmInstance getAKnownAlgorithmSource() { result = this }

  override Crypto::ConsumerInputDataFlowNode getInputNode() { none() }
}

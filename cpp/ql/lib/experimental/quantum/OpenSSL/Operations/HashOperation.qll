/**
 * https://docs.openssl.org/3.0/man3/EVP_DigestInit/#synopsis
 */

private import experimental.quantum.Language
private import OpenSSLOperationBase
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumers

/**
 * A base class for final digest operations.
 */
abstract class FinalDigestOperation extends OperationStep {
  override OperationStepType getStepType() { result = FinalStep() }
}

/**
 * A call to and EVP digest initializer, such as:
 * - `EVP_DigestInit`
 * - `EVP_DigestInit_ex`
 * - `EVP_DigestInit_ex2`
 */
class EvpDigestInitVariantCalls extends OperationStep instanceof Call {
  EvpDigestInitVariantCalls() {
    this.getTarget().getName() in ["EVP_DigestInit", "EVP_DigestInit_ex", "EVP_DigestInit_ex2"]
  }

  override DataFlow::Node getInput(IOType type) {
    result.asExpr() = this.getArgument(0) and type = ContextIO()
    or
    result.asExpr() = this.getArgument(1) and type = PrimaryAlgorithmIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asExpr() = this.getArgument(0) and
    type = ContextIO()
  }

  override OperationStepType getStepType() { result = InitializerStep() }
}

/**
 * A call to `EVP_DigestUpdate`.
 */
class EvpDigestUpdateCall extends OperationStep instanceof Call {
  EvpDigestUpdateCall() { this.getTarget().getName() = "EVP_DigestUpdate" }

  override DataFlow::Node getInput(IOType type) {
    result.asExpr() = this.getArgument(0) and type = ContextIO()
    or
    result.asExpr() = this.getArgument(1) and type = PlaintextIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asExpr() = this.getArgument(0) and
    type = ContextIO()
  }

  override OperationStepType getStepType() { result = UpdateStep() }
}

/**
 * A call to `EVP_Q_digest`
 * https://docs.openssl.org/3.0/man3/EVP_DigestInit/#synopsis
 */
class EvpQDigestOperation extends FinalDigestOperation instanceof Call {
  EvpQDigestOperation() { this.getTarget().getName() = "EVP_Q_digest" }

  override DataFlow::Node getInput(IOType type) {
    result.asExpr() = this.getArgument(1) and type = PrimaryAlgorithmIO()
    or
    result.asExpr() = this.getArgument(0) and type = ContextIO()
    or
    result.asExpr() = this.getArgument(3) and type = PlaintextIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asExpr() = this.getArgument(0) and
    type = ContextIO()
    or
    result.asDefiningArgument() = this.getArgument(5) and type = DigestIO()
  }
}

class EvpDigestOperation extends FinalDigestOperation instanceof Call {
  EvpDigestOperation() { this.getTarget().getName() = "EVP_Digest" }

  override DataFlow::Node getInput(IOType type) {
    result.asExpr() = this.getArgument(4) and type = PrimaryAlgorithmIO()
    or
    result.asExpr() = this.getArgument(0) and type = PlaintextIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asDefiningArgument() = this.getArgument(2) and type = DigestIO()
  }
}

/**
 * A call to EVP_DigestFinal variants
 */
class EvpDigestFinalCall extends FinalDigestOperation instanceof Call {
  EvpDigestFinalCall() {
    this.getTarget().getName() in ["EVP_DigestFinal", "EVP_DigestFinal_ex", "EVP_DigestFinalXOF"]
  }

  override DataFlow::Node getInput(IOType type) {
    result.asExpr() = this.getArgument(0) and type = ContextIO()
  }

  override DataFlow::Node getOutput(IOType type) {
    result.asExpr() = this.getArgument(0) and
    type = ContextIO()
    or
    result.asDefiningArgument() = this.getArgument(1) and type = DigestIO()
  }
}

/**
 * An openssl digest final hash operation instance
 */
class OpenSslDigestFinalOperationInstance extends Crypto::HashOperationInstance instanceof FinalDigestOperation
{
  override Crypto::AlgorithmValueConsumer getAnAlgorithmValueConsumer() {
    super.getPrimaryAlgorithmValueConsumer() = result
  }

  override Crypto::ArtifactOutputDataFlowNode getOutputArtifact() {
    super.getOutputStepFlowingToStep(DigestIO()).getOutput(DigestIO()) = result
  }

  override Crypto::ConsumerInputDataFlowNode getInputConsumer() {
    super.getDominatingInitializersToStep(PlaintextIO()).getInput(PlaintextIO()) = result
  }
}

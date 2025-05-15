
import java

/**
 * Models for the signature algorithms defined by the `org.bouncycastle.crypto.signers` package.
 * 
 */
module Signers {
  import Language
  import BouncyCastle.FlowAnalysis
  import BouncyCastle.AlgorithmInstances

  abstract class SignatureAlgorithmValueConsumer extends Crypto::AlgorithmValueConsumer { }

  /**
   * A model of the `Signer` class in Bouncy Castle.
   */
  class Signer extends RefType {
    Signer() {
      this.getPackage().getName() = "org.bouncycastle.crypto.signers" and
      this.getName().matches("%Signer")
    }

    MethodCall getAnInitCall() {
      result = this.getAMethodCall("init")
    }

    MethodCall getAUseCall() {
      result = this.getAMethodCall(["update", "generateSignature", "verifySignature"])
    }
    
    MethodCall getAMethodCall(string name) {
      result.getCallee().hasQualifiedName("org.bouncycastle.crypto.signers", this.getName(), name)
    }
  }

  /**
   * BouncyCastle algorithms are instantiated by calling the constructor of the
   * corresponding class. The algorithm is implicitly defined by the constructor
   * call.
   */
  class NewCall extends SignatureAlgorithmValueConsumer instanceof ClassInstanceExpr {
    NewCall() {
      this.getConstructedType() instanceof Signer
    }

    override Crypto::AlgorithmInstance getAKnownAlgorithmSource() {
      result = getSignatureAlgorithmInstanceFromType(super.getConstructedType())
    }
  
    // TODO: Since the algorithm is implicitly defined by the constructor, should
    // the input node be `this`?
    override Crypto::ConsumerInputDataFlowNode getInputNode() { 
      result.asExpr() = this
    }
  }

  /**
   * The type is instantiated by a constructor call and initialized by a call to
   * `init()` which takes two arguments. The first argument is a flag indicating
   * whether the operation is signing data or verifying a signature, and the
   * second is the key to use. 
   */
  class InitCall extends MethodCall {
    InitCall() {
      this = any(Signer signer).getAnInitCall() 
    }

    Expr getForSigningArg() { result = this.getArgument(0) }

    Expr getKeyArg() { result = this.getArgument(1) }

    Crypto::KeyOperationAlgorithmInstance getAlgorithm() {
      result = getSignatureAlgorithmInstanceFromType(this.getReceiverType())
    }

    Crypto::KeyOperationSubtype getKeyOperationSubtype() {
      (
        this.getForSigningArg().(BooleanLiteral).getBooleanValue() = true and
        result = Crypto::TSignMode()
      ) or (
        this.getForSigningArg().(BooleanLiteral).getBooleanValue() = false and
        result = Crypto::TVerifyMode()
      ) or (
        result = Crypto::TUnknownKeyOperationMode()
      )
    }
  }

  /**
   * The `update()` method is used to pass message data to the signer, and the
   * `generateSignature()` or `verifySignature()` methods are used to produce or
   * verify the signature, respectively.
   */
  class UseCall extends MethodCall {
    UseCall() {
      this = any(Signer signer).getAUseCall()
    }

    predicate isIntermediate() {
      this.getCallee().getName() = "update"
    }

    Expr getInput() { result = this.getArgument(0) }

    Expr getOutput() {
      result = this
    }
  }

  /**
   * Instantiate the flow analysis module for the `Signer` class.
   */
  module FlowAnalysis = NewToInitToUseFlowAnalysis<NewCall, InitCall, UseCall>;

  /**
   * A signing operation instance is a call to either `update()`, `generateSignature()`,
   * or `verifySignature()` on a `Signer` instance.
   */
  class SignatureOperationInstance extends Crypto::KeyOperationInstance instanceof UseCall {
    
    override Crypto::AlgorithmValueConsumer getAnAlgorithmValueConsumer() {
      result = FlowAnalysis::getInstantiationFromInit(this.getInitCall(), _, _)
    }
    override Crypto::KeyOperationSubtype getKeyOperationSubtype() {
      if FlowAnalysis::hasInit(this)
      then result = this.getInitCall().getKeyOperationSubtype()
      else result = Crypto::TUnknownKeyOperationMode()
    }

    override Crypto::ConsumerInputDataFlowNode getKeyConsumer() {
      result.asExpr() = this.getInitCall().getKeyArg()
    }

    override Crypto::ConsumerInputDataFlowNode getNonceConsumer() { none() }

    override Crypto::ConsumerInputDataFlowNode getInputConsumer() {
      result.asExpr() = this.getAnUpdateCall().getInput()
    }

    override Crypto::ArtifactOutputDataFlowNode getOutputArtifact() {
      this.getKeyOperationSubtype() = Crypto::TSignMode() and
      not super.isIntermediate() and
      result.asExpr() = super.getOutput()
    }

    InitCall getInitCall() {
      result = FlowAnalysis::getInitFromUse(this, _, _)
    }

    UseCall getAnUpdateCall() {
      (
        super.isIntermediate() and result = this
      ) or (
        result = FlowAnalysis::getAnIntermediateUseFromFinalUse(this, _, _)
      )
    }
  }
}


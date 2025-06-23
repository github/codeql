private import csharp
private import DataFlow
private import experimental.quantum.Language
private import AlgorithmValueConsumers
private import FlowAnalysis
private import Cryptography

class ECDsaORRSASigningOperationInstance extends Crypto::SignatureOperationInstance instanceof SignerUse
{
  SigningCreateCall creator;

  ECDsaORRSASigningOperationInstance() {
    creator = SigningCreateToUseFlow::getCreationFromUse(this, _, _)
  }

  override Crypto::AlgorithmValueConsumer getAnAlgorithmValueConsumer() {
    result = creator.getAlgorithmArg()
  }

  override Crypto::KeyOperationSubtype getKeyOperationSubtype() {
    if super.isSigner()
    then result = Crypto::TSignMode()
    else
      if super.isVerifier()
      then result = Crypto::TVerifyMode()
      else result = Crypto::TUnknownKeyOperationMode()
  }

  override Crypto::ConsumerInputDataFlowNode getKeyConsumer() {
    result.asExpr() = creator.getKeyConsumer()
  }

  override Crypto::ConsumerInputDataFlowNode getNonceConsumer() { none() }

  override Crypto::ConsumerInputDataFlowNode getInputConsumer() {
    result.asExpr() = super.getMessageArg()
  }

  override Crypto::ConsumerInputDataFlowNode getSignatureConsumer() {
    result.asExpr() = super.getSignatureArg()
  }

  override Crypto::ArtifactOutputDataFlowNode getOutputArtifact() {
    result.asExpr() = super.getSignatureOutput()
  }
}

class HashOperationInstance extends Crypto::HashOperationInstance instanceof HashUse {
  HashAlgorithmCreateCall creator;

  HashOperationInstance() { creator = HashCreateToUseFlow::getCreationFromUse(this, _, _) }

  override Crypto::ArtifactOutputDataFlowNode getOutputArtifact() { none() }

  override Crypto::ConsumerInputDataFlowNode getInputConsumer() { none() }

  override Crypto::AlgorithmValueConsumer getAnAlgorithmValueConsumer() { none() }
}

/**
 * A symmetric algorithm class, such as AES or DES.
 */
class SymmetricAlgorithm extends Class {
  SymmetricAlgorithm() {
    this.getABaseType().hasFullyQualifiedName("System.Security.Cryptography", "SymmetricAlgorithm")
  }

  CryptoTransformCreation getCreateTransformCall() { result = this.getAMethod().getACall() }
}

/**
 * A symmetric algorithm creation, such as `Aes.Create()`.
 */
class SymmetricAlgorithmCreation extends MethodCall {
  SymmetricAlgorithmCreation() {
    this.getTarget().hasName("Create") and
    this.getQualifier().getType() instanceof SymmetricAlgorithm
  }

  SymmetricAlgorithm getSymmetricAlgorithm() { result = this.getQualifier().getType() }
}

class SymmetricAlgorithmUse extends QualifiableExpr {
  SymmetricAlgorithmUse() {
    this.getQualifier().getType() instanceof SymmetricAlgorithm and
    this.getQualifiedDeclaration()
        .hasName(["CreateEncryptor", "CreateDecryptor", "Key", "IV", "Padding"])
  }

  Expr getSymmetricAlgorithm() { result = this.getQualifier() }

  predicate isIntermediate() {
    not this.getQualifiedDeclaration().hasName(["CreateEncryptor", "CreateDecryptor"])
  }

  // The key may be set by assigning it to the `Key` property of the symmetric algorithm.
  predicate isKeyConsumer() {
    this instanceof PropertyWrite and this.getQualifiedDeclaration().getName() = "Key"
  }

  // The IV may be set by assigning it to the `IV` property of the symmetric algorithm.
  predicate isIvConsumer() {
    this instanceof PropertyWrite and this.getQualifiedDeclaration().getName() = "IV"
  }

  // The padding mode may be set by assigning it to the `Padding` property of the symmetric algorithm.
  predicate isPaddingConsumer() {
    this instanceof PropertyWrite and this.getQualifiedDeclaration().getName() = "Padding"
  }
}

module SymmetricAlgorithmFlow =
  CreationToUseFlow<SymmetricAlgorithmCreation, SymmetricAlgorithmUse>;

// TODO: Remove this.
SymmetricAlgorithmUse getUseFromUse(SymmetricAlgorithmUse use) {
  result = SymmetricAlgorithmFlow::getIntermediateUseFromUse(use, _, _)
}

/**
 * A call to `CreateEncryptor` or `CreateDecryptor` on a `SymmetricAlgorithm`.
 */
class CryptoTransformCreation extends MethodCall {
  CryptoTransformCreation() {
    this.getTarget().hasName(["CreateEncryptor", "CreateDecryptor"]) and
    this.getQualifier().getType() instanceof SymmetricAlgorithm
  }

  predicate isEncryptor() { this.getTarget().getName() = "CreateEncryptor" }

  predicate isDecryptor() { this.getTarget().getName() = "CreateDecryptor" }

  Expr getKeyArg() { result = this.getArgument(0) }

  Expr getIvArg() { result = this.getArgument(1) }

  SymmetricAlgorithm getSymmetricAlgorithm() { result = this.getQualifier().getType() }
}

class CryptoStream extends Class {
  CryptoStream() { this.hasFullyQualifiedName("System.Security.Cryptography", "CryptoStream") }
}

class CryptoStreamMode extends MemberConstant {
  CryptoStreamMode() {
    this.getDeclaringType()
        .hasFullyQualifiedName("System.Security.Cryptography", "CryptoStreamMode")
  }

  predicate isRead() { this.getName() = "Read" }

  predicate isWrite() { this.getName() = "Write" }
}

class PaddingMode extends MemberConstant {
  PaddingMode() {
    this.getDeclaringType().hasFullyQualifiedName("System.Security.Cryptography", "PaddingMode")
  }
}

class CryptoStreamCreation extends ObjectCreation {
  CryptoStreamCreation() { this.getObjectType() instanceof CryptoStream }

  Expr getStreamArg() { result = this.getArgument(0) }

  Expr getTransformArg() { result = this.getArgument(1) }

  Expr getModeArg() { result = this.getArgument(2) }

  Crypto::KeyOperationSubtype getKeyOperationSubtype() {
    if CryptoTransformFlow::getCreationFromUse(this.getTransformArg()).isEncryptor()
    then result = Crypto::TEncryptMode()
    else
      if CryptoTransformFlow::getCreationFromUse(this.getTransformArg()).isDecryptor()
      then result = Crypto::TDecryptMode()
      else result = Crypto::TUnknownKeyOperationMode()
  }
}

private class CryptoStreamUse extends MethodCall {
  CryptoStreamUse() {
    this.getQualifier().getType() instanceof CryptoStream and
    this.getTarget().hasName(["Write", "FlushFinalBlock", "FlushFinalBlockAsync", "Close"])
  }

  predicate isIntermediate() { this.getTarget().getName() = "Write" }

  Expr getInputArg() {
    this.isIntermediate() and
    result = this.getArgument(0)
  }
}

private module CryptoStreamFlow = CreationToUseFlow<CryptoStreamCreation, CryptoStreamUse>;

/**
 * An instantiation of a `CryptoStream` object where the transform is a symmetric
 * encryption or decryption operation (e.g. an encryption transform created by a
 * call to `Aes.CreateEncryptor()`)
 */
class CryptoStreamOperationInstance extends Crypto::KeyOperationInstance instanceof CryptoStreamCreation
{
  CryptoTransformCreation transform;

  CryptoStreamOperationInstance() {
    transform = CryptoTransformFlow::getCreationFromUse(this) and
    (transform.isEncryptor() or transform.isDecryptor())
  }

  override Crypto::AlgorithmValueConsumer getAnAlgorithmValueConsumer() { none() }

  override Crypto::KeyOperationSubtype getKeyOperationSubtype() {
    if transform.isEncryptor()
    then result = Crypto::TEncryptMode()
    else
      if transform.isDecryptor()
      then result = Crypto::TDecryptMode()
      else result = Crypto::TUnknownKeyOperationMode()
  }

  override Crypto::ConsumerInputDataFlowNode getKeyConsumer() {
    // If a key is explicitly provided as an argument when the transform is
    // created, this takes precedence over any key that may be set on the
    // symmetric algorithm instance.
    if exists(transform.getKeyArg())
    then result.asExpr() = transform.getKeyArg()
    else (
      result.asExpr() = SymmetricAlgorithmFlow::getIntermediateUseFromUse(transform, _, _) and
      result.asExpr().(SymmetricAlgorithmUse).isKeyConsumer()
    )
  }

  override Crypto::ConsumerInputDataFlowNode getNonceConsumer() {
    // If an IV is explicitly provided as an argument when the transform is
    // created, this takes precedence over any IV that may be set on the
    // symmetric algorithm instance.
    if exists(transform.getIvArg())
    then result.asExpr() = transform.getIvArg()
    else (
      result.asExpr() = SymmetricAlgorithmFlow::getIntermediateUseFromUse(transform, _, _) and
      result.asExpr().(SymmetricAlgorithmUse).isIvConsumer()
    )
  }

  // Inputs to the operation can be passed either through the stream argument
  // when the `CryptoStream` is created, or through calls to
  // `CryptoStream.Write()`. If the input is passed through the stream argument,
  // it is wrapped using a `MemoryStream` object.
  override Crypto::ConsumerInputDataFlowNode getInputConsumer() {
    result.asExpr() = MemoryStreamFlow::getCreationFromUse(this, _, _).getBufferArg() or
    result.asExpr() = CryptoStreamFlow::getUseFromCreation(this, _, _).getInputArg()
  }

  override Crypto::ArtifactOutputDataFlowNode getOutputArtifact() { none() }
}

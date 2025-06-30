private import csharp
private import DataFlow
private import experimental.quantum.Language
private import AlgorithmValueConsumers
private import FlowAnalysis
private import Cryptography

class SigningOperationInstance extends Crypto::SignatureOperationInstance instanceof SignerUse {
  override Crypto::AlgorithmValueConsumer getAnAlgorithmValueConsumer() {
    result = super.getQualifier()
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
    result.asExpr() = SigningCreateToUseFlow::getCreationFromUse(this, _, _).getKeyConsumer()
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
  HashOperationInstance() { not super.isIntermediate() }

  override Crypto::ArtifactOutputDataFlowNode getOutputArtifact() {
    result.asExpr() = super.getOutput()
  }

  override Crypto::ConsumerInputDataFlowNode getInputConsumer() {
    result.asExpr() = super.getInputArg() or
    result.asExpr() = StreamFlow::getEarlierUse(super.getStreamArg(), _, _).getInputArg()
  }

  override Crypto::AlgorithmValueConsumer getAnAlgorithmValueConsumer() {
    result = super.getQualifier()
  }
}

/**
 * A call to an encryption or decryption API (e.g. `EncryptCbc` or `EncryptCfb`)
 * on a `SymmetricAlgorithm` instance.
 */
class SymmetricAlgorithmOperationInstance extends Crypto::KeyOperationInstance instanceof SymmetricAlgorithmUse
{
  SymmetricAlgorithmOperationInstance() { super.isEncryptionCall() or super.isDecryptionCall() }

  override Crypto::AlgorithmValueConsumer getAnAlgorithmValueConsumer() { result = this }

  override Crypto::KeyOperationSubtype getKeyOperationSubtype() {
    if super.isEncryptionCall()
    then result = Crypto::TEncryptMode()
    else
      if super.isDecryptionCall()
      then result = Crypto::TDecryptMode()
      else result = Crypto::TUnknownKeyOperationMode()
  }

  override Crypto::ConsumerInputDataFlowNode getKeyConsumer() {
    result.asExpr() = SymmetricAlgorithmFlow::getIntermediateUseFromUse(this, _, _) and
    result.asExpr().(SymmetricAlgorithmUse).isKeyConsumer()
  }

  override Crypto::ConsumerInputDataFlowNode getNonceConsumer() {
    result.asExpr() = super.getIvArg()
  }

  override Crypto::ConsumerInputDataFlowNode getInputConsumer() {
    result.asExpr() = super.getInputArg()
  }

  override Crypto::ArtifactOutputDataFlowNode getOutputArtifact() {
    result.asExpr() = super.getOutput()
  }
}

/**
 * An instantiation of a `CryptoStream` object where the transform is a symmetric
 * encryption or decryption operation (e.g. an encryption transform created by a
 * call to `Aes.CreateEncryptor()`)
 */
class CryptoStreamOperationInstance extends Crypto::KeyOperationInstance instanceof CryptoStreamCreation
{
  override Crypto::AlgorithmValueConsumer getAnAlgorithmValueConsumer() {
    result = this.getCryptoTransform()
  }

  override Crypto::KeyOperationSubtype getKeyOperationSubtype() {
    if this.getCryptoTransform().isEncryptor()
    then result = Crypto::TEncryptMode()
    else
      if this.getCryptoTransform().isDecryptor()
      then result = Crypto::TDecryptMode()
      else result = Crypto::TUnknownKeyOperationMode()
  }

  override Crypto::ConsumerInputDataFlowNode getKeyConsumer() {
    // If a key is explicitly provided as an argument when the transform is
    // created, this takes precedence over any key that may be set on the
    // symmetric algorithm instance.
    if exists(this.getCryptoTransform().getKeyArg())
    then result.asExpr() = this.getCryptoTransform().getKeyArg()
    else (
      result.asExpr() =
        SymmetricAlgorithmFlow::getIntermediateUseFromUse(this.getCryptoTransform(), _, _) and
      result.asExpr().(SymmetricAlgorithmUse).isKeyConsumer()
    )
  }

  override Crypto::ConsumerInputDataFlowNode getNonceConsumer() {
    // If an IV is explicitly provided as an argument when the transform is
    // created, this takes precedence over any IV that may be set on the
    // symmetric algorithm instance.
    if exists(this.getCryptoTransform().getIvArg())
    then result.asExpr() = this.getCryptoTransform().getIvArg()
    else (
      result.asExpr() =
        SymmetricAlgorithmFlow::getIntermediateUseFromUse(this.getCryptoTransform(), _, _) and
      result.asExpr().(SymmetricAlgorithmUse).isIvConsumer()
    )
  }

  // Inputs can be passed to the `CryptoStream` instance in a number of ways.
  //
  // 1. Through the `stream` argument when the `CryptoStream` is created
  // 2. Through calls to `Write()` on (a stream wrapped by) the stream argument
  // 3. Through calls to write on this `CryptoStream` object
  override Crypto::ConsumerInputDataFlowNode getInputConsumer() {
    result.asExpr() = this.getWrappedStreamCreation().getInputArg()
    or
    result.asExpr() = this.getEarlierWrappedStreamUse().getInputArg()
    or
    result.asExpr() = CryptoStreamFlow::getUseFromCreation(this, _, _).getInputArg()
  }

  // The output is obtained by calling `ToArray()` on a `Stream` either wrapped
  // by the `CryptoStream` object, or copied from the `CryptoStream` object.
  override Crypto::ArtifactOutputDataFlowNode getOutputArtifact() {
    // We perform backwards dataflow to identify stream objects that are wrapped
    // by the `CryptoStream` object, and then we look for calls to `ToArray()`
    // on those streams.
    result.asExpr() = this.getLaterWrappedStreamUse().getOutput()
  }

  CryptoTransformCreation getCryptoTransform() {
    result = CryptoTransformFlow::getCreationFromUse(this) and
    (result.isEncryptor() or result.isDecryptor())
  }

  // Gets either this stream, or a stream wrapped by this stream.
  StreamCreation getWrappedStreamCreation() {
    result = StreamFlow::getWrappedStreamCreation(this, _, _)
  }

  StreamUse getEarlierWrappedStreamUse() {
    result = StreamFlow::getEarlierUse(this.getWrappedStreamCreation().getStreamArg(), _, _)
  }

  StreamUse getLaterWrappedStreamUse() {
    result = StreamFlow::getLaterUse(this.getWrappedStreamCreation().getStreamArg(), _, _)
  }
}

/**
 * A call to either `Encrypt` or `Decrypt` on an `AesGcm`, `AesCcm`, or
 * `ChaCha20Poly1305` instance.
 */
class AeadOperationInstance extends Crypto::KeyOperationInstance instanceof AeadUse {
  override Crypto::AlgorithmValueConsumer getAnAlgorithmValueConsumer() {
    // See `AeadModeAlgorithmValueConsumer` for the algorithm value consumer.
    result = this
  }

  override Crypto::KeyOperationSubtype getKeyOperationSubtype() {
    result = this.(AeadUse).getKeyOperationSubtype()
  }

  override Crypto::ConsumerInputDataFlowNode getKeyConsumer() {
    result.asExpr() = AeadFlow::getCreationFromUse(this, _, _).getKeyArg()
  }

  override Crypto::ConsumerInputDataFlowNode getNonceConsumer() {
    result.asExpr() = super.getNonceArg()
  }

  override Crypto::ConsumerInputDataFlowNode getInputConsumer() {
    result.asExpr() = super.getMessageArg()
  }

  override Crypto::ArtifactOutputDataFlowNode getOutputArtifact() {
    result.asExpr() = super.getOutputArg()
  }
}

class HMACOperationInstance extends Crypto::MACOperationInstance instanceof MacUse {
  HMACOperationInstance() { not super.isIntermediate() }

  override Crypto::AlgorithmValueConsumer getAnAlgorithmValueConsumer() {
    result = super.getQualifier()
  }

  override Crypto::ConsumerInputDataFlowNode getMessageConsumer() {
    result.asExpr() = super.getInputArg() or
    result.asExpr() = StreamFlow::getEarlierUse(super.getStreamArg(), _, _).getInputArg()
  }

  override Crypto::ConsumerInputDataFlowNode getKeyConsumer() {
    result.asExpr() = super.getKeyArg()
  }
}

private import csharp
private import DataFlow
private import experimental.quantum.Language
private import AlgorithmValueConsumers
private import FlowAnalysis
private import Cryptography

class ECDsaORRSASigningOperationInstance extends Crypto::SignatureOperationInstance instanceof SignerUse
{
  override Crypto::AlgorithmValueConsumer getAnAlgorithmValueConsumer() {
    result = SigningCreateToUseFlow::getCreationFromUse(this, _, _).getAlgorithmArg()
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
    if exists(HashCreateToUseFlow::getCreationFromUse(this, _, _))
    then result = HashCreateToUseFlow::getCreationFromUse(this, _, _)
    else result = this
  }
}

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

  override Crypto::AlgorithmValueConsumer getAnAlgorithmValueConsumer() { result = transform }

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

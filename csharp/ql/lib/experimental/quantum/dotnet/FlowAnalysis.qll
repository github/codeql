private import csharp
private import semmle.code.csharp.dataflow.DataFlow
private import experimental.quantum.Language
private import OperationInstances
private import AlgorithmValueConsumers
private import Cryptography

signature class CreationCallSig instanceof Call;

signature class UseCallSig instanceof QualifiableExpr {
  predicate isIntermediate();
}

module CreationToUseFlow<CreationCallSig Creation, UseCallSig Use> {
  private module CreationToUseConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) {
      source.asExpr() instanceof Creation
      or
      exists(Use use |
        source.asExpr() = use.(QualifiableExpr).getQualifier() and use.isIntermediate()
      )
    }

    predicate isSink(DataFlow::Node sink) {
      exists(Use use | sink.asExpr() = use.(QualifiableExpr).getQualifier())
    }
  }

  private module CreationToUseFlow = DataFlow::Global<CreationToUseConfig>;

  Creation getCreationFromUse(
    Use use, CreationToUseFlow::PathNode source, CreationToUseFlow::PathNode sink
  ) {
    source.getNode().asExpr() = result and
    sink.getNode().asExpr() = use.(QualifiableExpr).getQualifier() and
    CreationToUseFlow::flowPath(source, sink)
  }

  Use getUseFromCreation(
    Creation creation, CreationToUseFlow::PathNode source, CreationToUseFlow::PathNode sink
  ) {
    source.getNode().asExpr() = creation and
    sink.getNode().asExpr() = result.(QualifiableExpr).getQualifier() and
    CreationToUseFlow::flowPath(source, sink)
  }

  Use getIntermediateUseFromUse(
    Use use, CreationToUseFlow::PathNode source, CreationToUseFlow::PathNode sink
  ) {
    // Use sources are always intermediate uses.
    source.getNode().asExpr() = result.(QualifiableExpr).getQualifier() and
    sink.getNode().asExpr() = use.(QualifiableExpr).getQualifier() and
    CreationToUseFlow::flowPath(source, sink)
  }
}

/**
 * Flow from a known ECDsa property access to a `ECDsa.Create(sink)` call.
 */
module SigningNamedCurveToSignatureCreateFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src.asExpr() instanceof NamedCurvePropertyAccess }

  predicate isSink(DataFlow::Node sink) {
    exists(EcdsaAlgorithmValueConsumer consumer | sink = consumer.getInputNode())
  }
}

module SigningNamedCurveToSignatureCreateFlow =
  DataFlow::Global<SigningNamedCurveToSignatureCreateFlowConfig>;

module HashAlgorithmNameToUseConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src.asExpr() instanceof HashAlgorithmName }

  predicate isSink(DataFlow::Node sink) {
    exists(HashAlgorithmNameConsumer consumer | sink = consumer.getInputNode())
  }
}

module HashAlgorithmNameToUse = DataFlow::Global<HashAlgorithmNameToUseConfig>;

module SigningCreateToUseFlow = CreationToUseFlow<SigningCreateCall, SignerUse>;

module HashCreateToUseFlow = CreationToUseFlow<HashAlgorithmCreateCall, HashUse>;

/**
 * A flow analysis module that tracks the flow from a `CryptoStreamMode.READ` or
 * `CryptoStreamMode.WRITE` access to the corresponding `CryptoStream` object
 * creation.
 */
module CryptoStreamModeFlow {
  private module CryptoStreamModeConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) {
      source.asExpr() = any(CryptoStreamMode mode).getAnAccess()
    }

    predicate isSink(DataFlow::Node sink) {
      sink.asExpr() = any(CryptoStreamCreation creation).getModeArg()
    }
  }

  private module CryptoStreamModeFlow = DataFlow::Global<CryptoStreamModeConfig>;

  CryptoStreamMode getModeFromCreation(CryptoStreamCreation creation) {
    exists(CryptoStreamModeFlow::PathNode source, CryptoStreamModeFlow::PathNode sink |
      source.getNode().asExpr() = result.getAnAccess() and
      sink.getNode().asExpr() = creation.getAnArgument() and
      CryptoStreamModeFlow::flowPath(source, sink)
    )
  }
}

/**
 * A flow analysis module that tracks data flow from a `ICryptoTransform`
 * creation (e.g. `Aes.CreateEncryptor()`) to the transform argument of a
 * `CryptoStream` object creation.
 */
module CryptoTransformFlow {
  private module CryptoTransformConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { source.asExpr() instanceof CryptoTransformCreation }

    predicate isSink(DataFlow::Node sink) {
      sink.asExpr() = any(ObjectCreation creation).getAnArgument()
    }
  }

  private module CryptoTransformFlow = DataFlow::Global<CryptoTransformConfig>;

  CryptoTransformCreation getCreationFromUse(ObjectCreation creation) {
    exists(CryptoTransformFlow::PathNode source, CryptoTransformFlow::PathNode sink |
      source.getNode().asExpr() = result and
      sink.getNode().asExpr() = creation.getAnArgument() and
      CryptoTransformFlow::flowPath(source, sink)
    )
  }
}

/**
 * A flow analysis module that tracks the flow from a `PaddingMode` member
 * access (e.g. `PaddingMode.PKCS7`) to a `Padding` property write on a
 * `SymmetricAlgorithm` instance, or from a `CipherMode` member access
 * (e.g. `CipherMode.CBC`) to a `Mode` property write on a `SymmetricAlgorithm`
 * instance.
 *
 * Example:
 * ```
 *  Aes aes = Aes.Create();
 *  aes.Padding = PaddingMode.PKCS7;
 *  ...
 * ```
 */
module ModeLiteralFlow {
  private module ModeLiteralConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) {
      source.asExpr() = any(PaddingMode mode).getAnAccess()
      or
      source.asExpr() = any(CipherMode mode).getAnAccess()
    }

    predicate isSink(DataFlow::Node sink) {
      sink.asExpr() instanceof PaddingPropertyWrite or
      sink.asExpr() instanceof CipherModePropertyWrite
    }

    // TODO: Figure out why this is needed.
    predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
      exists(Assignment assign |
        node1.asExpr() = assign.getRValue() and
        node2.asExpr() = assign.getLValue()
      )
    }
  }

  private module ModeLiteralFlow = DataFlow::Global<ModeLiteralConfig>;

  SymmetricAlgorithmUse getConsumer(
    Expr mode, ModeLiteralFlow::PathNode source, ModeLiteralFlow::PathNode sink
  ) {
    source.getNode().asExpr() = mode and
    sink.getNode().asExpr() = result and
    ModeLiteralFlow::flowPath(source, sink)
  }
}

/**
 * A flow analysis module that tracks the flow from an arbitrary `Stream` object
 * creation to the creation of a second `Stream` object wrapping the first one.
 *
 * This is useful for tracking the flow of data from a buffer passed to a
 * `MemoryStream` to a `CryptoStream` wrapping the original `MemoryStream`. It
 * can also be used to track dataflow from a `Stream` object to a call to
 * `ToArray()` on the stream, or a wrapped stream.
 */
module StreamFlow {
  private class Stream extends Class {
    Stream() { this.getABaseType().hasFullyQualifiedName("System.IO", "Stream") }
  }

  /**
   * A `Stream` object creation.
   */
  private class StreamCreation extends ObjectCreation {
    StreamCreation() { this.getObjectType() instanceof Stream }

    Expr getInputArg() {
      result = this.getAnArgument() and
      result.getType().hasFullyQualifiedName("System", "Byte[]")
    }

    Expr getStreamArg() {
      result = this.getAnArgument() and
      result.getType() instanceof Stream
    }
  }

  private class StreamUse extends MethodCall {
    StreamUse() {
      this.getQualifier().getType() instanceof Stream and
      this.getTarget().hasName("ToArray")
    }

    Expr getOutput() { result = this }
  }

  private module StreamConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { source.asExpr() instanceof StreamCreation }

    predicate isSink(DataFlow::Node sink) {
      sink.asExpr() instanceof StreamCreation
      or
      exists(StreamUse use | sink.asExpr() = use.getQualifier())
    }

    predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
      // Allow flow from one stream wrapped by a second stream.
      exists(StreamCreation creation |
        node1.asExpr() = creation.getStreamArg() and
        node2.asExpr() = creation
      )
      or
      exists(MethodCall copy |
        node1.asExpr() = copy.getQualifier() and
        node2.asExpr() = copy.getAnArgument() and
        copy.getTarget().hasName("CopyTo")
      )
    }
  }

  private module StreamFlow = DataFlow::Global<StreamConfig>;

  StreamCreation getWrappedStream(
    StreamCreation stream, StreamFlow::PathNode source, StreamFlow::PathNode sink
  ) {
    source.getNode().asExpr() = result and
    sink.getNode().asExpr() = stream and
    StreamFlow::flowPath(source, sink)
  }

  StreamUse getStreamUse(
    StreamCreation stream, StreamFlow::PathNode source, StreamFlow::PathNode sink
  ) {
    source.getNode().asExpr() = stream and
    sink.getNode().asExpr() = result.getQualifier() and
    StreamFlow::flowPath(source, sink)
  }
}

/**
 * An additional flow step across property assignments used to track flow from
 * output artifacts to consumers.
 *
 * TODO: Figure out why this is needed.
 */
class PropertyWriteFlowStep extends AdditionalFlowInputStep {
  Assignment assignment;

  PropertyWriteFlowStep() {
    this.asExpr() = assignment.getRValue() and
    assignment.getLValue() instanceof PropertyWrite
  }

  override DataFlow::Node getOutput() { result.asExpr() = assignment.getLValue() }
}

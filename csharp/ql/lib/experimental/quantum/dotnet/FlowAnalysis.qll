private import csharp
private import semmle.code.csharp.dataflow.DataFlow
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
    sink.getNode().asExpr() = use.(MethodCall).getQualifier() and
    CreationToUseFlow::flowPath(source, sink)
  }

  Use getUseFromCreation(
    Creation creation, CreationToUseFlow::PathNode source, CreationToUseFlow::PathNode sink
  ) {
    source.getNode().asExpr() = creation and
    sink.getNode().asExpr() = result.(MethodCall).getQualifier() and
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

  // TODO: Remove this.
  Expr flowsTo(Expr expr) {
    exists(CreationToUseFlow::PathNode source, CreationToUseFlow::PathNode sink |
      source.getNode().asExpr() = expr and
      sink.getNode().asExpr() = result and
      CreationToUseFlow::flowPath(source, sink)
    )
  }
}

/**
 * Flow from a known ECDsa property access to a `ECDsa.Create(sink)` call.
 */
module SigningNamedCurveToSignatureCreateFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src.asExpr() instanceof SigningNamedCurvePropertyAccess }

  predicate isSink(DataFlow::Node sink) {
    exists(ECDsaAlgorithmValueConsumer consumer | sink = consumer.getInputNode())
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

module CryptographyCreateToUseFlow = CreationToUseFlow<CryptographyCreateCall, DotNetSigner>;

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
 * `SymmetricAlgorithm` instance.
 *
 * Example:
 * ```
 *  Aes aes = Aes.Create();
 *  aes.Padding = PaddingMode.PKCS7;
 *  ...
 * ```
 */
module PaddingModeLiteralFlow {
  private module PaddingModeLiteralConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) {
      source.asExpr() = any(PaddingMode mode).getAnAccess()
    }

    predicate isSink(DataFlow::Node sink) { sink.asExpr() instanceof PaddingPropertyWrite }

    // TODO: Figure out why this is needed.
    predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
      exists(Assignment assign |
        node1.asExpr() = assign.getRValue() and
        node2.asExpr() = assign.getLValue()
      )
    }
  }

  private module PaddingModeLiteralFlow = DataFlow::Global<PaddingModeLiteralConfig>;

  SymmetricAlgorithmUse getConsumer(
    Expr mode, PaddingModeLiteralFlow::PathNode source, PaddingModeLiteralFlow::PathNode sink
  ) {
    source.getNode().asExpr() = mode and
    sink.getNode().asExpr() = result and
    PaddingModeLiteralFlow::flowPath(source, sink)
  }
}

/**
 * A flow analysis module that tracks the flow from a `MemoryStream` object
 * creation to the `stream` argument passed to a `CryptoStream` constructor
 * call.
 *
 * TODO: This should probably be made generic over multiple stream types.
 */
module MemoryStreamFlow {
  private class MemoryStreamCreation extends ObjectCreation {
    MemoryStreamCreation() {
      this.getObjectType().hasFullyQualifiedName("System.IO", "MemoryStream")
    }

    Expr getBufferArg() { result = this.getArgument(0) }
  }

  // (Note that we cannot use `CreationToUseFlow` here, because the use is not a
  // `QualifiableExpr`.)
  private module MemoryStreamConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { source.asExpr() instanceof MemoryStreamCreation }

    predicate isSink(DataFlow::Node sink) {
      exists(CryptoStreamCreation creation | sink.asExpr() = creation.getStreamArg())
    }
  }

  private module MemoryStreamFlow = DataFlow::Global<MemoryStreamConfig>;

  MemoryStreamCreation getCreationFromUse(
    CryptoStreamCreation creation, MemoryStreamFlow::PathNode source,
    MemoryStreamFlow::PathNode sink
  ) {
    source.getNode().asExpr() = result and
    sink.getNode().asExpr() = creation.getStreamArg() and
    MemoryStreamFlow::flowPath(source, sink)
  }
}

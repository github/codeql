private import csharp
private import Cryptography
private import AlgorithmValueConsumers

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

signature class CreationCallSig instanceof Call;

signature class UseCallSig instanceof QualifiableExpr {
  predicate isIntermediate();
}

module SigningCreateToUseFlow = CreationToUseFlow<SigningCreateCall, SignerUse>;

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

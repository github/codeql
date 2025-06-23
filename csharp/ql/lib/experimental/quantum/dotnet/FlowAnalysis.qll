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

/**
 * Flow from a known ECDsa property access to a `ECDsa.Create(sink)` call.
 */
private module CreateToUseFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src.asExpr() instanceof CryptographyCreateCall }

  predicate isSink(DataFlow::Node sink) { sink.asExpr() instanceof DotNetSigner }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    node2.asExpr().(DotNetSigner).getQualifier() = node1.asExpr()
  }
}

module CryptographyCreateToUseFlow = DataFlow::Global<CreateToUseFlowConfig>;

module HashAlgorithmNameToUseConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src.asExpr() instanceof HashAlgorithmName }

  predicate isSink(DataFlow::Node sink) {
    exists(HashAlgorithmConsumer consumer | sink = consumer.getInputNode())
  }
}

module HashAlgorithmNameToUse = DataFlow::Global<HashAlgorithmNameToUseConfig>;

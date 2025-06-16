import semmle.code.cpp.dataflow.new.DataFlow
private import Operations.OpenSSLOperations
private import experimental.quantum.Language

/**
 * Flow from key creation to key used in a call
 */
module OpenSslKeyFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    // NOTE/ASSUMPTION: it is assumed the operation is also an OpenSslOperation.
    // All operations modeled for openssl should be modeled as OpenSslOperation.
    exists(Crypto::KeyCreationOperationInstance keygen | keygen.getOutputKeyArtifact() = source)
  }

  predicate isSink(DataFlow::Node sink) { exists(Call call | call.getAnArgument() = sink.asExpr()) }
  //TODO: consideration for additional flow steps? Can a key be copied for example?
}

module OpenSslKeyFlow = TaintTracking::Global<OpenSslKeyFlowConfig>;

Crypto::KeyCreationOperationInstance getSourceKeyCreationInstanceFromArg(Expr arg) {
  exists(DataFlow::Node src, DataFlow::Node sink |
    OpenSslKeyFlow::flow(src, sink) and
    result.getOutputKeyArtifact() = src and
    sink.asExpr() = arg
  )
}

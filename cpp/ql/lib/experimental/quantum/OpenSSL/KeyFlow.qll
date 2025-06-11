import semmle.code.cpp.dataflow.new.DataFlow
private import Operations.OpenSSLOperations
private import experimental.quantum.Language

/**
 * Flow from key creation to key used in a call
 */
module OpenSSLKeyFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    // NOTE/ASSUMPTION: it is assumed the operation is also an OpenSSLOperation.
    // All operations modeled for openssl should be modeled as OpenSSLOperation.
    exists(Crypto::KeyCreationOperationInstance keygen | keygen.getOutputKeyArtifact() = source)
  }

  predicate isSink(DataFlow::Node sink) {
    exists(Call call | call.(Call).getAnArgument() = sink.asExpr())
  }
  //TODO: consideration for additional flow steps? Can a key be copied for example?
}

module OpenSSLKeyFlow = TaintTracking::Global<OpenSSLKeyFlowConfig>;

Crypto::KeyCreationOperationInstance getSourceKeyCreationInstanceFromArg(Expr arg) {
  exists(DataFlow::Node src, DataFlow::Node sink |
    OpenSSLKeyFlow::flow(src, sink) and
    result.getOutputKeyArtifact() = src and
    sink.asExpr() = arg
  )
}

import semmle.code.cpp.dataflow.new.DataFlow
private import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumers

/**
 * Flows from algorithm values to operations, specific to OpenSsl
 */
module AvcToCallArgConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(OpenSslAlgorithmValueConsumer c | c.getResultNode() = source)
  }

  /**
   * Trace to any call accepting the algorithm.
   * NOTE: users must restrict this set to the operations they are interested in.
   */
  predicate isSink(DataFlow::Node sink) { exists(Call c | c.getAnArgument() = sink.asExpr()) }
}

module AvcToCallArgFlow = DataFlow::Global<AvcToCallArgConfig>;

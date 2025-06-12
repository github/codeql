import semmle.code.cpp.dataflow.new.DataFlow
import experimental.quantum.OpenSSL.AlgorithmValueConsumers.OpenSSLAlgorithmValueConsumers

/**
 * Flows from algorithm values to operations, specific to OpenSSL
 */
module AvcToCallArgConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(OpenSSLAlgorithmValueConsumer c | c.getResultNode() = source)
  }

  /**
   * Trace to any call accepting the algorithm.
   * NOTE: users must restrict this set to the operations they are interested in.
   */
  predicate isSink(DataFlow::Node sink) { exists(Call c | c.getAnArgument() = sink.asExpr()) }
}

module AvcToCallArgFlow = DataFlow::Global<AvcToCallArgConfig>;

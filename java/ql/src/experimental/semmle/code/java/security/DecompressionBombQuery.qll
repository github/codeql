deprecated module;

import experimental.semmle.code.java.security.FileAndFormRemoteSource
import experimental.semmle.code.java.security.DecompressionBomb::DecompressionBomb

module DecompressionBombsConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    any(AdditionalStep ads).step(nodeFrom, nodeTo)
  }
}

module DecompressionBombsFlow = TaintTracking::Global<DecompressionBombsConfig>;

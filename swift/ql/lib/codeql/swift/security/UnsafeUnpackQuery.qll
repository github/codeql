/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * unsafe unpack vulnerabilities, as well as extension points for
 * adding your own.
 */

import swift
import codeql.swift.dataflow.TaintTracking
import codeql.swift.dataflow.FlowSources
import codeql.swift.security.UnsafeUnpackExtensions

/**
 * A taint configuration for tainted data that reaches a unsafe unpack sink.
 */
module UnsafeUnpackConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) {
    node instanceof FlowSource or node instanceof RemoteFlowSource
  }

  predicate isSink(DataFlow::Node node) { node instanceof UnsafeUnpackSink }

  predicate isBarrier(DataFlow::Node barrier) { barrier instanceof UnsafeUnpackBarrier }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    any(UnsafeUnpackAdditionalFlowStep s).step(nodeFrom, nodeTo)
  }
}

/**
 * Detect taint flow of tainted data that reaches a unsafe unpack sink.
 */
module UnsafeUnpackFlow = TaintTracking::Global<UnsafeUnpackConfig>;

/**
 * Provides a taint tracking configuration to find insecure TLS
 * configurations.
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import codeql.swift.security.InsecureTLSExtensions

/**
 * A taint config to detect insecure configuration of `NSURLSessionConfiguration`.
 */
module InsecureTlsConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof InsecureTlsExtensionsSource }

  predicate isSink(DataFlow::Node node) { node instanceof InsecureTlsExtensionsSink }

  predicate isBarrier(DataFlow::Node node) { node instanceof InsecureTlsExtensionsBarrier }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    any(InsecureTlsExtensionsAdditionalFlowStep s).step(nodeFrom, nodeTo)
  }
}

module InsecureTlsFlow = TaintTracking::Global<InsecureTlsConfig>;

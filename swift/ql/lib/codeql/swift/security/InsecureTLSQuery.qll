/**
 * Provides a taint tracking configuration to find insecure TLS
 * configurations.
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import codeql.swift.dataflow.FlowSources
import codeql.swift.security.InsecureTLSExtensions

/**
 * A taint config to detect insecure configuration of `NSURLSessionConfiguration`.
 */
module InsecureTlsConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof InsecureTlsExtensionsSource }

  predicate isSink(DataFlow::Node node) { node instanceof InsecureTlsExtensionsSink }

  predicate isBarrier(DataFlow::Node node) { node instanceof InsecureTlsExtensionsSanitizer }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    any(InsecureTlsExtensionsAdditionalTaintStep s).step(nodeFrom, nodeTo)
  }
}

module InsecureTlsFlow = TaintTracking::Global<InsecureTlsConfig>;

/**
 * Provides a taint tracking configuration to find encryption using the
 * ECB encryption mode.
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import codeql.swift.security.ECBEncryptionExtensions

/**
 * A taint configuration from the constructor of ECB mode to expressions that use
 * it to initialize a cipher.
 */
module EcbEncryptionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof EcbEncryptionSource }

  predicate isSink(DataFlow::Node node) { node instanceof EcbEncryptionSink }

  predicate isBarrier(DataFlow::Node node) { node instanceof EcbEncryptionSanitizer }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    any(EcbEncryptionAdditionalTaintStep s).step(nodeFrom, nodeTo)
  }
}

module EcbEncryptionFlow = DataFlow::Global<EcbEncryptionConfig>;

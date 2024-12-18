/**
 * Provides a taint tracking configuration to find encryption using the
 * ECB encryption mode.
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import codeql.swift.security.ECBEncryptionExtensions

/**
 * A data flow configuration from a creation of an ECB mode instance to expressions that use
 * it to initialize a cipher.
 */
module EcbEncryptionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof EcbEncryptionSource }

  predicate isSink(DataFlow::Node node) { node instanceof EcbEncryptionSink }

  predicate isBarrier(DataFlow::Node node) { node instanceof EcbEncryptionBarrier }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    any(EcbEncryptionAdditionalFlowStep s).step(nodeFrom, nodeTo)
  }
}

module EcbEncryptionFlow = DataFlow::Global<EcbEncryptionConfig>;

/**
 * Provides a taint-tracking configuration for reasoning about cleartext
 * preferences storage vulnerabilities.
 */

import swift
import codeql.swift.security.SensitiveExprs
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import codeql.swift.security.CleartextStoragePreferencesExtensions

/**
 * A taint configuration from sensitive information to expressions that are
 * stored as preferences.
 */
module CleartextStoragePreferencesConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node.asExpr() instanceof SensitiveExpr }

  predicate isSink(DataFlow::Node node) { node instanceof CleartextStoragePreferencesSink }

  predicate isBarrier(DataFlow::Node barrier) {
    barrier instanceof CleartextStoragePreferencesBarrier
  }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    any(CleartextStoragePreferencesAdditionalFlowStep s).step(nodeFrom, nodeTo)
  }

  predicate isBarrierIn(DataFlow::Node node) {
    // make sources barriers so that we only report the closest instance
    isSource(node)
  }
}

/**
 * Detect taint flow of sensitive information to expressions that are stored
 * as preferences.
 */
module CleartextStoragePreferencesFlow = TaintTracking::Global<CleartextStoragePreferencesConfig>;

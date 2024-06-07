/**
 * Provides a taint tracking configuration to find use of static
 * initialization vectors for encryption.
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import codeql.swift.security.StaticInitializationVectorExtensions

/**
 * A static IV is created through either a byte array or string literals.
 */
class StaticInitializationVectorSource extends Expr {
  StaticInitializationVectorSource() {
    this instanceof ArrayExpr or
    this instanceof StringLiteralExpr or
    this instanceof NumberLiteralExpr
  }
}

/**
 * A dataflow configuration from the source of a static IV to expressions that use
 * it to initialize a cipher.
 */
module StaticInitializationVectorConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) {
    node.asExpr() instanceof StaticInitializationVectorSource
  }

  predicate isSink(DataFlow::Node node) { node instanceof StaticInitializationVectorSink }

  predicate isBarrier(DataFlow::Node node) { node instanceof StaticInitializationVectorBarrier }

  predicate isBarrierIn(DataFlow::Node node) {
    // make sources barriers so that we only report the closest instance
    isSource(node)
  }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    any(StaticInitializationVectorAdditionalFlowStep s).step(nodeFrom, nodeTo)
  }
}

module StaticInitializationVectorFlow = TaintTracking::Global<StaticInitializationVectorConfig>;

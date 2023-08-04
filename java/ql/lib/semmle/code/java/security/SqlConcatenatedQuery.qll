/** Provides classes and modules to reason about SqlInjection vulnerabilities from string concatentation. */

import java
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.security.SqlConcatenatedLib
private import semmle.code.java.security.SqlInjectionQuery

private class UncontrolledStringBuilderSource extends DataFlow::ExprNode {
  UncontrolledStringBuilderSource() {
    exists(StringBuilderVar sbv |
      uncontrolledStringBuilderQuery(sbv, _) and
      this.getExpr() = sbv.getToStringCall()
    )
  }
}

/**
 * A taint-tracking configuration for reasoning about uncontrolled string builders.
 */
module UncontrolledStringBuilderSourceFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src instanceof UncontrolledStringBuilderSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof QueryInjectionSink }

  predicate isBarrier(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or node.getType() instanceof BoxedType
  }
}

/**
 * Taint-tracking flow for uncontrolled string builders that are used in a SQL query.
 */
module UncontrolledStringBuilderSourceFlow =
  TaintTracking::Global<UncontrolledStringBuilderSourceFlowConfig>;

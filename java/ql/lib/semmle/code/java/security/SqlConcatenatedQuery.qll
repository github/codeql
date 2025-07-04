/** Provides classes and modules to reason about SqlInjection vulnerabilities from string concatentation. */

import java
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.security.SqlConcatenatedLib
private import semmle.code.java.security.SqlInjectionQuery
private import semmle.code.java.security.Sanitizers

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

  predicate isBarrier(DataFlow::Node node) { node instanceof SimpleTypeSanitizer }

  predicate observeDiffInformedIncrementalMode() {
    any() // TODO: Make sure that the location overrides match the query's select clause: Column 1 does not select a source or sink originating from the flow call on line 27 (/Users/d10c/src/semmle-code/ql/java/ql/src/Security/CWE/CWE-089/SqlConcatenated.ql@31:8:31:12), Column 3 does not select a source or sink originating from the flow call on line 27 (/Users/d10c/src/semmle-code/ql/java/ql/src/Security/CWE/CWE-089/SqlConcatenated.ql@31:80:31:91)
  }

  Location getASelectedSourceLocation(DataFlow::Node source) {
    none() // TODO: Make sure that this source location matches the query's select clause: Column 1 does not select a source or sink originating from the flow call on line 27 (/Users/d10c/src/semmle-code/ql/java/ql/src/Security/CWE/CWE-089/SqlConcatenated.ql@31:8:31:12), Column 3 does not select a source or sink originating from the flow call on line 27 (/Users/d10c/src/semmle-code/ql/java/ql/src/Security/CWE/CWE-089/SqlConcatenated.ql@31:80:31:91)
  }

  Location getASelectedSinkLocation(DataFlow::Node sink) {
    none() // TODO: Make sure that this sink location matches the query's select clause: Column 1 does not select a source or sink originating from the flow call on line 27 (/Users/d10c/src/semmle-code/ql/java/ql/src/Security/CWE/CWE-089/SqlConcatenated.ql@31:8:31:12), Column 3 does not select a source or sink originating from the flow call on line 27 (/Users/d10c/src/semmle-code/ql/java/ql/src/Security/CWE/CWE-089/SqlConcatenated.ql@31:80:31:91)
  }
}

/**
 * Taint-tracking flow for uncontrolled string builders that are used in a SQL query.
 */
module UncontrolledStringBuilderSourceFlow =
  TaintTracking::Global<UncontrolledStringBuilderSourceFlowConfig>;

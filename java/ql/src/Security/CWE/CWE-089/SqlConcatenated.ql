/**
 * @name Query built by concatenation with a possibly-untrusted string
 * @description Building a SQL or Java Persistence query by concatenating a possibly-untrusted string
 *              is vulnerable to insertion of malicious code.
 * @kind problem
 * @problem.severity error
 * @security-severity 8.8
 * @precision medium
 * @id java/concatenated-sql-query
 * @tags security
 *       external/cwe/cwe-089
 *       external/cwe/cwe-564
 */

import java
import semmle.code.java.security.SqlConcatenatedLib
import semmle.code.java.security.SqlInjectionQuery

class UncontrolledStringBuilderSource extends DataFlow::ExprNode {
  UncontrolledStringBuilderSource() {
    exists(StringBuilderVar sbv |
      uncontrolledStringBuilderQuery(sbv, _) and
      this.getExpr() = sbv.getToStringCall()
    )
  }
}

class UncontrolledStringBuilderSourceFlowConfig extends TaintTracking::Configuration {
  UncontrolledStringBuilderSourceFlowConfig() {
    this = "SqlConcatenated::UncontrolledStringBuilderSourceFlowConfig"
  }

  override predicate isSource(DataFlow::Node src) { src instanceof UncontrolledStringBuilderSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof QueryInjectionSink }

  override predicate isSanitizer(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or node.getType() instanceof BoxedType
  }
}

from QueryInjectionSink query, Expr uncontrolled
where
  (
    builtFromUncontrolledConcat(query.asExpr(), uncontrolled)
    or
    exists(StringBuilderVar sbv, UncontrolledStringBuilderSourceFlowConfig conf |
      uncontrolledStringBuilderQuery(sbv, uncontrolled) and
      conf.hasFlow(DataFlow::exprNode(sbv.getToStringCall()), query)
    )
  ) and
  not queryTaintedBy(query, _, _)
select query, "Query built by concatenation with $@, which may be untrusted.", uncontrolled,
  "this expression"

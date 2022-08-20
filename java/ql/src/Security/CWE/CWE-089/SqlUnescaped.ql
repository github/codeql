/**
 * @name Query built without neutralizing special characters
 * @description Building a SQL or Java Persistence query without escaping or otherwise neutralizing any special
 *              characters is vulnerable to insertion of malicious code.
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
import semmle.code.java.security.SqlUnescapedLib
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
    this = "SqlUnescaped::UncontrolledStringBuilderSourceFlowConfig"
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
select query, "Query might not neutralize special characters in $@.", uncontrolled,
  "this expression"

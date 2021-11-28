/**
 * @name MyBatis annotation sql injection
 * @description Constructing a dynamic SQL statement with input that comes from an
 *              untrusted source could allow an attacker to modify the statement's
 *              meaning or to execute arbitrary SQL commands.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/sql-injection
 * @tags security
 *       external/cwe/cwe-089
 */

import java
import DataFlow::PathGraph
import MyBatisAnnotationSqlInjectionLib
import semmle.code.java.security.SanitizerGuard
import semmle.code.java.dataflow.FlowSources

private class MyBatisAnnotationSqlInjectionConfiguration extends TaintTracking::Configuration {
  MyBatisAnnotationSqlInjectionConfiguration() { this = "MyBatis annotation sql injection" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    sink instanceof MyBatisAnnotationMethodCallAnArgument
  }

  override predicate isSanitizer(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or
    node.getType() instanceof BoxedType or
    node.getType() instanceof NumberType
  }

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof ContainsSanitizer or guard instanceof EqualsSanitizer
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(MethodAccess ma |
      ma.getMethod().getDeclaringType() instanceof MapType and
      ma.getMethod().getName() = "get" and
      ma.getQualifier() = node1.asExpr() and
      ma = node2.asExpr()
    )
    or
    exists(MethodAccess ma |
      ma.getMethod().getDeclaringType() instanceof TypeObject and
      ma.getMethod().getName() = "toString" and
      ma.getQualifier() = node1.asExpr() and
      ma = node2.asExpr()
    )
  }
}

from
  MyBatisAnnotationSqlInjectionConfiguration cfg, DataFlow::PathNode source,
  DataFlow::PathNode sink, IbatisSqlOperationAnnotation isoa
where
  cfg.hasFlowPath(source, sink) and
  isMybatisAnnotationSqlInjection(sink.getNode(), isoa)
select sink.getNode(), source, sink,
  "MyBatis annotation sql injection might include code from $@ to $@.", source.getNode(),
  "this user input", isoa, "this sql operation"

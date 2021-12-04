/**
 * @name SQL injection in MyBatis annotation
 * @description Constructing a dynamic SQL statement with input that comes from an
 *              untrusted source could allow an attacker to modify the statement's
 *              meaning or to execute arbitrary SQL commands.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/mybatis-annotation-sql-injection
 * @tags security
 *       external/cwe/cwe-089
 */

import java
import DataFlow::PathGraph
import MyBatisCommonLib
import MyBatisAnnotationSqlInjectionLib
import semmle.code.java.dataflow.FlowSources

private class MyBatisAnnotationSqlInjectionConfiguration extends TaintTracking::Configuration {
  MyBatisAnnotationSqlInjectionConfiguration() { this = "MyBatis annotation sql injection" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    sink instanceof MyBatisAnnotatedMethodCallArgument
  }

  override predicate isSanitizer(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or
    node.getType() instanceof BoxedType or
    node.getType() instanceof NumberType
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
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
  isMybatisXmlOrAnnotationSqlInjection(sink.getNode(), _, isoa)
select sink.getNode(), source, sink,
  "MyBatis annotation SQL injection might include code from $@ to $@.", source.getNode(),
  "this user input", isoa, "this SQL operation"

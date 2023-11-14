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
 *       experimental
 *       external/cwe/cwe-089
 */

import java
import MyBatisCommonLib
import MyBatisAnnotationSqlInjectionLib
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import MyBatisAnnotationSqlInjectionFlow::PathGraph

private module MyBatisAnnotationSqlInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ThreatModelFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof MyBatisAnnotatedMethodCallArgument }

  predicate isBarrier(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or
    node.getType() instanceof BoxedType or
    node.getType() instanceof NumberType
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(MethodCall ma |
      ma.getMethod().getDeclaringType() instanceof TypeObject and
      ma.getMethod().getName() = "toString" and
      ma.getQualifier() = node1.asExpr() and
      ma = node2.asExpr()
    )
  }
}

private module MyBatisAnnotationSqlInjectionFlow =
  TaintTracking::Global<MyBatisAnnotationSqlInjectionConfig>;

from
  MyBatisAnnotationSqlInjectionFlow::PathNode source,
  MyBatisAnnotationSqlInjectionFlow::PathNode sink, IbatisSqlOperationAnnotation isoa,
  MethodCall ma, string unsafeExpression
where
  MyBatisAnnotationSqlInjectionFlow::flowPath(source, sink) and
  ma.getAnArgument() = sink.getNode().asExpr() and
  myBatisSqlOperationAnnotationFromMethod(ma.getMethod(), isoa) and
  unsafeExpression = getAMybatisAnnotationSqlValue(isoa) and
  (
    isMybatisXmlOrAnnotationSqlInjection(sink.getNode(), ma, unsafeExpression) or
    isMybatisCollectionTypeSqlInjection(sink.getNode(), ma, unsafeExpression)
  )
select sink.getNode(), source, sink,
  "MyBatis annotation SQL injection might include code from $@ to $@.", source.getNode(),
  "this user input", isoa, "this SQL operation"

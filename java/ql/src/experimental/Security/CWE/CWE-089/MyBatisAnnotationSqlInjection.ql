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
deprecated import MyBatisAnnotationSqlInjectionLib
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.security.Sanitizers
deprecated import MyBatisAnnotationSqlInjectionFlow::PathGraph

deprecated private module MyBatisAnnotationSqlInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof MyBatisAnnotatedMethodCallArgument }

  predicate isBarrier(DataFlow::Node node) { node instanceof SimpleTypeSanitizer }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(MethodCall ma |
      ma.getMethod().getDeclaringType() instanceof TypeObject and
      ma.getMethod().getName() = "toString" and
      ma.getQualifier() = node1.asExpr() and
      ma = node2.asExpr()
    )
  }
}

deprecated private module MyBatisAnnotationSqlInjectionFlow =
  TaintTracking::Global<MyBatisAnnotationSqlInjectionConfig>;

deprecated query predicate problems(
  DataFlow::Node sinkNode, MyBatisAnnotationSqlInjectionFlow::PathNode source,
  MyBatisAnnotationSqlInjectionFlow::PathNode sink, string message1, DataFlow::Node sourceNode,
  string message2, IbatisSqlOperationAnnotation isoa, string message3
) {
  exists(MethodCall ma, string unsafeExpression |
    MyBatisAnnotationSqlInjectionFlow::flowPath(source, sink) and
    ma.getAnArgument() = sinkNode.asExpr() and
    myBatisSqlOperationAnnotationFromMethod(ma.getMethod(), isoa) and
    unsafeExpression = getAMybatisAnnotationSqlValue(isoa) and
    (
      isMybatisXmlOrAnnotationSqlInjection(sinkNode, ma, unsafeExpression) or
      isMybatisCollectionTypeSqlInjection(sinkNode, ma, unsafeExpression)
    )
  ) and
  sinkNode = sink.getNode() and
  message1 = "MyBatis annotation SQL injection might include code from $@ to $@." and
  sourceNode = source.getNode() and
  message2 = "this user input" and
  message3 = "this SQL operation"
}

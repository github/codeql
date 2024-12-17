/**
 * @name SQL injection in MyBatis Mapper XML
 * @description Constructing a dynamic SQL statement with input that comes from an
 *              untrusted source could allow an attacker to modify the statement's
 *              meaning or to execute arbitrary SQL commands.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/mybatis-xml-sql-injection
 * @tags security
 *       experimental
 *       external/cwe/cwe-089
 */

import java
deprecated import MyBatisCommonLib
deprecated import MyBatisMapperXmlSqlInjectionLib
deprecated import semmle.code.xml.MyBatisMapperXML
import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.security.Sanitizers
deprecated import MyBatisMapperXmlSqlInjectionFlow::PathGraph

deprecated private module MyBatisMapperXmlSqlInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof MyBatisMapperMethodCallAnArgument }

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

deprecated private module MyBatisMapperXmlSqlInjectionFlow =
  TaintTracking::Global<MyBatisMapperXmlSqlInjectionConfig>;

deprecated query predicate problems(
  DataFlow::Node sinkNode, MyBatisMapperXmlSqlInjectionFlow::PathNode source,
  MyBatisMapperXmlSqlInjectionFlow::PathNode sink, string message1, DataFlow::Node sourceNode,
  string message2, MyBatisMapperXmlElement mmxe, string message3
) {
  exists(MethodCall ma, string unsafeExpression |
    MyBatisMapperXmlSqlInjectionFlow::flowPath(source, sink) and
    ma.getAnArgument() = sinkNode.asExpr() and
    myBatisMapperXmlElementFromMethod(ma.getMethod(), mmxe) and
    unsafeExpression = getAMybatisXmlSetValue(mmxe) and
    (
      isMybatisXmlOrAnnotationSqlInjection(sinkNode, ma, unsafeExpression)
      or
      mmxe instanceof MyBatisMapperForeach and
      isMybatisCollectionTypeSqlInjection(sinkNode, ma, unsafeExpression)
    )
  ) and
  sinkNode = sink.getNode() and
  message1 = "MyBatis Mapper XML SQL injection might include code from $@ to $@." and
  sourceNode = source.getNode() and
  message2 = "this user input" and
  message3 = "this SQL operation"
}

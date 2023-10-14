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
import MyBatisCommonLib
import MyBatisMapperXmlSqlInjectionLib
import semmle.code.xml.MyBatisMapperXML
import semmle.code.java.dataflow.FlowSources
import MyBatisMapperXmlSqlInjectionFlow::PathGraph

private module MyBatisMapperXmlSqlInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ThreatModelFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof MyBatisMapperMethodCallAnArgument }

  predicate isBarrier(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or
    node.getType() instanceof BoxedType or
    node.getType() instanceof NumberType
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(MethodAccess ma |
      ma.getMethod().getDeclaringType() instanceof TypeObject and
      ma.getMethod().getName() = "toString" and
      ma.getQualifier() = node1.asExpr() and
      ma = node2.asExpr()
    )
  }
}

private module MyBatisMapperXmlSqlInjectionFlow =
  TaintTracking::Global<MyBatisMapperXmlSqlInjectionConfig>;

from
  MyBatisMapperXmlSqlInjectionFlow::PathNode source,
  MyBatisMapperXmlSqlInjectionFlow::PathNode sink, MyBatisMapperXmlElement mmxe, MethodAccess ma,
  string unsafeExpression
where
  MyBatisMapperXmlSqlInjectionFlow::flowPath(source, sink) and
  ma.getAnArgument() = sink.getNode().asExpr() and
  myBatisMapperXmlElementFromMethod(ma.getMethod(), mmxe) and
  unsafeExpression = getAMybatisXmlSetValue(mmxe) and
  (
    isMybatisXmlOrAnnotationSqlInjection(sink.getNode(), ma, unsafeExpression)
    or
    mmxe instanceof MyBatisMapperForeach and
    isMybatisCollectionTypeSqlInjection(sink.getNode(), ma, unsafeExpression)
  )
select sink.getNode(), source, sink,
  "MyBatis Mapper XML SQL injection might include code from $@ to $@.", source.getNode(),
  "this user input", mmxe, "this SQL operation"

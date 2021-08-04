/**
 * @name MyBatis Mapper xml sql injection
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
import MyBatisMapperXmlSqlInjectionLib
import semmle.code.java.dataflow.FlowSources

private class MyBatisMapperXmlSqlInjectionConfiguration extends TaintTracking::Configuration {
  MyBatisMapperXmlSqlInjectionConfiguration() { this = "MyBatis mapper xml sql injection" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    sink instanceof MyBatisMapperMethodCallAnArgument
  }

  override predicate isSanitizer(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or
    node.getType() instanceof BoxedType or
    node.getType() instanceof NumberType
  }
}

from
  MyBatisMapperXmlSqlInjectionConfiguration cfg, DataFlow::PathNode source, DataFlow::PathNode sink,
  XMLElement xmle
where
  cfg.hasFlowPath(source, sink) and
  isSqlInjection(sink.getNode(), xmle)
select sink.getNode(), source, sink,
  "MyBatis Mapper XML sql injection might include code from $@ to $@.", source.getNode(),
  "this user input", xmle, "this sql operation"

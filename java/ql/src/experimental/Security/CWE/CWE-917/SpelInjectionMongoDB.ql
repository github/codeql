/**
 * @name Spring Data MongoDB SpEL Injection
 * @description A Spring Data MongoDB application is vulnerable to SpEL Injection when using 
 *              Query or Aggregation-annotated query methods with SpEL expressions that contain
 *              query parameter placeholders for value binding if the input is not sanitized.
 *              This issue was addressed with the CVE-2022-22980.
 *
 * @kind path-problem
 * @problem-severity warning
 * @precision high
 * @id java/spring-data-mongodb/spel-injection
 * @tags security
 *       experimental
 *       external/cwe/cwe-917
 */
import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.DataFlow
import DataFlow::PathGraph

class MyConf extends DataFlow::Configuration {
  MyConf() { this = "MyConf" }
  
  override predicate isSource(DataFlow::Node source) {
    exists(RemoteFlowSource remote | source.asParameter() = remote.asParameter())
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(Method c, Annotation ann, MethodAccess ma | ann = c.getAnAnnotation() and (ann.toString() = "Query" or ann.toString() = "Aggregation") and ann.getAValue().toString().regexpMatch(".*\\?[0-9].*")
and ma.getMethod() = c and ma.getAnArgument()
 = sink.asExpr())
  }
}

from MyConf conf, DataFlow::PathNode source, DataFlow::PathNode sink
where conf.hasFlowPath(source, sink)
select sink, source, sink, "SpEL Injection found! - CVE-2022-22980"

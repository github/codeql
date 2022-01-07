/**
 * @name Query built from local-user-controlled sources
 * @description Building a SQL or Java Persistence query from user-controlled sources is vulnerable to insertion of
 *              malicious code by the user.
 * @kind path-problem
 * @problem.severity recommendation
 * @security-severity 8.8
 * @precision medium
 * @id java/sql-injection-local
 * @tags security
 *       external/cwe/cwe-089
 *       external/cwe/cwe-564
 */

import semmle.code.java.Expr
import semmle.code.java.dataflow.FlowSources
import SqlInjectionLib
import DataFlow::PathGraph

class LocalUserInputToQueryInjectionFlowConfig extends TaintTracking::Configuration {
  LocalUserInputToQueryInjectionFlowConfig() { this = "LocalUserInputToQueryInjectionFlowConfig" }

  override predicate isSource(DataFlow::Node src) { src instanceof LocalUserInput }

  override predicate isSink(DataFlow::Node sink) { sink instanceof QueryInjectionSink }

  override predicate isSanitizer(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or node.getType() instanceof BoxedType
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(AdditionalQueryInjectionTaintStep s).step(node1, node2)
  }
}

from
  DataFlow::PathNode source, DataFlow::PathNode sink, LocalUserInputToQueryInjectionFlowConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Query might include code from $@.", source.getNode(),
  "this user input"

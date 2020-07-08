/**
 * @name Query built from local-user-controlled sources
 * @description Building a SQL or Java Persistence query from user-controlled sources is vulnerable to insertion of
 *              malicious code by the user.
 * @kind path-problem
 * @problem.severity recommendation
 * @precision medium
 * @id java/sql-injection-local
 * @tags security
 *       external/cwe/cwe-089
 */

import semmle.code.java.Expr
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.SqlInjection
import DataFlow::PathGraph

class LocalUserInputToQueryInjectionFlowConfig extends TaintTracking::Configuration {
  LocalUserInputToQueryInjectionFlowConfig() { this = "LocalUserInputToQueryInjectionFlowConfig" }

  override predicate isSource(DataFlow::Node src) { src instanceof LocalUserInput }

  override predicate isSink(DataFlow::Node sink) { sink instanceof QueryInjectionSink }

  override predicate isSanitizer(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or node.getType() instanceof BoxedType
  }
}

from
  DataFlow::PathNode source, DataFlow::PathNode sink, LocalUserInputToQueryInjectionFlowConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Query might include code from $@.", source.getNode(),
  "this user input"

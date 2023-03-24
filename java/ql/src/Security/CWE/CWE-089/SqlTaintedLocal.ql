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
import semmle.code.java.security.SqlInjectionQuery

module LocalUserInputToQueryInjectionFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src instanceof LocalUserInput }

  predicate isSink(DataFlow::Node sink) { sink instanceof QueryInjectionSink }

  predicate isBarrier(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or node.getType() instanceof BoxedType
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(AdditionalQueryInjectionTaintStep s).step(node1, node2)
  }
}

module LocalUserInputToQueryInjectionFlow =
  TaintTracking::Global<LocalUserInputToQueryInjectionFlowConfig>;

import LocalUserInputToQueryInjectionFlow::PathGraph

from
  LocalUserInputToQueryInjectionFlow::PathNode source,
  LocalUserInputToQueryInjectionFlow::PathNode sink
where LocalUserInputToQueryInjectionFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This query depends on a $@.", source.getNode(),
  "user-provided value"

/**
 * @name Local-user-controlled data in path expression
 * @description Accessing paths influenced by users can allow an attacker to access unexpected resources.
 * @kind path-problem
 * @problem.severity recommendation
 * @security-severity 7.5
 * @precision medium
 * @id java/path-injection-local
 * @tags security
 *       external/cwe/cwe-022
 *       external/cwe/cwe-023
 *       external/cwe/cwe-036
 *       external/cwe/cwe-073
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.PathCreation
import DataFlow::PathGraph
import TaintedPathCommon

class TaintedPathLocalConfig extends TaintTracking::Configuration {
  TaintedPathLocalConfig() { this = "TaintedPathLocalConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof LocalUserInput }

  override predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(PathCreation p).getAnInput()
  }
}

from
  DataFlow::PathNode source, DataFlow::PathNode sink, PathCreation p, Expr e,
  TaintedPathLocalConfig conf
where
  e = sink.getNode().asExpr() and
  e = p.getAnInput() and
  conf.hasFlowPath(source, sink) and
  not guarded(e)
select p, source, sink, "$@ flows to here and is used in a path.", source.getNode(),
  "User-provided value"

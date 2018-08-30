/**
 * @name Local-user-controlled data in path expression
 * @description Accessing paths influenced by users can allow an attacker to access unexpected resources.
 * @kind problem
 * @problem.severity recommendation
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
import PathsCommon

class TaintedPathLocalConfig extends TaintTracking::Configuration {
  TaintedPathLocalConfig() { this = "TaintedPathLocalConfig" }
  override predicate isSource(DataFlow::Node source) { source instanceof LocalUserInput }
  override predicate isSink(DataFlow::Node sink) { sink.asExpr() = any(PathCreation p).getInput() }
}

from LocalUserInput u, PathCreation p, Expr e, TaintedPathLocalConfig conf
where
  e = p.getInput() and
  conf.hasFlow(u, DataFlow::exprNode(e)) and
  not guarded(e)
select p, "$@ flows to here and is used in a path.", u, "User-provided value"

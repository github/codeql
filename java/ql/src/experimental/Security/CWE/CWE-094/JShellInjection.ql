/**
 * @name JShell injection
 * @description Evaluation of a user-controlled JShell expression
 *              may lead to arbitrary code execution.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/jshell-injection
 * @tags security
 *       external/cwe/cwe-094
 */

import java
import JShellInjection
import semmle.code.java.dataflow.FlowSources
import DataFlow::PathGraph

class JShellInjectionConfiguration extends TaintTracking::Configuration {
  JShellInjectionConfiguration() { this = "JShellInjectionConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof JShellInjectionSink }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(SourceCodeAnalysisAnalyzeCompletionCall scaacc |
      scaacc.getArgument(0) = pred.asExpr() and scaacc = succ.asExpr()
    )
    or
    exists(CompletionInfoSourceOrRemainingCall cisorc |
      cisorc.getQualifier() = pred.asExpr() and cisorc = succ.asExpr()
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, JShellInjectionConfiguration conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "JShell injection from $@.", source.getNode(),
  "this user input"

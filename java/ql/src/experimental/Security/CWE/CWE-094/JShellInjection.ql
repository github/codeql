/**
 * @name JShell injection
 * @description Evaluation of a user-controlled JShell expression
 *              may lead to arbitrary code execution.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/jshell-injection
 * @tags security
 *       experimental
 *       external/cwe/cwe-094
 */

import java
import JShellInjection
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import JShellInjectionFlow::PathGraph

module JShellInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ThreatModelFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof JShellInjectionSink }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(SourceCodeAnalysisAnalyzeCompletionCall scaacc |
      scaacc.getArgument(0) = pred.asExpr() and scaacc = succ.asExpr()
    )
    or
    exists(CompletionInfoSourceOrRemainingCall cisorc |
      cisorc.getQualifier() = pred.asExpr() and cisorc = succ.asExpr()
    )
  }
}

module JShellInjectionFlow = TaintTracking::Global<JShellInjectionConfig>;

from JShellInjectionFlow::PathNode source, JShellInjectionFlow::PathNode sink
where JShellInjectionFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "JShell injection from $@.", source.getNode(),
  "this user input"

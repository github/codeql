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
deprecated import JShellInjection
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
deprecated import JShellInjectionFlow::PathGraph

deprecated module JShellInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

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

deprecated module JShellInjectionFlow = TaintTracking::Global<JShellInjectionConfig>;

deprecated query predicate problems(
  DataFlow::Node sinkNode, JShellInjectionFlow::PathNode source, JShellInjectionFlow::PathNode sink,
  string message1, DataFlow::Node sourceNode, string message2
) {
  JShellInjectionFlow::flowPath(source, sink) and
  sinkNode = sink.getNode() and
  message1 = "JShell injection from $@." and
  sourceNode = source.getNode() and
  message2 = "this user input"
}

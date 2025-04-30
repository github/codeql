/**
 * @name BeanShell injection
 * @description Evaluation of a user-controlled BeanShell expression
 *              may lead to arbitrary code execution.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/beanshell-injection
 * @tags security
 *       experimental
 *       external/cwe/cwe-094
 */

import java
deprecated import BeanShellInjection
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
deprecated import BeanShellInjectionFlow::PathGraph

deprecated module BeanShellInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof BeanShellInjectionSink }

  predicate isAdditionalFlowStep(DataFlow::Node prod, DataFlow::Node succ) {
    exists(ClassInstanceExpr cie |
      cie.getConstructedType()
          .hasQualifiedName("org.springframework.scripting.support", "StaticScriptSource") and
      cie.getArgument(0) = prod.asExpr() and
      cie = succ.asExpr()
    )
    or
    exists(MethodCall ma |
      ma.getMethod().hasName("setScript") and
      ma.getMethod()
          .getDeclaringType()
          .hasQualifiedName("org.springframework.scripting.support", "StaticScriptSource") and
      ma.getArgument(0) = prod.asExpr() and
      ma.getQualifier() = succ.asExpr()
    )
  }
}

deprecated module BeanShellInjectionFlow = TaintTracking::Global<BeanShellInjectionConfig>;

deprecated query predicate problems(
  DataFlow::Node sinkNode, BeanShellInjectionFlow::PathNode source,
  BeanShellInjectionFlow::PathNode sink, string message1, DataFlow::Node sourceNode, string message2
) {
  BeanShellInjectionFlow::flowPath(source, sink) and
  sinkNode = sink.getNode() and
  message1 = "BeanShell injection from $@." and
  sourceNode = source.getNode() and
  message2 = "this user input"
}

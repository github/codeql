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
import BeanShellInjection
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import BeanShellInjectionFlow::PathGraph

module BeanShellInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ThreatModelFlowSource }

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

module BeanShellInjectionFlow = TaintTracking::Global<BeanShellInjectionConfig>;

from BeanShellInjectionFlow::PathNode source, BeanShellInjectionFlow::PathNode sink
where BeanShellInjectionFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "BeanShell injection from $@.", source.getNode(),
  "this user input"

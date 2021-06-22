/**
 * @name BeanShell injection
 * @description Evaluation of a user-controlled BeanShell expression
 *              may lead to arbitrary code execution.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/beanshell-injection
 * @tags security
 *       external/cwe/cwe-094
 */

import java
import BeanShellInjection
import semmle.code.java.dataflow.FlowSources
import DataFlow::PathGraph

class BeanShellInjectionConfig extends TaintTracking::Configuration {
  BeanShellInjectionConfig() { this = "BeanShellInjectionConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof BeanShellInjectionSink }

  override predicate isAdditionalTaintStep(DataFlow::Node prod, DataFlow::Node succ) {
    exists(ClassInstanceExpr cie |
      cie.getConstructedType()
          .hasQualifiedName("org.springframework.scripting.support", "StaticScriptSource") and
      cie.getArgument(0) = prod.asExpr() and
      cie = succ.asExpr()
    )
    or
    exists(MethodAccess ma |
      ma.getMethod().hasName("setScript") and
      ma.getMethod()
          .getDeclaringType()
          .hasQualifiedName("org.springframework.scripting.support", "StaticScriptSource") and
      ma.getArgument(0) = prod.asExpr() and
      ma.getQualifier() = succ.asExpr()
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, BeanShellInjectionConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "BeanShell injection from $@.", source.getNode(),
  "this user input"

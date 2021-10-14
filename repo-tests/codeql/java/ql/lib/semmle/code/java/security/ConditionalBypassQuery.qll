/**
 * Provides classes to be used in queries related to vulnerabilities
 * about unstrusted input being used in security decisions.
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.SensitiveActions
import semmle.code.java.controlflow.Guards

/**
 * Holds if `ma` is controlled by the condition expression `e`.
 */
predicate conditionControlsMethod(MethodAccess ma, Expr e) {
  exists(ConditionBlock cb, SensitiveExecutionMethod m, boolean cond |
    ma.getMethod() = m and
    cb.controls(ma.getBasicBlock(), cond) and
    not cb.controls(any(SensitiveExecutionMethod sem).getAReference().getBasicBlock(),
      cond.booleanNot()) and
    not cb.controls(any(ThrowStmt t).getBasicBlock(), cond.booleanNot()) and
    not cb.controls(any(ReturnStmt r).getBasicBlock(), cond.booleanNot()) and
    e = cb.getCondition()
  )
}

/**
 * A taint tracking configuration for untrusted data flowing to sensitive conditions.
 */
class ConditionalBypassFlowConfig extends TaintTracking::Configuration {
  ConditionalBypassFlowConfig() { this = "ConditionalBypassFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { conditionControlsMethod(_, sink.asExpr()) }
}

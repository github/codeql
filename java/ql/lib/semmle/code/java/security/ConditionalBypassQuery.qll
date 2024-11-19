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
predicate conditionControlsMethod(MethodCall ma, Expr e) {
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
 * Holds if `node1` to `node2` is a dataflow step through the
 * `endsWith` method of the `java.lang.String` class.
 */
private predicate endsWithStep(DataFlow::Node node1, DataFlow::Node node2) {
  exists(MethodCall ma |
    ma.getMethod().getDeclaringType() instanceof TypeString and
    ma.getMethod().getName() = "endsWith" and
    ma.getQualifier() = node1.asExpr() and
    ma = node2.asExpr()
  )
}

/**
 * A taint tracking configuration for untrusted data flowing to sensitive conditions.
 */
module ConditionalBypassFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) { conditionControlsMethod(_, sink.asExpr()) }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    endsWithStep(node1, node2)
  }
}

/**
 * Taint tracking flow for untrusted data flowing to sensitive conditions.
 */
module ConditionalBypassFlow = TaintTracking::Global<ConditionalBypassFlowConfig>;

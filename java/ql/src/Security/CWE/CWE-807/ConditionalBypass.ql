/**
 * @name User-controlled bypass of sensitive method
 * @description User-controlled bypassing of sensitive methods may allow attackers to avoid
 *              passing through authentication systems.
 * @kind path-problem
 * @problem.severity error
 * @precision medium
 * @id java/user-controlled-bypass
 * @tags security
 *       external/cwe/cwe-807
 *       external/cwe/cwe-290
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.SensitiveActions
import semmle.code.java.controlflow.Dominance
import semmle.code.java.controlflow.Guards
import DataFlow::PathGraph

/**
 * Calls to a sensitive method that are controlled by a condition
 * on the given expression.
 */
predicate conditionControlsMethod(MethodAccess m, Expr e) {
  exists(ConditionBlock cb, SensitiveExecutionMethod def, boolean cond |
    cb.controls(m.getBasicBlock(), cond) and
    def = m.getMethod() and
    not cb.controls(def.getAReference().getBasicBlock(), cond.booleanNot()) and
    e = cb.getCondition()
  )
}

class ConditionalBypassFlowConfig extends TaintTracking::Configuration {
  ConditionalBypassFlowConfig() { this = "ConditionalBypassFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof UserInput }

  override predicate isSink(DataFlow::Node sink) { conditionControlsMethod(_, sink.asExpr()) }
}

from
  DataFlow::PathNode source, DataFlow::PathNode sink, MethodAccess m, Expr e,
  ConditionalBypassFlowConfig conf
where
  conditionControlsMethod(m, e) and
  sink.getNode().asExpr() = e and
  conf.hasFlowPath(source, sink)
select m, source, sink,
  "Sensitive method may not be executed depending on $@, which flows from $@.", e, "this condition",
  source.getNode(), "user input"

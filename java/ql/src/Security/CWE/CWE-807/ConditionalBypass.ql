/**
 * @name User-controlled bypass of sensitive method
 * @description User-controlled bypassing of sensitive methods may allow attackers to avoid
 *              passing through authentication systems.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision medium
 * @id java/user-controlled-bypass
 * @tags security
 *       external/cwe/cwe-807
 *       external/cwe/cwe-290
 */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.security.ConditionalBypassQuery
import ConditionalBypassFlow::PathGraph

from
  ConditionalBypassFlow::PathNode source, ConditionalBypassFlow::PathNode sink, MethodCall m, Expr e
where
  conditionControlsMethod(m, e) and
  sink.getNode().asExpr() = e and
  ConditionalBypassFlow::flowPath(source, sink)
select m, source, sink,
  "Sensitive method may not be executed depending on a $@, which flows from $@.", e,
  "this condition", source.getNode(), "user-controlled value"

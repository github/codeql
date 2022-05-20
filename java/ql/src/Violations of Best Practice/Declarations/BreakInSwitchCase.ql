/**
 * @name Unterminated switch case
 * @description A 'case' statement that does not contain a 'break' statement allows execution to
 *              'fall through' to the next 'case', which may not be intended.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id java/switch-fall-through
 * @tags reliability
 *       readability
 *       external/cwe/cwe-484
 */

import java
import Common

from SwitchStmt s, Stmt c
where
  c = s.getACase() and
  not c.(ControlFlowNode).getASuccessor() instanceof ConstCase and
  not c.(ControlFlowNode).getASuccessor() instanceof DefaultCase and
  not s.(Annotatable).suppressesWarningsAbout("fallthrough") and
  mayDropThroughWithoutComment(s, c)
select c,
  "Switch case may fall through to the next case. Use a break or return to terminate this case."

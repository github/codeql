/**
 * @name Switch selector is constant
 * @description Finds selectors in switch statements that always evaluate to the same constant
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cs/constant-switch-selector
 * @tags maintainability
 *       readability
 */
import csharp

from SwitchStmt s, Expr e
where e = s.getCondition()
  and exists(e.getValue())
select e, "Selector always evaluates to " + e.getValue() + "."

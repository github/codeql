/**
 * @name An assert statement has a side-effect
 * @description Side-effects in assert statements result in differences between normal
 *              and optimized behavior.
 * @kind problem
 * @tags reliability
 *       maintainability
 * @problem.severity error
 * @sub-severity low
 * @precision high
 * @id py/side-effect-in-assert
 */

import python
private import semmle.python.ApiGraphs::API as API

predicate func_with_side_effects(Expr e) {
  exists(string name | name = e.(Attribute).getName() or name = e.(Name).getId() |
    name in [
        "print", "write", "append", "pop", "remove", "discard", "delete", "close", "open", "exit"
      ]
  )
}

predicate call_with_side_effect(Call e) {
  e.getAFlowNode() = API::moduleImport("subprocess").getMember("call").getACall().getNode()
  or
  e.getAFlowNode() = API::moduleImport("subprocess").getMember("check_call").getACall().getNode()
  or
  e.getAFlowNode() = API::moduleImport("subprocess").getMember("check_output").getACall().getNode()
}

predicate probable_side_effect(Expr e) {
  // Only consider explicit yields, not artificial ones in comprehensions
  e instanceof Yield and not exists(Comp c | c.contains(e))
  or
  e instanceof YieldFrom
  or
  e instanceof Call and func_with_side_effects(e.(Call).getFunc())
  or
  e instanceof Call and call_with_side_effect(e)
}

from Assert a, Expr e
where probable_side_effect(e) and a.contains(e)
select a, "This 'assert' statement contains $@ which may have side effects.", e, "an expression"

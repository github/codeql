/**
 * @name Modification of dictionary returned by locals()
 * @description Modifications of the dictionary returned by locals() are not propagated to the local variables of a function.
 * @kind problem
 * @tags reliability
 *       correctness
 * @problem.severity warning
 * @sub-severity low
 * @precision very-high
 * @id py/modification-of-locals
 */

import python

predicate originIsLocals(ControlFlowNode n) { n.pointsTo(_, _, Value::named("locals").getACall()) }

predicate modification_of_locals(ControlFlowNode f) {
  originIsLocals(f.(SubscriptNode).getObject()) and
  (f.isStore() or f.isDelete())
  or
  exists(string mname, AttrNode attr |
    attr = f.(CallNode).getFunction() and
    originIsLocals(attr.getObject(mname))
  |
    mname in ["pop", "popitem", "update", "clear"]
  )
}

from AstNode a, ControlFlowNode f
where
  modification_of_locals(f) and
  a = f.getNode() and
  // in module level scope `locals() == globals()`
  // see https://docs.python.org/3/library/functions.html#locals
  // FP report in https://github.com/github/codeql/issues/6674
  not a.getScope() instanceof ModuleScope
select a, "Modification of the locals() dictionary will have no effect on the local variables."

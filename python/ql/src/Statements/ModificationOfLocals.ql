/**
 * @name Modification of dictionary returned by locals()
 * @description Modifications of the dictionary returned by locals() are not propagated to the local variables of a function.
 * @kind problem
 * @tags quality
 *       reliability
 *       correctness
 * @problem.severity warning
 * @sub-severity low
 * @precision very-high
 * @id py/modification-of-locals
 */

import python
private import semmle.python.ApiGraphs
private import semmle.python.dataflow.new.DataFlow

predicate originIsLocals(ControlFlowNode n) {
  // Only consider the `locals()` dictionary within the scope that called `locals()`.
  // Once the dictionary is passed to another scope (e.g. as an argument or via an
  // instance attribute) it is just an ordinary mapping, and modifying it is both
  // meaningful and effective. Restricting to local (intraprocedural) flow ensures we
  // only report modifications in the scope where the `locals()` gotcha actually applies.
  exists(DataFlow::LocalSourceNode src, DataFlow::Node use |
    src = API::builtin("locals").getReturn().asSource() and
    src.flowsTo(use) and
    use.asCfgNode() = n
  )
}

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
  not a.getScope() instanceof Module and
  // in class level scope `locals()` reflects the class namespace,
  // so modifications do take effect.
  not a.getScope() instanceof Class
select a, "Modification of the locals() dictionary will have no effect on the local variables."

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

Object aFunctionLocalsObject() {
    exists(Call c, Name n, GlobalVariable v |
        c = result.getOrigin() and
        n = c.getFunc() and
        n.getVariable() = v and
        v.getId() = "locals" and
        c.getScope() instanceof FastLocalsFunction
    )
}



predicate modification_of_locals(ControlFlowNode f) {
    f.(SubscriptNode).getValue().refersTo(aFunctionLocalsObject()) and (f.isStore() or f.isDelete())
    or
    exists(string mname, AttrNode attr |
        attr = f.(CallNode).getFunction() and
        attr.getObject(mname).refersTo(aFunctionLocalsObject(), _) |
        mname = "pop" or
        mname = "popitem" or
        mname = "update" or
        mname = "clear"
    )
}

from AstNode a, ControlFlowNode f
where modification_of_locals(f) and a = f.getNode()

select a, "Modification of the locals() dictionary will have no effect on the local variables."

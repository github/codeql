import python
private import semmle.python.pointsto.Base

/** A control flow node corresponding to a (plain variable) name expression, such as `var`.
 * `None`, `True` and `False` are excluded.
 */
class NameNode extends ControlFlowNode {

    NameNode() {
        exists(Name n | py_flow_bb_node(this, n, _, _))
        or
        exists(PlaceHolder p | py_flow_bb_node(this, p, _, _))
    }

    /** Whether this flow node defines the variable `v`. */
    predicate defines(Variable v) {
        exists(Name d | this.getNode() = d and d.defines(v))
        and not this.isLoad()
    }

    /** Whether this flow node deletes the variable `v`. */
    predicate deletes(Variable v) {
        exists(Name d | this.getNode() = d and d.deletes(v))
    }

    /** Whether this flow node uses the variable `v`. */
    predicate uses(Variable v) {
        this.isLoad() and exists(Name u | this.getNode() = u and u.uses(v))
        or
        exists(PlaceHolder u | this.getNode() = u and u.getVariable() = v and u.getCtx() instanceof Load)
        or
        use_of_global_variable(this, v.getScope(), v.getId())
    }

    string getId() {
        result = this.getNode().(Name).getId()
        or
        result = this.getNode().(PlaceHolder).getId()
    }

    /** Whether this is a use of a local variable. */
    predicate isLocal() {
        local(this)
    }

    /** Whether this is a use of a non-local variable. */
    predicate isNonLocal() {
        non_local(this)
    }

    /** Whether this is a use of a global (including builtin) variable. */
    predicate isGlobal() {
        use_of_global_variable(this, _, _)
    }

    predicate isSelf() {
        exists(SsaVariable selfvar |
          selfvar.isSelf() and selfvar.getAUse() = this
        )
    }

}

private predicate fast_local(NameNode n) {
    exists(FastLocalVariable v |
        n.uses(v) and
        v.getScope() = n.getScope()
    )
}

private predicate local(NameNode n) {
    fast_local(n)
    or
    exists(SsaVariable var |
        var.getAUse() = n and
        n.getScope() instanceof Class and
        exists(var.getDefinition())
    )
}

private predicate non_local(NameNode n) {
    exists(FastLocalVariable flv |
        flv.getALoad() = n.getNode() and
        not flv.getScope() = n.getScope()
    )
}

// magic is fine, but we get questionable join-ordering of it
pragma [nomagic]
private predicate use_of_global_variable(NameNode n, Module scope, string name) {
    n.isLoad() and
    not non_local(n)
    and
    not exists(SsaVariable var |
        var.getAUse() = n |
        var.getVariable() instanceof FastLocalVariable 
        or
        n.getScope() instanceof Class and
        not maybe_undefined(var)
    )
    and name = n.getId() 
    and scope = n.getEnclosingModule()
}

private predicate maybe_defined(SsaVariable var) {
    exists(var.getDefinition()) and not py_ssa_phi(var, _) and not var.getDefinition().isDelete()
    or
    exists(SsaVariable input |
        input = var.getAPhiInput() |
        maybe_defined(input)
    )
}

private predicate maybe_undefined(SsaVariable var) {
    not exists(var.getDefinition()) and not py_ssa_phi(var, _)
    or
    var.getDefinition().isDelete()
    or
    maybe_undefined(var.getAPhiInput())
    or
    exists(BasicBlock incoming |
        exists(var.getAPhiInput()) and 
        incoming.getASuccessor() = var.getDefinition().getBasicBlock() and
        not var.getAPhiInput().getDefinition().getBasicBlock().dominates(incoming)
    )
}

/** A control flow node corresponding to a named constant, one of `None`, `True` or `False`. */
class NameConstantNode extends NameNode {

    NameConstantNode() {
        exists(NameConstant n | py_flow_bb_node(this, n, _, _))
    }

    override deprecated predicate defines(Variable v) { none() }

    override deprecated predicate deletes(Variable v) { none() }

    /* We ought to override uses as well, but that has
     * a serious performance impact.
    deprecated predicate uses(Variable v) { none() }
    */
}

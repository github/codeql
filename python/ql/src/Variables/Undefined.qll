import python
import Loop
import semmle.python.security.TaintTracking

/** Marker for "uninitialized". */
class Uninitialized extends TaintKind {

    Uninitialized() { this = "undefined" }

}

/** A source of an uninitialized variable.
 * Either the start of the scope or a deletion. 
 */
class UninitializedSource extends TaintedDefinition {

    UninitializedSource() {
        exists(FastLocalVariable var |
            this.getSourceVariable() = var and
            not var.escapes() |
            this instanceof ScopeEntryDefinition
            or
            this instanceof DeletionDefinition
        )
    }

    override predicate isSourceOf(TaintKind kind) {
        kind instanceof Uninitialized
    }

}

/** A loop where we are guaranteed (or is at least likely) to execute the body at least once. 
 */
class AtLeastOnceLoop extends DataFlowExtension::DataFlowVariable {

    AtLeastOnceLoop() {
        loop_entry_variables(this, _)
    }

    /* If we are guaranteed to iterate over a loop at least once, then we can prune any edges that
     * don't pass through the body.
     */
    override predicate prunedSuccessor(EssaVariable succ) {
        loop_entry_variables(this, succ)
    }

}

private predicate loop_entry_variables(EssaVariable pred, EssaVariable succ) {
    exists(PhiFunction phi, BasicBlock pb |
        loop_entry_edge(pb, phi.getBasicBlock()) and
        succ = phi.getVariable() and
        pred = phi.getInput(pb)
    )
}

private predicate loop_entry_edge(BasicBlock pred, BasicBlock loop) {
    pred = loop.getAPredecessor() and
    pred = loop.getImmediateDominator() and
    exists(Stmt s |
        loop_probably_executes_at_least_once(s) and
        s.getAFlowNode().getBasicBlock() = loop
    )
}

class UnitializedSanitizer extends Sanitizer {

    UnitializedSanitizer() { this = "use of variable" }

    override
    predicate sanitizingDefinition(TaintKind taint, EssaDefinition def) {
        // An assignment cannot leave a variable uninitialized
        taint instanceof Uninitialized and
        (
            def instanceof AssignmentDefinition
            or
            def instanceof ExceptionCapture
            or
            def instanceof ParameterDefinition
            or
            /* A use is a "sanitizer" of "uninitialized", as any use of an undefined
             * variable will raise, making the subsequent code unreacahable.
             */
            exists(def.(EssaNodeRefinement).getInput().getASourceUse())
            or
            exists(def.(PhiFunction).getAnInput().getASourceUse())
            or
            exists(def.(EssaEdgeRefinement).getInput().getASourceUse())
        )
    }

    override
    predicate sanitizingNode(TaintKind taint, ControlFlowNode node) {
        taint instanceof Uninitialized and
        exists(EssaVariable v |
            v.getASourceUse() = node and
            not first_use(node, v)
        )
    }

}

/** Since any use of a local will raise if it is uninitialized, then
 * any use dominated by another use of the same variable must be defined, or is unreachable.
 */
private predicate first_use(NameNode u, EssaVariable v) {
    v.getASourceUse() = u and
    not exists(NameNode other |
        v.getASourceUse() = other and
        other.strictlyDominates(u)
    )
}

/* Holds if `call` is a call of the form obj.method_name(...) and 
 * there is a function called `method_name` that can exit the program.
 */
private predicate maybe_call_to_exiting_function(CallNode call) {
    exists(FunctionObject exits, string name |
        exits.neverReturns() and exits.getName() = name
        |
        call.getFunction().(NameNode).getId() = name or
        call.getFunction().(AttrNode).getName() = name
    )
}

/** Prune edges where the predecessor block looks like it might contain a call to an exit function. */
class ExitFunctionGuardedEdge extends DataFlowExtension::DataFlowVariable {

    predicate prunedSuccessor(EssaVariable succ) {
        exists(CallNode exit_call |
            succ.(PhiFunction).getInput(exit_call.getBasicBlock()) = this and
            maybe_call_to_exiting_function(exit_call)
        )
    }

}


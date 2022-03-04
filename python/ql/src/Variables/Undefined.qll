import python
import Loop
import semmle.python.dataflow.TaintTracking

/** A marker for "uninitialized". */
class Uninitialized extends TaintKind {
  Uninitialized() { this = "undefined" }
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

/**
 * Since any use of a local will raise if it is uninitialized, then
 * any use dominated by another use of the same variable must be defined, or is unreachable.
 */
private predicate first_use(NameNode u, EssaVariable v) {
  v.getASourceUse() = u and
  not exists(NameNode other |
    v.getASourceUse() = other and
    other.strictlyDominates(u)
  )
}

/**
 * Holds if `call` is a call of the form obj.method_name(...) and
 * there is a function called `method_name` that can exit the program.
 */
private predicate maybe_call_to_exiting_function(CallNode call) {
  exists(FunctionValue exits, string name | exits.neverReturns() and exits.getName() = name |
    call.getFunction().(NameNode).getId() = name or
    call.getFunction().(AttrNode).getName() = name
  )
}

predicate exitFunctionGuardedEdge(EssaVariable pred, EssaVariable succ) {
  exists(CallNode exit_call |
    succ.(PhiFunction).getInput(exit_call.getBasicBlock()) = pred and
    maybe_call_to_exiting_function(exit_call)
  )
}

class UninitializedConfig extends TaintTracking::Configuration {
  UninitializedConfig() { this = "Unitialized local config" }

  override predicate isSource(DataFlow::Node source, TaintKind kind) {
    kind instanceof Uninitialized and
    exists(EssaVariable var |
      source.asVariable() = var and
      var.getSourceVariable() instanceof FastLocalVariable and
      not var.getSourceVariable().(Variable).escapes()
    |
      var instanceof ScopeEntryDefinition
      or
      var instanceof DeletionDefinition
    )
  }

  override predicate isBarrier(DataFlow::Node node, TaintKind kind) {
    kind instanceof Uninitialized and
    (
      definition(node.asVariable())
      or
      use(node.asVariable())
      or
      sanitizingNode(node.asCfgNode())
    )
  }

  private predicate definition(EssaDefinition def) {
    def instanceof AssignmentDefinition
    or
    def instanceof ExceptionCapture
    or
    def instanceof ParameterDefinition
  }

  private predicate use(EssaDefinition def) {
    exists(def.(EssaNodeRefinement).getInput().getASourceUse())
    or
    exists(def.(PhiFunction).getAnInput().getASourceUse())
    or
    exists(def.(EssaEdgeRefinement).getInput().getASourceUse())
  }

  private predicate sanitizingNode(ControlFlowNode node) {
    exists(EssaVariable v |
      v.getASourceUse() = node and
      not first_use(node, v)
    )
  }

  override predicate isBarrierEdge(DataFlow::Node src, DataFlow::Node dest) {
    /*
     * If we are guaranteed to iterate over a loop at least once, then we can prune any edges that
     * don't pass through the body.
     */

    loop_entry_variables(src.asVariable(), dest.asVariable())
    or
    exitFunctionGuardedEdge(src.asVariable(), dest.asVariable())
  }
}

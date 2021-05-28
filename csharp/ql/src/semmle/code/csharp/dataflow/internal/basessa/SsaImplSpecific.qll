/** Provides the C# specific parameters for `SsaImplCommon.qll`. */

private import csharp
private import AssignableDefinitions

class BasicBlock = ControlFlow::BasicBlock;

BasicBlock getImmediateBasicBlockDominator(BasicBlock bb) { result = bb.getImmediateDominator() }

BasicBlock getABasicBlockSuccessor(BasicBlock bb) { result = bb.getASuccessor() }

class ExitBasicBlock = ControlFlow::BasicBlocks::ExitBlock;

pragma[noinline]
private Callable getAnAssigningCallable(LocalScopeVariable v) {
  result = any(AssignableDefinition def | def.getTarget() = v).getEnclosingCallable()
}

class SourceVariable extends LocalScopeVariable {
  SourceVariable() { not getAnAssigningCallable(this) != getAnAssigningCallable(this) }
}

/**
 * Holds if the `i`th node of basic block `bb` is assignable definition `def`,
 * targeting local scope variable `v`.
 */
predicate definitionAt(AssignableDefinition def, BasicBlock bb, int i, SourceVariable v) {
  bb.getNode(i) = def.getAControlFlowNode() and
  v = def.getTarget() and
  // In cases like `(x, x) = (0, 1)`, we discard the first (dead) definition of `x`
  not exists(TupleAssignmentDefinition first, TupleAssignmentDefinition second | first = def |
    second.getAssignment() = first.getAssignment() and
    second.getEvaluationOrder() > first.getEvaluationOrder() and
    second.getTarget() = v
  )
}

predicate variableWrite(BasicBlock bb, int i, SourceVariable v, boolean certain) {
  exists(AssignableDefinition def |
    definitionAt(def, bb, i, v) and
    if def.isCertain() then certain = true else certain = false
  )
}

predicate variableRead(BasicBlock bb, int i, SourceVariable v, boolean certain) {
  exists(AssignableRead read |
    read.getAControlFlowNode() = bb.getNode(i) and
    read.getTarget() = v and
    certain = true
  )
}

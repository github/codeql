/** Provides the C# specific parameters for `SsaImplCommon.qll`. */

private import csharp
private import AssignableDefinitions
private import semmle.code.csharp.controlflow.internal.PreBasicBlocks as PreBasicBlocks
private import semmle.code.csharp.controlflow.internal.ControlFlowGraphImpl

class BasicBlock = PreBasicBlocks::PreBasicBlock;

BasicBlock getImmediateBasicBlockDominator(BasicBlock bb) { result.immediatelyDominates(bb) }

BasicBlock getABasicBlockSuccessor(BasicBlock bb) { result = bb.getASuccessor() }

class ExitBasicBlock extends BasicBlock {
  ExitBasicBlock() { scopeLast(_, this.getLastElement(), _) }
}

/** Holds if `a` is assigned in non-constructor callable `c`. */
pragma[nomagic]
private predicate assignableDefinition(Assignable a, Callable c) {
  exists(AssignableDefinition def | def.getTarget() = a |
    c = def.getEnclosingCallable() and
    not c instanceof Constructor
  )
}

/** Holds if `a` is accessed in callable `c`. */
pragma[nomagic]
private predicate assignableAccess(Assignable a, Callable c) {
  exists(AssignableAccess aa | aa.getTarget() = a | c = aa.getEnclosingCallable())
}

pragma[nomagic]
private predicate assignableNoCapturing(Assignable a, Callable c) {
  assignableAccess(a, c) and
  /*
   * The code below is equivalent to
   * ```ql
   * not exists(Callable other | assignableDefinition(a, other) | other != c)
   * ```
   * but it avoids a Cartesian product in the compiler generated antijoin
   * predicate.
   */

  (
    not assignableDefinition(a, _)
    or
    c = unique(Callable c0 | assignableDefinition(a, c0) | c0)
  )
}

pragma[noinline]
private predicate assignableNoComplexQualifiers(Assignable a) {
  forall(QualifiableExpr qe | qe.(AssignableAccess).getTarget() = a | qe.targetIsThisInstance())
}

/**
 * A simple assignable. Either a local scope variable or a field/property
 * that behaves like a local scope variable.
 */
class SourceVariable extends Assignable {
  private Callable c;

  SourceVariable() {
    (
      this instanceof LocalScopeVariable
      or
      this = any(Field f | not f.isVolatile())
      or
      this = any(TrivialProperty tp | not tp.isOverridableOrImplementable())
    ) and
    assignableNoCapturing(this, c) and
    assignableNoComplexQualifiers(this)
  }

  /** Gets a callable in which this simple assignable can be analyzed. */
  Callable getACallable() { result = c }
}

predicate definitionAt(AssignableDefinition def, BasicBlock bb, int i, SourceVariable v) {
  bb.getElement(i) = def.getExpr() and
  v = def.getTarget() and
  // In cases like `(x, x) = (0, 1)`, we discard the first (dead) definition of `x`
  not exists(TupleAssignmentDefinition first, TupleAssignmentDefinition second | first = def |
    second.getAssignment() = first.getAssignment() and
    second.getEvaluationOrder() > first.getEvaluationOrder() and
    second.getTarget() = v
  )
  or
  def.(ImplicitParameterDefinition).getParameter() = v and
  exists(Callable c | v = c.getAParameter() |
    scopeFirst(c, bb) and
    i = -1
  )
}

predicate implicitEntryDef(Callable c, BasicBlock bb, SourceVariable v) {
  not v instanceof LocalScopeVariable and
  c = v.getACallable() and
  scopeFirst(c, bb)
}

predicate variableWrite(BasicBlock bb, int i, SourceVariable v, boolean certain) {
  exists(AssignableDefinition def |
    definitionAt(def, bb, i, v) and
    if def.getTargetAccess().isRefArgument() then certain = false else certain = true
  )
  or
  exists(Callable c |
    implicitEntryDef(c, bb, v) and
    i = -1 and
    certain = true
  )
}

predicate variableRead(BasicBlock bb, int i, SourceVariable v, boolean certain) {
  exists(AssignableRead read |
    read = bb.getElement(i) and
    read.getTarget() = v and
    certain = true
  )
  or
  v =
    any(LocalScopeVariable lsv |
      lsv.getCallable() = bb.(ExitBasicBlock).getEnclosingCallable() and
      i = bb.length() and
      (lsv.isRef() or v.(Parameter).isOut()) and
      certain = false
    )
}

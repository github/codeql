/**
 * INTERNAL: Do not use.
 *
 * Provides an SSA implementation based on "pre-basic-blocks", restricted
 * to local scope variables and fields/properties that behave like local
 * scope variables.
 *
 * The logic is duplicated from the implementation in `SSA.qll`, and
 * being an internal class, all predicate documentation has been removed.
 */

import csharp
private import AssignableDefinitions
private import semmle.code.csharp.controlflow.internal.PreBasicBlocks
private import semmle.code.csharp.controlflow.ControlFlowGraph::ControlFlow::Internal::Successor
private import semmle.code.csharp.controlflow.Guards as Guards

/**
 * A simple assignable. Either a local scope variable or a field/property
 * that behaves like a local scope variable.
 */
class SimpleAssignable extends Assignable {
  private Callable c;

  SimpleAssignable() {
    (
      this instanceof LocalScopeVariable
      or
      this instanceof Field
      or
      this = any(TrivialProperty tp | not tp.isOverridableOrImplementable())
    ) and
    forall(AssignableDefinition def | def.getTarget() = this |
      c = def.getEnclosingCallable()
      or
      def.getEnclosingCallable() instanceof Constructor
    ) and
    exists(AssignableAccess aa | aa.getTarget() = this | c = aa.getEnclosingCallable()) and
    forall(QualifiableExpr qe | qe.(AssignableAccess).getTarget() = this |
      qe.targetIsThisInstance()
    )
  }

  /** Gets a callable in which this simple assignable can be analyzed. */
  Callable getACallable() { result = c }
}

pragma[noinline]
private predicate phiNodeMaybeLive(PreBasicBlock bb, SimpleAssignable a) {
  exists(PreBasicBlock def | defAt(def, _, _, a) | def.inDominanceFrontier(bb))
}

private newtype TPreSsaDef =
  TExplicitPreSsaDef(PreBasicBlock bb, int i, AssignableDefinition def, SimpleAssignable a) {
    assignableDefAtLive(bb, i, def, a)
  } or
  TImplicitEntryPreSsaDef(Callable c, PreBasicBlock bb, Assignable a) {
    implicitEntryDef(c, bb, a) and
    liveAtEntry(bb, a)
  } or
  TPhiPreSsaDef(PreBasicBlock bb, SimpleAssignable a) {
    phiNodeMaybeLive(bb, a) and
    liveAtEntry(bb, a)
  }

class Definition extends TPreSsaDef {
  string toString() {
    exists(AssignableDefinition def | this = TExplicitPreSsaDef(_, _, def, _) |
      result = def.toString()
    )
    or
    exists(SimpleAssignable a | this = TImplicitEntryPreSsaDef(_, _, a) |
      result = "implicit(" + a + ")"
    )
    or
    exists(SimpleAssignable a | this = TPhiPreSsaDef(_, a) | result = "phi(" + a.toString() + ")")
  }

  SimpleAssignable getAssignable() {
    this = TExplicitPreSsaDef(_, _, _, result)
    or
    this = TImplicitEntryPreSsaDef(_, _, result)
    or
    this = TPhiPreSsaDef(_, result)
  }

  AssignableRead getARead() {
    firstReadSameVar(this, result)
    or
    exists(AssignableRead read | firstReadSameVar(this, read) |
      adjacentReadPairSameVar+(read, result)
    )
  }

  Location getLocation() {
    exists(AssignableDefinition def | this = TExplicitPreSsaDef(_, _, def, _) |
      result = def.getLocation()
    )
    or
    exists(Callable c | this = TImplicitEntryPreSsaDef(c, _, _) | result = c.getLocation())
    or
    exists(PreBasicBlock bb | this = TPhiPreSsaDef(bb, _) | result = bb.getLocation())
  }

  PreBasicBlock getBasicBlock() {
    this = TExplicitPreSsaDef(result, _, _, _)
    or
    this = TImplicitEntryPreSsaDef(_, result, _)
    or
    this = TPhiPreSsaDef(result, _)
  }

  Callable getCallable() { result = this.getBasicBlock().getEnclosingCallable() }

  AssignableDefinition getDefinition() { this = TExplicitPreSsaDef(_, _, result, _) }

  Definition getAPhiInput() {
    exists(PreBasicBlock bb, PreBasicBlock phiPred, SimpleAssignable a |
      this = TPhiPreSsaDef(bb, a)
    |
      bb.getAPredecessor() = phiPred and
      ssaDefReachesEndOfBlock(phiPred, result, a)
    )
  }

  Definition getAnUltimateDefinition() {
    result = this.getAPhiInput*() and
    not this = TPhiPreSsaDef(_, _)
  }
}

predicate implicitEntryDef(Callable c, PreBasicBlock bb, SimpleAssignable a) {
  not a instanceof LocalScopeVariable and
  c = a.getACallable() and
  bb = succEntry(c)
}

private predicate assignableDefAt(
  PreBasicBlock bb, int i, AssignableDefinition def, SimpleAssignable a
) {
  bb.getElement(i) = def.getExpr() and
  a = def.getTarget() and
  // In cases like `(x, x) = (0, 1)`, we discard the first (dead) definition of `x`
  not exists(TupleAssignmentDefinition first, TupleAssignmentDefinition second | first = def |
    second.getAssignment() = first.getAssignment() and
    second.getEvaluationOrder() > first.getEvaluationOrder() and
    second.getTarget() = a
  )
  or
  def.(ImplicitParameterDefinition).getParameter() = a and
  exists(Callable c | a = c.getAParameter() |
    bb = succEntry(c) and
    i = -1
  )
}

private predicate readAt(PreBasicBlock bb, int i, AssignableRead read, SimpleAssignable a) {
  read = bb.getElement(i) and
  read.getTarget() = a
}

pragma[noinline]
private predicate exitBlock(PreBasicBlock bb, Callable c) {
  exists(succExit(bb.getLastElement(), _)) and
  c = bb.getEnclosingCallable()
}

private predicate outRefExitRead(PreBasicBlock bb, int i, LocalScopeVariable v) {
  exitBlock(bb, v.getCallable()) and
  i = bb.length() + 1 and
  (v.isRef() or v.(Parameter).isOut())
}

private newtype RefKind =
  Read() or
  Write(boolean certain) { certain = true or certain = false }

private predicate ref(PreBasicBlock bb, int i, SimpleAssignable a, RefKind k) {
  (readAt(bb, i, _, a) or outRefExitRead(bb, i, a)) and
  k = Read()
  or
  exists(AssignableDefinition def, boolean certain | assignableDefAt(bb, i, def, a) |
    (if def.getTargetAccess().isRefArgument() then certain = false else certain = true) and
    k = Write(certain)
  )
}

private int refRank(PreBasicBlock bb, int i, SimpleAssignable a, RefKind k) {
  i = rank[result](int j | ref(bb, j, a, _)) and
  ref(bb, i, a, k)
}

private int maxRefRank(PreBasicBlock bb, SimpleAssignable a) {
  result = refRank(bb, _, a, _) and
  not result + 1 = refRank(bb, _, a, _)
}

private int firstReadOrCertainWrite(PreBasicBlock bb, SimpleAssignable a) {
  result = min(int r, RefKind k |
      r = refRank(bb, _, a, k) and
      k != Write(false)
    |
      r
    )
}

predicate liveAtEntry(PreBasicBlock bb, SimpleAssignable a) {
  refRank(bb, _, a, Read()) = firstReadOrCertainWrite(bb, a)
  or
  not exists(firstReadOrCertainWrite(bb, a)) and
  liveAtExit(bb, a)
}

private predicate liveAtExit(PreBasicBlock bb, SimpleAssignable a) {
  liveAtEntry(bb.getASuccessor(), a)
}

predicate assignableDefAtLive(PreBasicBlock bb, int i, AssignableDefinition def, SimpleAssignable a) {
  assignableDefAt(bb, i, def, a) and
  exists(int rnk | rnk = refRank(bb, i, a, Write(_)) |
    rnk + 1 = refRank(bb, _, a, Read())
    or
    rnk = maxRefRank(bb, a) and
    liveAtExit(bb, a)
  )
}

predicate defAt(PreBasicBlock bb, int i, Definition def, SimpleAssignable a) {
  def = TExplicitPreSsaDef(bb, i, _, a)
  or
  def = TImplicitEntryPreSsaDef(_, bb, a) and i = -1
  or
  def = TPhiPreSsaDef(bb, a) and i = -1
}

private newtype SsaRefKind =
  SsaRead() or
  SsaDef()

private predicate ssaRef(PreBasicBlock bb, int i, SimpleAssignable a, SsaRefKind k) {
  readAt(bb, i, _, a) and
  k = SsaRead()
  or
  defAt(bb, i, _, a) and
  k = SsaDef()
}

private int ssaRefRank(PreBasicBlock bb, int i, SimpleAssignable a, SsaRefKind k) {
  i = rank[result](int j | ssaRef(bb, j, a, _)) and
  ssaRef(bb, i, a, k)
}

private predicate defReachesRank(PreBasicBlock bb, Definition def, SimpleAssignable a, int rnk) {
  exists(int i |
    rnk = ssaRefRank(bb, i, a, SsaDef()) and
    defAt(bb, i, def, a)
  )
  or
  defReachesRank(bb, def, a, rnk - 1) and
  rnk = ssaRefRank(bb, _, a, SsaRead())
}

private int maxSsaRefRank(PreBasicBlock bb, SimpleAssignable a) {
  result = ssaRefRank(bb, _, a, _) and
  not result + 1 = ssaRefRank(bb, _, a, _)
}

private predicate reachesEndOf(Definition def, SimpleAssignable a, PreBasicBlock bb) {
  exists(int last | last = maxSsaRefRank(bb, a) | defReachesRank(bb, def, a, last))
  or
  exists(PreBasicBlock mid |
    reachesEndOf(def, a, mid) and
    not exists(ssaRefRank(mid, _, a, SsaDef())) and
    bb = mid.getASuccessor()
  )
}

private predicate varOccursInBlock(SimpleAssignable a, PreBasicBlock bb) {
  exists(ssaRefRank(bb, _, a, _))
}

pragma[nomagic]
private predicate blockPrecedesVar(SimpleAssignable a, PreBasicBlock bb) {
  varOccursInBlock(a, bb.getASuccessor*())
}

private predicate varBlockReaches(SimpleAssignable a, PreBasicBlock bb1, PreBasicBlock bb2) {
  varOccursInBlock(a, bb1) and
  bb2 = bb1.getASuccessor() and
  blockPrecedesVar(a, bb2)
  or
  varBlockReachesRec(a, bb1, bb2) and
  blockPrecedesVar(a, bb2)
}

pragma[nomagic]
private predicate varBlockReachesRec(SimpleAssignable a, PreBasicBlock bb1, PreBasicBlock bb2) {
  exists(PreBasicBlock mid | varBlockReaches(a, bb1, mid) |
    bb2 = mid.getASuccessor() and
    not varOccursInBlock(a, mid)
  )
}

private predicate varBlockStep(SimpleAssignable a, PreBasicBlock bb1, PreBasicBlock bb2) {
  varBlockReaches(a, bb1, bb2) and
  varOccursInBlock(a, bb2)
}

private predicate adjacentVarRefs(
  SimpleAssignable a, PreBasicBlock bb1, int i1, PreBasicBlock bb2, int i2
) {
  exists(int rankix |
    bb1 = bb2 and
    rankix = ssaRefRank(bb1, i1, a, _) and
    rankix + 1 = ssaRefRank(bb2, i2, a, _)
  )
  or
  ssaRefRank(bb1, i1, a, _) = maxSsaRefRank(bb1, a) and
  varBlockStep(a, bb1, bb2) and
  ssaRefRank(bb2, i2, a, _) = 1
}

predicate firstReadSameVar(Definition def, AssignableRead read) {
  exists(SimpleAssignable a, PreBasicBlock b1, int i1, PreBasicBlock b2, int i2 |
    adjacentVarRefs(a, b1, i1, b2, i2) and
    defAt(b1, i1, def, a) and
    readAt(b2, i2, read, a)
  )
}

predicate adjacentReadPairSameVar(AssignableRead read1, AssignableRead read2) {
  exists(SimpleAssignable a, PreBasicBlock bb1, int i1, PreBasicBlock bb2, int i2 |
    adjacentVarRefs(a, bb1, i1, bb2, i2) and
    readAt(bb1, i1, read1, a) and
    readAt(bb2, i2, read2, a)
  )
}

pragma[noinline]
private predicate ssaDefReachesEndOfBlockRec(PreBasicBlock bb, Definition def, SimpleAssignable a) {
  exists(PreBasicBlock idom | ssaDefReachesEndOfBlock(idom, def, a) | idom.immediatelyDominates(bb))
}

predicate ssaDefReachesEndOfBlock(PreBasicBlock bb, Definition def, SimpleAssignable a) {
  exists(int last | last = maxSsaRefRank(bb, a) |
    defReachesRank(bb, def, a, last) and
    liveAtExit(bb, a)
  )
  or
  ssaDefReachesEndOfBlockRec(bb, def, a) and
  liveAtExit(bb, a) and
  not ssaRef(bb, _, a, SsaDef())
}

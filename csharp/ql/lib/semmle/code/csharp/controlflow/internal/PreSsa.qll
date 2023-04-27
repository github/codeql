import csharp

/**
 * Provides an SSA implementation based on "pre-basic-blocks", restricted
 * to local scope variables and fields/properties that behave like local
 * scope variables.
 */
module PreSsa {
  private import AssignableDefinitions
  private import semmle.code.csharp.controlflow.internal.ControlFlowGraphImpl
  private import semmle.code.csharp.controlflow.internal.PreBasicBlocks as PreBasicBlocks
  private import codeql.ssa.Ssa as SsaImplCommon

  private predicate definitionAt(
    AssignableDefinition def, SsaInput::BasicBlock bb, int i, SsaInput::SourceVariable v
  ) {
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

  predicate implicitEntryDef(Callable c, SsaInput::BasicBlock bb, SsaInput::SourceVariable v) {
    not v instanceof LocalScopeVariable and
    c = v.getACallable() and
    scopeFirst(c, bb)
  }

  module SsaInput implements SsaImplCommon::InputSig {
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

    predicate variableWrite(BasicBlock bb, int i, SourceVariable v, boolean certain) {
      exists(AssignableDefinition def |
        definitionAt(def, bb, i, v) and
        if def.getTargetAccess().isRefArgument() then certain = false else certain = true
      )
      or
      implicitEntryDef(_, bb, v) and
      i = -1 and
      certain = true
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
  }

  private module SsaImpl = SsaImplCommon::Make<SsaInput>;

  class Definition extends SsaImpl::Definition {
    final AssignableRead getARead() {
      exists(SsaInput::BasicBlock bb, int i |
        SsaImpl::ssaDefReachesRead(_, this, bb, i) and
        result = bb.getElement(i)
      )
    }

    final AssignableDefinition getDefinition() {
      exists(SsaInput::BasicBlock bb, int i, SsaInput::SourceVariable v |
        this.definesAt(v, bb, i) and
        definitionAt(result, bb, i, v)
      )
    }

    final AssignableRead getAFirstRead() {
      exists(SsaInput::BasicBlock bb1, int i1, SsaInput::BasicBlock bb2, int i2 |
        this.definesAt(_, bb1, i1) and
        SsaImpl::adjacentDefRead(this, bb1, i1, bb2, i2) and
        result = bb2.getElement(i2)
      )
    }

    private Definition getAPhiInputOrPriorDefinition() {
      result = this.(PhiNode).getAnInput() or
      SsaImpl::uncertainWriteDefinitionInput(this, result)
    }

    final Definition getAnUltimateDefinition() {
      result = this.getAPhiInputOrPriorDefinition*() and
      not result instanceof PhiNode
    }

    final predicate isLiveAtEndOfBlock(SsaInput::BasicBlock bb) {
      SsaImpl::ssaDefReachesEndOfBlock(bb, this, _)
    }

    Location getLocation() {
      result = this.getDefinition().getLocation()
      or
      exists(Callable c, SsaInput::BasicBlock bb, SsaInput::SourceVariable v |
        this.definesAt(v, bb, -1) and
        implicitEntryDef(c, bb, v) and
        result = c.getLocation()
      )
    }
  }

  class PhiNode extends SsaImpl::PhiNode, Definition {
    final override Location getLocation() { result = this.getBasicBlock().getLocation() }

    final Definition getAnInput() { SsaImpl::phiHasInputFromBlock(this, result, _) }
  }

  predicate adjacentReadPairSameVar(AssignableRead read1, AssignableRead read2) {
    exists(SsaInput::BasicBlock bb1, int i1, SsaInput::BasicBlock bb2, int i2 |
      read1 = bb1.getElement(i1) and
      SsaInput::variableRead(bb1, i1, _, true) and
      SsaImpl::adjacentDefRead(_, bb1, i1, bb2, i2) and
      read2 = bb2.getElement(i2)
    )
  }
}

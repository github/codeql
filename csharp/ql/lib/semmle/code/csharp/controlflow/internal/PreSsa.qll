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
    AssignableDefinition def, PreBasicBlocks::PreBasicBlock bb, int i, SsaInput::SourceVariable v
  ) {
    bb.getNode(i) = def.getExpr() and
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

  predicate implicitEntryDef(
    Callable c, PreBasicBlocks::PreBasicBlock bb, SsaInput::SourceVariable v
  ) {
    c = v.getACallable() and
    scopeFirst(c, bb) and
    (
      not v instanceof LocalScopeVariable
      or
      v.(SimpleLocalScopeVariable).isReadonlyCapturedBy(c)
    )
  }

  /** Holds if `a` is assigned in callable `c`. */
  pragma[nomagic]
  private predicate assignableDefinition(Assignable a, Callable c) {
    exists(AssignableDefinition def |
      def.getTarget() = a and
      c = def.getEnclosingCallable()
    |
      not c instanceof Constructor or
      a instanceof LocalScopeVariable
    )
  }

  pragma[nomagic]
  private predicate assignableUniqueWriter(Assignable a, Callable c) {
    c = unique(Callable c0 | assignableDefinition(a, c0) | c0)
  }

  /** Holds if `a` is accessed in callable `c`. */
  pragma[nomagic]
  private predicate assignableAccess(Assignable a, Callable c) {
    exists(AssignableAccess aa | aa.getTarget() = a | c = aa.getEnclosingCallable())
  }

  /**
   * A local scope variable that is amenable to SSA analysis.
   *
   * This is either a local variable that is not captured, or one
   * where all writes happen in the defining callable.
   */
  class SimpleLocalScopeVariable extends LocalScopeVariable {
    SimpleLocalScopeVariable() { assignableUniqueWriter(this, this.getCallable()) }

    /** Holds if this local scope variable is read-only captured by `c`. */
    predicate isReadonlyCapturedBy(Callable c) {
      assignableAccess(this, c) and
      c != this.getCallable()
    }
  }

  module SsaInput implements SsaImplCommon::InputSig<Location, PreBasicBlocks::PreBasicBlock> {
    private import semmle.code.csharp.Caching

    private class ExitBasicBlock extends PreBasicBlocks::PreBasicBlock {
      ExitBasicBlock() { scopeLast(_, this.getLastNode(), _) }
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
        assignableAccess(this, c) and
        (
          this instanceof SimpleLocalScopeVariable
          or
          (
            this = any(Field f | not f.isVolatile())
            or
            this = any(TrivialProperty tp | not tp.isOverridableOrImplementable())
          ) and
          (
            not assignableDefinition(this, _)
            or
            assignableUniqueWriter(this, c)
          ) and
          assignableNoComplexQualifiers(this)
        )
      }

      /** Gets a callable in which this simple assignable can be analyzed. */
      Callable getACallable() { result = c }
    }

    predicate variableWrite(
      PreBasicBlocks::PreBasicBlock bb, int i, SourceVariable v, boolean certain
    ) {
      Stages::ControlFlowStage::forceCachingInSameStage() and
      exists(AssignableDefinition def |
        definitionAt(def, bb, i, v) and
        if def.getTargetAccess().isRefArgument() then certain = false else certain = true
      )
      or
      implicitEntryDef(_, bb, v) and
      i = -1 and
      certain = true
    }

    predicate variableRead(
      PreBasicBlocks::PreBasicBlock bb, int i, SourceVariable v, boolean certain
    ) {
      exists(AssignableRead read |
        read = bb.getNode(i) and
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

  private module SsaImpl = SsaImplCommon::Make<Location, PreBasicBlocks::PreCfg, SsaInput>;

  class Definition extends SsaImpl::Definition {
    final AssignableRead getARead() {
      exists(PreBasicBlocks::PreBasicBlock bb, int i |
        SsaImpl::ssaDefReachesRead(_, this, bb, i) and
        result = bb.getNode(i)
      )
    }

    final AssignableDefinition getDefinition() {
      exists(PreBasicBlocks::PreBasicBlock bb, int i, SsaInput::SourceVariable v |
        this.definesAt(v, bb, i) and
        definitionAt(result, bb, i, v)
      )
    }

    final AssignableRead getAFirstRead() {
      exists(PreBasicBlocks::PreBasicBlock bb, int i |
        SsaImpl::firstUse(this, bb, i, true) and
        result = bb.getNode(i)
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

    final predicate isLiveAtEndOfBlock(PreBasicBlocks::PreBasicBlock bb) {
      SsaImpl::ssaDefReachesEndOfBlock(bb, this, _)
    }

    override Location getLocation() {
      result = this.getDefinition().getLocation()
      or
      exists(Callable c, PreBasicBlocks::PreBasicBlock bb, SsaInput::SourceVariable v |
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
    exists(PreBasicBlocks::PreBasicBlock bb1, int i1, PreBasicBlocks::PreBasicBlock bb2, int i2 |
      read1 = bb1.getNode(i1) and
      SsaImpl::adjacentUseUse(bb1, i1, bb2, i2, _, true) and
      read2 = bb2.getNode(i2)
    )
  }
}

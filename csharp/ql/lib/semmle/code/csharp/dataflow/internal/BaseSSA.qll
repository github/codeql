import csharp

/**
 * Provides a simple SSA implementation for local scope variables.
 */
module BaseSsa {
  private import AssignableDefinitions
  private import codeql.ssa.Ssa as SsaImplCommon

  cached
  private module BaseSsaStage {
    cached
    predicate ref() { any() }

    cached
    predicate backref() { (exists(any(SsaDefinition def).getARead()) implies any()) }
  }

  /**
   * Holds if the `i`th node of basic block `bb` is assignable definition `def`,
   * targeting local scope variable `v`.
   */
  private predicate definitionAt(
    AssignableDefinition def, BasicBlock bb, int i, SsaImplInput::SourceVariable v
  ) {
    bb.getNode(i) = def.getExpr().getControlFlowNode() and
    v = def.getTarget() and
    // In cases like `(x, x) = (0, 1)`, we discard the first (dead) definition of `x`
    not exists(TupleAssignmentDefinition first, TupleAssignmentDefinition second | first = def |
      second.getAssignment() = first.getAssignment() and
      second.getEvaluationOrder() > first.getEvaluationOrder() and
      second.getTarget() = v
    )
  }

  private predicate entryDef(Callable c, BasicBlock bb, SsaImplInput::SourceVariable v) {
    exists(EntryBasicBlock entry |
      c = entry.getEnclosingCallable() and
      // In case `c` has multiple bodies, we want each body to get its own implicit
      // entry definition. In case `c` doesn't have multiple bodies, the line below
      // is simply the same as `bb = entry`, because `entry.getFirstNode().getASuccessor()`
      // will be in the entry block.
      bb = entry.getFirstNode().getASuccessor().getBasicBlock() and
      c = v.getCallable()
    |
      v.isReadonlyCapturedBy(c)
      or
      v instanceof Parameter
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

  private module SsaImplInput implements SsaImplCommon::InputSig<Location, BasicBlock> {
    class SourceVariable = SimpleLocalScopeVariable;

    predicate variableWrite(BasicBlock bb, int i, SourceVariable v, boolean certain) {
      BaseSsaStage::ref() and
      exists(AssignableDefinition def |
        definitionAt(def, bb, i, v) and
        if def.isCertain() then certain = true else certain = false
      )
      or
      entryDef(_, bb, v) and
      i = -1 and
      certain = true
    }

    predicate variableRead(BasicBlock bb, int i, SourceVariable v, boolean certain) {
      exists(AssignableRead read |
        read.getControlFlowNode() = bb.getNode(i) and
        read.getTarget() = v and
        certain = true
      )
    }
  }

  private module SsaImpl = SsaImplCommon::Make<Location, Cfg, SsaImplInput>;

  private module SsaInput implements SsaImpl::SsaInputSig {
    private import csharp as CS

    class Expr = CS::Expr;

    class Parameter = CS::Parameter;

    class VariableWrite extends AssignableDefinition {
      Expr asExpr() { result = this.getExpr() }

      Expr getValue() { result = this.getSource() }

      predicate isParameterInit(Parameter p) {
        this.(ImplicitParameterDefinition).getParameter() = p
      }
    }

    predicate explicitWrite(VariableWrite w, BasicBlock bb, int i, SsaImplInput::SourceVariable v) {
      definitionAt(w, bb, i, v)
      or
      entryDef(_, bb, v) and
      i = -1 and
      w.isParameterInit(v)
    }
  }

  module Ssa = SsaImpl::MakeSsa<SsaInput>;

  import Ssa
}

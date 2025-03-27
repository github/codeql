private import codeql.ssa.Ssa as SsaImplCommon
private import codeql.ruby.AST
private import codeql.ruby.CFG as Cfg
private import codeql.ruby.controlflow.internal.ControlFlowGraphImpl as ControlFlowGraphImpl
private import codeql.ruby.dataflow.SSA
private import codeql.ruby.ast.Variable
private import Cfg::CfgNodes::ExprNodes

module SsaInput implements SsaImplCommon::InputSig<Location> {
  private import codeql.ruby.controlflow.ControlFlowGraph as Cfg
  private import codeql.ruby.controlflow.BasicBlocks as BasicBlocks

  class BasicBlock = BasicBlocks::BasicBlock;

  class ControlFlowNode = Cfg::CfgNode;

  BasicBlock getImmediateBasicBlockDominator(BasicBlock bb) { result = bb.getImmediateDominator() }

  BasicBlock getABasicBlockSuccessor(BasicBlock bb) { result = bb.getASuccessor() }

  class SourceVariable = LocalVariable;

  /**
   * Holds if the statement at index `i` of basic block `bb` contains a write to variable `v`.
   * `certain` is true if the write definitely occurs.
   */
  predicate variableWrite(BasicBlock bb, int i, SourceVariable v, boolean certain) {
    (
      exists(Scope scope | scope = v.(SelfVariable).getDeclaringScope() |
        // We consider the `self` variable to have a single write at the entry to a method block...
        scope = bb.(BasicBlocks::EntryBasicBlock).getScope() and
        i = 0
        or
        // ...or a class or module block.
        bb.getNode(i).getAstNode() = scope.(ModuleBase).getAControlFlowEntryNode() and
        not scope instanceof Toplevel // handled by case above
      )
      or
      uninitializedWrite(bb, i, v)
      or
      capturedEntryWrite(bb, i, v)
      or
      variableWriteActual(bb, i, v, _)
    ) and
    certain = true
    or
    capturedCallWrite(_, bb, i, v) and
    certain = false
  }

  predicate variableRead(BasicBlock bb, int i, LocalVariable v, boolean certain) {
    variableReadActual(bb, i, v) and
    certain = true
    or
    capturedCallRead(_, bb, i, v) and
    certain = false
    or
    capturedExitRead(bb, i, v) and
    certain = false
    or
    namespaceSelfExitRead(bb, i, v) and
    certain = false
  }
}

import SsaImplCommon::Make<Location, SsaInput> as Impl

class Definition = Impl::Definition;

class WriteDefinition = Impl::WriteDefinition;

class UncertainWriteDefinition = Impl::UncertainWriteDefinition;

class PhiNode = Impl::PhiNode;

module Consistency = Impl::Consistency;

/** Holds if `v` is uninitialized at index `i` in entry block `bb`. */
predicate uninitializedWrite(Cfg::EntryBasicBlock bb, int i, LocalVariable v) {
  v.getDeclaringScope() = bb.getScope() and
  i = -1
}

/** Holds if `bb` contains a captured read of variable `v`. */
pragma[noinline]
private predicate hasCapturedVariableRead(Cfg::BasicBlock bb, LocalVariable v) {
  exists(LocalVariableReadAccessCfgNode read |
    read = bb.getANode() and
    read.getExpr().isCapturedAccess() and
    read.getVariable() = v
  )
}

/** Holds if `bb` contains a captured write to variable `v`. */
pragma[noinline]
private predicate writesCapturedVariable(Cfg::BasicBlock bb, LocalVariable v) {
  exists(LocalVariableWriteAccessCfgNode write |
    write = bb.getANode() and
    write.getVariable() = v and
    v.isCaptured()
  )
}

/**
 * Holds if a pseudo read of captured variable `v` should be inserted
 * at index `i` in exit block `bb`.
 */
private predicate capturedExitRead(Cfg::AnnotatedExitBasicBlock bb, int i, LocalVariable v) {
  bb.isNormal() and
  writesCapturedVariable(bb.getAPredecessor*(), v) and
  i = bb.length()
}

/**
 * Holds if a pseudo read of namespace self-variable `v` should be inserted
 * at index `i` in basic block `bb`. We do this to ensure that namespace
 * self-variables always get an SSA definition.
 */
private predicate namespaceSelfExitRead(Cfg::AnnotatedExitBasicBlock bb, int i, SelfVariable v) {
  exists(Namespace ns, AstNode last |
    v.getDeclaringScope() = ns and
    last = ControlFlowGraphImpl::getAControlFlowExitNode(ns) and
    if last = ns
    then bb.getNode(i).getAPredecessor().getAstNode() = last
    else bb.getNode(i).getAstNode() = last
  )
}

/**
 * Holds if captured variable `v` is read directly inside `scope`,
 * or inside a (transitively) nested scope of `scope`.
 */
pragma[noinline]
private predicate hasCapturedRead(Variable v, Cfg::CfgScope scope) {
  any(LocalVariableReadAccessCfgNode read |
    read.getVariable() = v and scope = read.getScope().getOuterCfgScope*()
  ).getExpr().isCapturedAccess()
}

/**
 * Holds if `v` is written inside basic block `bb` at index `i`, which is in
 * the immediate outer scope of `scope`.
 */
pragma[noinline]
private predicate variableWriteInOuterScope(
  Cfg::BasicBlock bb, int i, LocalVariable v, Cfg::CfgScope scope
) {
  SsaInput::variableWrite(bb, i, v, _) and
  scope.getOuterCfgScope() = bb.getScope()
}

pragma[noinline]
private predicate hasVariableWriteWithCapturedRead(
  Cfg::BasicBlock bb, int i, LocalVariable v, Cfg::CfgScope scope
) {
  hasCapturedRead(v, scope) and
  variableWriteInOuterScope(bb, i, v, scope)
}

/**
 * Holds if the call `call` at index `i` in basic block `bb` may reach
 * a callable that reads captured variable `v`.
 */
private predicate capturedCallRead(CallCfgNode call, Cfg::BasicBlock bb, int i, LocalVariable v) {
  exists(Cfg::CfgScope scope |
    (
      hasVariableWriteWithCapturedRead(bb, any(int j | j < i), v, scope) or
      hasVariableWriteWithCapturedRead(bb.getAPredecessor+(), _, v, scope)
    ) and
    call = bb.getNode(i)
  |
    // If the read happens inside a block, we restrict to the call that
    // contains the block
    not scope instanceof Block
    or
    scope = call.getExpr().(MethodCall).getBlock()
  )
}

/** Holds if `v` is read at index `i` in basic block `bb`. */
private predicate variableReadActual(Cfg::BasicBlock bb, int i, LocalVariable v) {
  exists(VariableReadAccess read |
    read.getVariable() = v and
    read = bb.getNode(i).getAstNode()
  )
}

/**
 * Holds if captured variable `v` is written directly inside `scope`,
 * or inside a (transitively) nested scope of `scope`.
 */
pragma[noinline]
private predicate hasCapturedWrite(Variable v, Cfg::CfgScope scope) {
  any(LocalVariableWriteAccessCfgNode write |
    write.getVariable() = v and scope = write.getScope().getOuterCfgScope*()
  ).getExpr().isCapturedAccess()
}

/**
 * Holds if `v` is read inside basic block `bb` at index `i`, which is in the
 * immediate outer scope of `scope`.
 */
pragma[noinline]
private predicate variableReadActualInOuterScope(
  Cfg::BasicBlock bb, int i, LocalVariable v, Cfg::CfgScope scope
) {
  variableReadActual(bb, i, v) and
  bb.getScope() = scope.getOuterCfgScope()
}

pragma[noinline]
private predicate hasVariableReadWithCapturedWrite(
  Cfg::BasicBlock bb, int i, LocalVariable v, Cfg::CfgScope scope
) {
  hasCapturedWrite(v, scope) and
  variableReadActualInOuterScope(bb, i, v, scope)
}

pragma[noinline]
deprecated private predicate adjacentDefReadExt(
  Definition def, SsaInput::BasicBlock bb1, int i1, SsaInput::BasicBlock bb2, int i2,
  SsaInput::SourceVariable v
) {
  Impl::adjacentDefReadExt(def, _, bb1, i1, bb2, i2) and
  v = def.getSourceVariable()
}

deprecated private predicate adjacentDefReachesReadExt(
  Definition def, SsaInput::BasicBlock bb1, int i1, SsaInput::BasicBlock bb2, int i2
) {
  exists(SsaInput::SourceVariable v | adjacentDefReadExt(def, bb1, i1, bb2, i2, v) |
    def.definesAt(v, bb1, i1)
    or
    SsaInput::variableRead(bb1, i1, v, true)
  )
  or
  exists(SsaInput::BasicBlock bb3, int i3 |
    adjacentDefReachesReadExt(def, bb1, i1, bb3, i3) and
    SsaInput::variableRead(bb3, i3, _, false) and
    Impl::adjacentDefReadExt(def, _, bb3, i3, bb2, i2)
  )
}

deprecated private predicate adjacentDefReachesUncertainReadExt(
  Definition def, SsaInput::BasicBlock bb1, int i1, SsaInput::BasicBlock bb2, int i2
) {
  adjacentDefReachesReadExt(def, bb1, i1, bb2, i2) and
  SsaInput::variableRead(bb2, i2, _, false)
}

/** Same as `lastRefRedef`, but skips uncertain reads. */
pragma[nomagic]
deprecated private predicate lastRefSkipUncertainReadsExt(
  Definition def, SsaInput::BasicBlock bb, int i
) {
  Impl::lastRef(def, bb, i) and
  not SsaInput::variableRead(bb, i, def.getSourceVariable(), false)
  or
  exists(SsaInput::BasicBlock bb0, int i0 |
    Impl::lastRef(def, bb0, i0) and
    adjacentDefReachesUncertainReadExt(def, bb, i, bb0, i0)
  )
}

/**
 * Holds if the read of `def` at `read` may be a last read. That is, `read`
 * can either reach another definition of the underlying source variable or
 * the end of the CFG scope, without passing through another non-pseudo read.
 */
pragma[nomagic]
deprecated predicate lastRead(Definition def, VariableReadAccessCfgNode read) {
  exists(Cfg::BasicBlock bb, int i |
    lastRefSkipUncertainReadsExt(def, bb, i) and
    variableReadActual(bb, i, _) and
    read = bb.getNode(i)
  )
}

cached
private module Cached {
  /**
   * Holds if an entry definition is needed for captured variable `v` at index
   * `i` in entry block `bb`.
   */
  cached
  predicate capturedEntryWrite(Cfg::EntryBasicBlock bb, int i, LocalVariable v) {
    hasCapturedVariableRead(bb.getASuccessor*(), v) and
    i = -1
  }

  /**
   * Holds if the call `call` at index `i` in basic block `bb` may reach a callable
   * that writes captured variable `v`.
   */
  cached
  predicate capturedCallWrite(CallCfgNode call, Cfg::BasicBlock bb, int i, LocalVariable v) {
    exists(Cfg::CfgScope scope |
      (
        hasVariableReadWithCapturedWrite(bb, any(int j | j > i), v, scope)
        or
        hasVariableReadWithCapturedWrite(bb.getASuccessor+(), _, v, scope)
      ) and
      call = bb.getNode(i)
    |
      // If the write happens inside a block, we restrict to the call that
      // contains the block
      not scope instanceof Block
      or
      scope = call.getExpr().(MethodCall).getBlock()
    )
  }

  /**
   * Holds if `v` is written at index `i` in basic block `bb`, and the corresponding
   * AST write access is `write`.
   */
  cached
  predicate variableWriteActual(
    Cfg::BasicBlock bb, int i, LocalVariable v, VariableWriteAccessCfgNode write
  ) {
    exists(Cfg::CfgNode n |
      write.getVariable() = v and
      n = bb.getNode(i)
    |
      write.isExplicitWrite(n)
      or
      write.isImplicitWrite() and
      n = write
    )
  }

  cached
  VariableReadAccessCfgNode getARead(Definition def) {
    exists(LocalVariable v, Cfg::BasicBlock bb, int i |
      Impl::ssaDefReachesRead(v, def, bb, i) and
      variableReadActual(bb, i, v) and
      result = bb.getNode(i)
    )
  }

  private import codeql.ruby.dataflow.SSA

  cached
  Definition phiHasInputFromBlock(PhiNode phi, Cfg::BasicBlock bb) {
    Impl::phiHasInputFromBlock(phi, result, bb)
  }

  /**
   * Holds if the value defined at SSA definition `def` can reach a read at `read`,
   * without passing through any other non-pseudo read.
   */
  cached
  predicate firstRead(Definition def, VariableReadAccessCfgNode read) {
    exists(Cfg::BasicBlock bb, int i | Impl::firstUse(def, bb, i, true) and read = bb.getNode(i))
  }

  /**
   * Holds if the read at `read2` is a read of the same SSA definition `def`
   * as the read at `read1`, and `read2` can be reached from `read1` without
   * passing through another non-pseudo read.
   */
  cached
  predicate adjacentReadPair(
    Definition def, VariableReadAccessCfgNode read1, VariableReadAccessCfgNode read2
  ) {
    exists(Cfg::BasicBlock bb1, int i1, Cfg::BasicBlock bb2, int i2, LocalVariable v |
      Impl::ssaDefReachesRead(v, def, bb1, i1) and
      Impl::adjacentUseUse(bb1, i1, bb2, i2, v, true) and
      read1 = bb1.getNode(i1) and
      read2 = bb2.getNode(i2)
    )
  }

  cached
  Definition uncertainWriteDefinitionInput(UncertainWriteDefinition def) {
    Impl::uncertainWriteDefinitionInput(def, result)
  }

  cached
  module DataFlowIntegration {
    import DataFlowIntegrationImpl

    cached
    predicate localFlowStep(
      SsaInput::SourceVariable v, Node nodeFrom, Node nodeTo, boolean isUseStep
    ) {
      DataFlowIntegrationImpl::localFlowStep(v, nodeFrom, nodeTo, isUseStep)
    }

    cached
    predicate localMustFlowStep(SsaInput::SourceVariable v, Node nodeFrom, Node nodeTo) {
      DataFlowIntegrationImpl::localMustFlowStep(v, nodeFrom, nodeTo)
    }

    signature predicate guardChecksSig(Cfg::CfgNodes::AstCfgNode g, Cfg::CfgNode e, boolean branch);

    cached // nothing is actually cached
    module BarrierGuard<guardChecksSig/3 guardChecks> {
      private predicate guardChecksAdjTypes(
        DataFlowIntegrationInput::Guard g, DataFlowIntegrationInput::Expr e, boolean branch
      ) {
        guardChecks(g, e, branch)
      }

      private Node getABarrierNodeImpl() {
        result = DataFlowIntegrationImpl::BarrierGuard<guardChecksAdjTypes/3>::getABarrierNode()
      }

      predicate getABarrierNode = getABarrierNodeImpl/0;
    }
  }
}

import Cached

class NormalParameter extends Parameter {
  NormalParameter() {
    this instanceof SimpleParameter or
    this instanceof OptionalParameter or
    this instanceof KeywordParameter or
    this instanceof HashSplatParameter or
    this instanceof SplatParameter or
    this instanceof BlockParameter
  }
}

/** Gets the SSA definition node corresponding to parameter `p`. */
pragma[nomagic]
Definition getParameterDef(NamedParameter p) {
  exists(Cfg::BasicBlock bb, int i |
    bb.getNode(i).getAstNode() = p.getDefiningAccess() and
    result.definesAt(_, bb, i)
  )
}

private newtype TParameterExt =
  TNormalParameter(NormalParameter p) or
  TSelfMethodParameter(MethodBase m) or
  TSelfToplevelParameter(Toplevel t)

/** A normal parameter or an implicit `self` parameter. */
class ParameterExt extends TParameterExt {
  NormalParameter asParameter() { this = TNormalParameter(result) }

  MethodBase asMethodSelf() { this = TSelfMethodParameter(result) }

  Toplevel asToplevelSelf() { this = TSelfToplevelParameter(result) }

  predicate isInitializedBy(WriteDefinition def) {
    def = getParameterDef(this.asParameter())
    or
    def.(Ssa::SelfDefinition).getSourceVariable().getDeclaringScope() =
      [this.asMethodSelf().(Scope), this.asToplevelSelf()]
  }

  string toString() {
    result =
      [
        this.asParameter().toString(), this.asMethodSelf().toString(),
        this.asToplevelSelf().toString()
      ]
  }

  Location getLocation() {
    result =
      [
        this.asParameter().getLocation(), this.asMethodSelf().getLocation(),
        this.asToplevelSelf().getLocation()
      ]
  }
}

private module DataFlowIntegrationInput implements Impl::DataFlowIntegrationInputSig {
  private import codeql.ruby.controlflow.internal.Guards as Guards

  class Expr extends Cfg::CfgNodes::ExprCfgNode {
    predicate hasCfgNode(SsaInput::BasicBlock bb, int i) { this = bb.getNode(i) }
  }

  Expr getARead(Definition def) { result = Cached::getARead(def) }

  class Guard extends Cfg::CfgNodes::AstCfgNode {
    /**
     * Holds if the control flow branching from `bb1` is dependent on this guard,
     * and that the edge from `bb1` to `bb2` corresponds to the evaluation of this
     * guard to `branch`.
     */
    predicate controlsBranchEdge(SsaInput::BasicBlock bb1, SsaInput::BasicBlock bb2, boolean branch) {
      exists(Cfg::SuccessorTypes::ConditionalSuccessor s |
        this.getBasicBlock() = bb1 and
        bb2 = bb1.getASuccessor(s) and
        s.getValue() = branch
      )
    }
  }

  /** Holds if the guard `guard` controls block `bb` upon evaluating to `branch`. */
  predicate guardDirectlyControlsBlock(Guard guard, SsaInput::BasicBlock bb, boolean branch) {
    Guards::guardControlsBlock(guard, bb, branch)
  }
}

private module DataFlowIntegrationImpl = Impl::DataFlowIntegration<DataFlowIntegrationInput>;

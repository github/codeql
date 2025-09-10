private import rust
private import codeql.rust.controlflow.BasicBlocks as BasicBlocks
private import BasicBlocks
private import codeql.rust.controlflow.ControlFlowGraph as Cfg
private import codeql.rust.controlflow.CfgNodes as CfgNodes
private import Cfg
private import codeql.rust.controlflow.internal.ControlFlowGraphImpl as ControlFlowGraphImpl
private import codeql.ssa.Ssa as SsaImplCommon

/**
 * Holds if `name` occurs in the left-hand side of an uninitialized let
 * statement such as in `let name : i64;`.
 */
private predicate isInUninitializedLet(Name name) {
  exists(LetStmt let |
    let.getPat().(IdentPat).getName() = name and
    not let.hasInitializer()
  )
}

/** Holds if `write` writes to variable `v`. */
predicate variableWrite(AstNode write, Variable v) {
  exists(Name name |
    name = write and
    name = v.getName() and
    not isInUninitializedLet(name)
  )
  or
  exists(VariableAccess access |
    access = write and
    access.getVariable() = v
  |
    access instanceof VariableWriteAccess
    or
    // Although compound assignments, like `x += y`, may in fact not update `x`,
    // it makes sense to treat them as such
    access = any(CompoundAssignmentExpr cae).getLhs()
  )
}

private predicate variableReadCertain(BasicBlock bb, int i, VariableAccess va, Variable v) {
  bb.getNode(i).getAstNode() = va and
  va = v.getAnAccess() and
  (
    va instanceof VariableReadAccess
    or
    // For immutable variables, we model a read when they are borrowed
    // (although the actual read happens later, if at all).
    va = any(RefExpr re).getExpr()
    or
    // Although compound assignments, like `x += y`, may in fact not read `x`,
    // it makes sense to treat them as such
    va = any(CompoundAssignmentExpr cae).getLhs()
  )
}

module SsaInput implements SsaImplCommon::InputSig<Location, BasicBlock> {
  class SourceVariable = Variable;

  predicate variableWrite(BasicBlock bb, int i, SourceVariable v, boolean certain) {
    (
      variableWriteActual(bb, i, v, _)
      or
      capturedEntryWrite(bb, i, v)
    ) and
    certain = true
    or
    (
      capturedCallWrite(_, bb, i, v)
      or
      mutablyBorrows(bb.getNode(i).getAstNode(), v)
    ) and
    certain = false
  }

  predicate variableRead(BasicBlock bb, int i, SourceVariable v, boolean certain) {
    variableReadCertain(bb, i, _, v) and
    certain = true
    or
    capturedCallRead(_, bb, i, v) and certain = false
    or
    capturedExitRead(bb, i, v) and certain = false
  }
}

import SsaImplCommon::Make<Location, BasicBlocks::Cfg, SsaInput> as Impl

class Definition = Impl::Definition;

class WriteDefinition = Impl::WriteDefinition;

class UncertainWriteDefinition = Impl::UncertainWriteDefinition;

class PhiDefinition = Impl::PhiNode;

module Consistency = Impl::Consistency;

/**
 * Holds if captured variable `v` is written directly inside `scope`,
 * or inside a (transitively) nested scope of `scope`.
 */
pragma[noinline]
private predicate hasCapturedWrite(Variable v, Cfg::CfgScope scope) {
  any(VariableWriteAccess write | write.getVariable() = v and scope = write.getEnclosingCfgScope+())
      .isCapture()
}

/**
 * Holds if `v` is read inside basic block `bb` at index `i`, which is in the
 * immediate outer CFG scope of `scope`.
 */
pragma[noinline]
private predicate variableReadCertainInOuterScope(
  BasicBlock bb, int i, Variable v, Cfg::CfgScope scope
) {
  variableReadCertain(bb, i, _, v) and bb.getScope() = scope.getEnclosingCfgScope()
}

pragma[noinline]
private predicate hasVariableReadWithCapturedWrite(
  BasicBlock bb, int i, Variable v, Cfg::CfgScope scope
) {
  hasCapturedWrite(v, scope) and
  variableReadCertainInOuterScope(bb, i, v, scope)
}

private VariableAccess getACapturedVariableAccess(BasicBlock bb, Variable v) {
  result = bb.getANode().getAstNode() and
  result.isCapture() and
  result.getVariable() = v
}

/** Holds if `bb` contains a captured write to variable `v`. */
pragma[noinline]
private predicate writesCapturedVariable(BasicBlock bb, Variable v) {
  getACapturedVariableAccess(bb, v) instanceof VariableWriteAccess
}

/**
 * Holds if captured variable `v` is read directly inside `scope`,
 * or inside a (transitively) nested scope of `scope`.
 */
pragma[noinline]
private predicate hasCapturedRead(Variable v, Cfg::CfgScope scope) {
  any(VariableReadAccess read | read.getVariable() = v and scope = read.getEnclosingCfgScope+())
      .isCapture()
}

/**
 * Holds if `v` is written inside basic block `bb` at index `i`, which is in
 * the immediate outer scope of `scope`.
 */
pragma[noinline]
private predicate variableWriteInOuterScope(BasicBlock bb, int i, Variable v, Cfg::CfgScope scope) {
  SsaInput::variableWrite(bb, i, v, _) and scope.getEnclosingCfgScope() = bb.getScope()
}

/** Holds if evaluating `e` jumps to the evaluation of a different CFG scope. */
private predicate isControlFlowJump(Expr e) { e instanceof CallExprBase or e instanceof AwaitExpr }

/**
 * Holds if the call `call` at index `i` in basic block `bb` may reach
 * a callable that reads captured variable `v`.
 */
private predicate capturedCallRead(Expr call, BasicBlock bb, int i, Variable v) {
  isControlFlowJump(call) and
  exists(Cfg::CfgScope scope |
    hasCapturedRead(pragma[only_bind_into](v), pragma[only_bind_into](scope)) and
    (
      variableWriteInOuterScope(bb, any(int j | j < i), v, scope) or
      variableWriteInOuterScope(bb.getImmediateDominator+(), _, v, scope)
    ) and
    call = bb.getNode(i).getAstNode()
  )
}

/**
 * Holds if the call `call` at index `i` in basic block `bb` may reach a callable
 * that writes captured variable `v`.
 */
predicate capturedCallWrite(Expr call, BasicBlock bb, int i, Variable v) {
  isControlFlowJump(call) and
  call = bb.getNode(i).getAstNode() and
  exists(Cfg::CfgScope scope |
    hasVariableReadWithCapturedWrite(bb, any(int j | j > i), v, scope)
    or
    hasVariableReadWithCapturedWrite(bb.getASuccessor+(), _, v, scope)
  )
}

/** Holds if `v` may be mutably borrowed in `e`. */
private predicate mutablyBorrows(Expr e, Variable v) {
  e = any(MethodCallExpr mc).getReceiver() and
  e.(VariableAccess).getVariable() = v and
  v.isMutable()
  or
  exists(RefExpr re | re = e and re.isMut() and re.getExpr().(VariableAccess).getVariable() = v)
}

/**
 * Holds if a pseudo read of captured variable `v` should be inserted
 * at index `i` in exit block `bb`.
 */
private predicate capturedExitRead(AnnotatedExitBasicBlock bb, int i, Variable v) {
  bb.isNormal() and
  writesCapturedVariable(bb.getAPredecessor*(), v) and
  i = bb.length()
}

cached
private module Cached {
  /**
   * Holds if an entry definition is needed for captured variable `v` at index
   * `i` in entry block `bb`.
   */
  cached
  predicate capturedEntryWrite(EntryBasicBlock bb, int i, Variable v) {
    exists(getACapturedVariableAccess(bb.getASuccessor*(), v)) and
    i = -1
  }

  /**
   * Holds if `v` is written at index `i` in basic block `bb`, and the corresponding
   * write access node in the CFG is `write`.
   */
  cached
  predicate variableWriteActual(BasicBlock bb, int i, Variable v, CfgNode write) {
    bb.getNode(i) = write and
    variableWrite(write.getAstNode(), v)
  }

  cached
  CfgNode getARead(Definition def) {
    exists(Variable v, BasicBlock bb, int i |
      Impl::ssaDefReachesRead(v, def, bb, i) and
      variableReadCertain(bb, i, v.getAnAccess(), v) and
      result = bb.getNode(i)
    )
  }

  cached
  Definition phiHasInputFromBlock(PhiDefinition phi, BasicBlock bb) {
    Impl::phiHasInputFromBlock(phi, result, bb)
  }

  /**
   * Holds if the value defined at SSA definition `def` can reach a read at `read`,
   * without passing through any other non-pseudo read.
   */
  cached
  predicate firstRead(Definition def, CfgNode read) {
    exists(BasicBlock bb, int i | Impl::firstUse(def, bb, i, true) and read = bb.getNode(i))
  }

  /**
   * Holds if the read at `read2` is a read of the same SSA definition `def`
   * as the read at `read1`, and `read2` can be reached from `read1` without
   * passing through another non-pseudo read.
   */
  cached
  predicate adjacentReadPair(Definition def, CfgNode read1, CfgNode read2) {
    exists(BasicBlock bb1, int i1, BasicBlock bb2, int i2, Variable v |
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

    signature predicate guardChecksSig(CfgNodes::AstCfgNode g, Cfg::CfgNode e, boolean branch);

    cached // nothing is actually cached
    module BarrierGuard<guardChecksSig/3 guardChecks> {
      private predicate guardChecksAdjTypes(
        DataFlowIntegrationInput::Guard g, DataFlowIntegrationInput::Expr e,
        DataFlowIntegrationInput::GuardValue branch
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
private import codeql.rust.dataflow.Ssa

private module DataFlowIntegrationInput implements Impl::DataFlowIntegrationInputSig {
  private import codeql.rust.dataflow.internal.DataFlowImpl as DataFlowImpl
  private import codeql.util.Boolean

  class Expr extends CfgNodes::AstCfgNode {
    predicate hasCfgNode(BasicBlock bb, int i) { this = bb.getNode(i) }
  }

  Expr getARead(Definition def) { result = Cached::getARead(def) }

  predicate ssaDefHasSource(WriteDefinition def) { none() } // handled in `DataFlowImpl.qll` instead

  private predicate isArg(CfgNodes::CallExprBaseCfgNode call, CfgNodes::ExprCfgNode e) {
    call.getArgument(_) = e
    or
    call.(CfgNodes::MethodCallExprCfgNode).getReceiver() = e
    or
    exists(CfgNodes::ExprCfgNode mid |
      isArg(call, mid) and
      e = DataFlowImpl::getPostUpdateReverseStep(mid, _)
    )
  }

  predicate allowFlowIntoUncertainDef(UncertainWriteDefinition def) {
    exists(CfgNodes::CallExprBaseCfgNode call, Variable v, BasicBlock bb, int i |
      def.definesAt(v, bb, i) and
      mutablyBorrows(bb.getNode(i).getAstNode(), v) and
      isArg(call, bb.getNode(i))
    )
  }

  class GuardValue = Boolean;

  class Guard extends CfgNodes::AstCfgNode {
    /**
     * Holds if the evaluation of this guard to `branch` corresponds to the edge
     * from `bb1` to `bb2`.
     */
    predicate hasValueBranchEdge(BasicBlock bb1, BasicBlock bb2, GuardValue branch) {
      exists(Cfg::ConditionalSuccessor s |
        this = bb1.getANode() and
        bb2 = bb1.getASuccessor(s) and
        s.getValue() = branch
      )
    }

    /**
     * Holds if this guard evaluating to `branch` controls the control-flow
     * branch edge from `bb1` to `bb2`. That is, following the edge from
     * `bb1` to `bb2` implies that this guard evaluated to `branch`.
     */
    predicate valueControlsBranchEdge(BasicBlock bb1, BasicBlock bb2, GuardValue branch) {
      this.hasValueBranchEdge(bb1, bb2, branch)
    }
  }

  /** Holds if the guard `guard` controls block `bb` upon evaluating to `branch`. */
  predicate guardDirectlyControlsBlock(Guard guard, BasicBlock bb, GuardValue branch) {
    exists(ConditionBasicBlock conditionBlock, ConditionalSuccessor s |
      guard = conditionBlock.getLastNode() and
      s.getValue() = branch and
      conditionBlock.edgeDominates(bb, s)
    )
  }
}

private module DataFlowIntegrationImpl = Impl::DataFlowIntegration<DataFlowIntegrationInput>;

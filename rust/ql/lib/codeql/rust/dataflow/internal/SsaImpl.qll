private import rust
private import codeql.rust.controlflow.BasicBlocks as BasicBlocks
private import BasicBlocks
private import codeql.rust.controlflow.ControlFlowGraph as Cfg
private import codeql.rust.controlflow.CfgNodes as CfgNodes
private import Cfg
private import codeql.rust.controlflow.internal.ControlFlowGraphImpl as ControlFlowGraphImpl
private import codeql.ssa.Ssa as SsaImplCommon

/** Holds if `v` is introduced like `let v : i64;`. */
private predicate isUnitializedLet(IdentPat pat, Variable v) {
  pat = v.getPat() and
  exists(LetStmt let |
    let = v.getLetStmt() and
    not let.hasInitializer()
  )
}

/** Holds if `write` writes to variable `v`. */
predicate variableWrite(AstNode write, Variable v) {
  exists(IdentPat pat |
    pat = write and
    pat = v.getPat() and
    not isUnitializedLet(pat, v)
  )
  or
  exists(SelfParam self | self = write and self = v.getSelfParam())
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

module SsaInput implements SsaImplCommon::InputSig<Location> {
  class BasicBlock = BasicBlocks::BasicBlock;

  class ControlFlowNode = CfgNode;

  BasicBlock getImmediateBasicBlockDominator(BasicBlock bb) { result = bb.getImmediateDominator() }

  BasicBlock getABasicBlockSuccessor(BasicBlock bb) { result = bb.getASuccessor() }

  class ExitBasicBlock = BasicBlocks::ExitBasicBlock;

  /**
   * A variable amenable to SSA construction.
   *
   * All immutable variables are amenable. Mutable variables are restricted to
   * those that are not borrowed (either explicitly using `& mut`, or
   * (potentially) implicit as borrowed receivers in a method call).
   */
  class SourceVariable extends Variable {
    SourceVariable() {
      this.isMutable()
      implies
      not exists(VariableAccess va | va = this.getAnAccess() |
        va = any(RefExpr re | re.isMut()).getExpr()
        or
        // receivers can be borrowed implicitly, cf.
        // https://doc.rust-lang.org/reference/expressions/method-call-expr.html
        va = any(MethodCallExpr mce).getReceiver()
      )
    }
  }

  predicate variableWrite(BasicBlock bb, int i, SourceVariable v, boolean certain) {
    (
      variableWriteActual(bb, i, v, _)
      or
      capturedEntryWrite(bb, i, v)
    ) and
    certain = true
    or
    capturedCallWrite(_, bb, i, v) and certain = false
  }

  predicate variableRead(BasicBlock bb, int i, SourceVariable v, boolean certain) {
    exists(VariableAccess va |
      bb.getNode(i).getAstNode() = va and
      va = v.getAnAccess()
    |
      va instanceof VariableReadAccess
      or
      // For immutable variables, we model a read when they are borrowed
      // (although the actual read happens later, if at all).
      va = any(RefExpr re).getExpr()
      or
      // Although compound assignments, like `x += y`, may in fact not read `x`,
      // it makes sense to treat them as such
      va = any(CompoundAssignmentExpr cae).getLhs()
    ) and
    certain = true
    or
    capturedCallRead(_, bb, i, v) and certain = false
    or
    capturedExitRead(bb, i, v) and certain = false
  }
}

import SsaImplCommon::Make<Location, SsaInput> as Impl

class Definition = Impl::Definition;

class WriteDefinition = Impl::WriteDefinition;

class UncertainWriteDefinition = Impl::UncertainWriteDefinition;

class PhiDefinition = Impl::PhiNode;

module Consistency = Impl::Consistency;

module ExposedForTestingOnly {
  predicate ssaDefReachesReadExt = Impl::ssaDefReachesReadExt/4;

  predicate phiHasInputFromBlockExt = Impl::phiHasInputFromBlockExt/3;
}

pragma[noinline]
private predicate adjacentDefRead(
  Definition def, BasicBlock bb1, int i1, BasicBlock bb2, int i2, SsaInput::SourceVariable v
) {
  Impl::adjacentDefRead(def, bb1, i1, bb2, i2) and
  v = def.getSourceVariable()
}

pragma[noinline]
private predicate adjacentDefReadExt(
  DefinitionExt def, BasicBlock bb1, int i1, BasicBlock bb2, int i2, SsaInput::SourceVariable v
) {
  Impl::adjacentDefReadExt(def, _, bb1, i1, bb2, i2) and
  v = def.getSourceVariable()
}

/** Holds if `v` is read at index `i` in basic block `bb`. */
private predicate variableReadActual(BasicBlock bb, int i, Variable v) {
  exists(VariableAccess read |
    read instanceof VariableReadAccess or read = any(RefExpr re).getExpr()
  |
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
  any(VariableWriteAccess write | write.getVariable() = v and scope = write.getEnclosingCfgScope+())
      .isCapture()
}

/**
 * Holds if `v` is read inside basic block `bb` at index `i`, which is in the
 * immediate outer CFG scope of `scope`.
 */
pragma[noinline]
private predicate variableReadActualInOuterScope(
  BasicBlock bb, int i, Variable v, Cfg::CfgScope scope
) {
  variableReadActual(bb, i, v) and bb.getScope() = scope.getEnclosingCfgScope()
}

pragma[noinline]
private predicate hasVariableReadWithCapturedWrite(
  BasicBlock bb, int i, Variable v, Cfg::CfgScope scope
) {
  hasCapturedWrite(v, scope) and
  variableReadActualInOuterScope(bb, i, v, scope)
}

private predicate adjacentDefReachesRead(
  Definition def, BasicBlock bb1, int i1, BasicBlock bb2, int i2
) {
  exists(SsaInput::SourceVariable v | adjacentDefRead(def, bb1, i1, bb2, i2, v) |
    def.definesAt(v, bb1, i1)
    or
    SsaInput::variableRead(bb1, i1, v, true)
  )
  or
  exists(BasicBlock bb3, int i3 |
    adjacentDefReachesRead(def, bb1, i1, bb3, i3) and
    SsaInput::variableRead(bb3, i3, _, false) and
    Impl::adjacentDefRead(def, bb3, i3, bb2, i2)
  )
}

private predicate adjacentDefReachesReadExt(
  DefinitionExt def, BasicBlock bb1, int i1, BasicBlock bb2, int i2
) {
  exists(SsaInput::SourceVariable v | adjacentDefReadExt(def, bb1, i1, bb2, i2, v) |
    def.definesAt(v, bb1, i1, _)
    or
    SsaInput::variableRead(bb1, i1, v, true)
  )
  or
  exists(BasicBlock bb3, int i3 |
    adjacentDefReachesReadExt(def, bb1, i1, bb3, i3) and
    SsaInput::variableRead(bb3, i3, _, false) and
    Impl::adjacentDefReadExt(def, _, bb3, i3, bb2, i2)
  )
}

/** Same as `adjacentDefRead`, but skips uncertain reads. */
pragma[nomagic]
private predicate adjacentDefSkipUncertainReads(
  Definition def, BasicBlock bb1, int i1, BasicBlock bb2, int i2
) {
  adjacentDefReachesRead(def, bb1, i1, bb2, i2) and
  SsaInput::variableRead(bb2, i2, _, true)
}

private predicate adjacentDefReachesUncertainReadExt(
  DefinitionExt def, BasicBlock bb1, int i1, BasicBlock bb2, int i2
) {
  adjacentDefReachesReadExt(def, bb1, i1, bb2, i2) and
  SsaInput::variableRead(bb2, i2, _, false)
}

/** Same as `lastRefRedef`, but skips uncertain reads. */
pragma[nomagic]
private predicate lastRefSkipUncertainReadsExt(DefinitionExt def, BasicBlock bb, int i) {
  Impl::lastRef(def, bb, i) and
  not SsaInput::variableRead(bb, i, def.getSourceVariable(), false)
  or
  exists(BasicBlock bb0, int i0 |
    Impl::lastRef(def, bb0, i0) and
    adjacentDefReachesUncertainReadExt(def, bb, i, bb0, i0)
  )
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

/** Holds if `bb` contains a captured read to variable `v`. */
pragma[nomagic]
private predicate readsCapturedVariable(BasicBlock bb, Variable v) {
  getACapturedVariableAccess(bb, v) instanceof VariableReadAccess
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
    hasCapturedRead(v, scope) and
    (
      variableWriteInOuterScope(bb, any(int j | j < i), v, scope) or
      variableWriteInOuterScope(bb.getAPredecessor+(), _, v, scope)
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
    readsCapturedVariable(bb.getASuccessor*(), v) and
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
      variableReadActual(bb, i, v) and
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
    exists(BasicBlock bb1, int i1, BasicBlock bb2, int i2 |
      def.definesAt(_, bb1, i1) and
      adjacentDefSkipUncertainReads(def, bb1, i1, bb2, i2) and
      read = bb2.getNode(i2)
    )
  }

  /**
   * Holds if the read at `read2` is a read of the same SSA definition `def`
   * as the read at `read1`, and `read2` can be reached from `read1` without
   * passing through another non-pseudo read.
   */
  cached
  predicate adjacentReadPair(Definition def, CfgNode read1, CfgNode read2) {
    exists(BasicBlock bb1, int i1, BasicBlock bb2, int i2 |
      read1 = bb1.getNode(i1) and
      variableReadActual(bb1, i1, _) and
      adjacentDefSkipUncertainReads(def, bb1, i1, bb2, i2) and
      read2 = bb2.getNode(i2)
    )
  }

  /**
   * Holds if the read of `def` at `read` may be a last read. That is, `read`
   * can either reach another definition of the underlying source variable or
   * the end of the CFG scope, without passing through another non-pseudo read.
   */
  cached
  predicate lastRead(Definition def, CfgNode read) {
    exists(BasicBlock bb, int i |
      lastRefSkipUncertainReadsExt(def, bb, i) and
      variableReadActual(bb, i, _) and
      read = bb.getNode(i)
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
    predicate localFlowStep(DefinitionExt def, Node nodeFrom, Node nodeTo, boolean isUseStep) {
      DataFlowIntegrationImpl::localFlowStep(def, nodeFrom, nodeTo, isUseStep)
    }

    cached
    predicate localMustFlowStep(DefinitionExt def, Node nodeFrom, Node nodeTo) {
      DataFlowIntegrationImpl::localMustFlowStep(def, nodeFrom, nodeTo)
    }

    signature predicate guardChecksSig(CfgNodes::AstCfgNode g, Cfg::CfgNode e, boolean branch);

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
private import codeql.rust.dataflow.Ssa

/**
 * An extended static single assignment (SSA) definition.
 *
 * This is either a normal SSA definition (`Definition`) or a
 * phi-read node (`PhiReadNode`).
 *
 * Only intended for internal use.
 */
class DefinitionExt extends Impl::DefinitionExt {
  CfgNode getARead() { result = getARead(this) }

  override string toString() { result = this.(Ssa::Definition).toString() }

  override Location getLocation() { result = this.(Ssa::Definition).getLocation() }
}

/**
 * A phi-read node.
 *
 * Only intended for internal use.
 */
class PhiReadNode extends DefinitionExt, Impl::PhiReadNode {
  override string toString() { result = "SSA phi read(" + this.getSourceVariable() + ")" }

  override Location getLocation() { result = Impl::PhiReadNode.super.getLocation() }
}

private module DataFlowIntegrationInput implements Impl::DataFlowIntegrationInputSig {
  class Expr extends CfgNodes::AstCfgNode {
    predicate hasCfgNode(SsaInput::BasicBlock bb, int i) { this = bb.getNode(i) }
  }

  Expr getARead(Definition def) { result = Cached::getARead(def) }

  /** Holds if SSA definition `def` assigns `value` to the underlying variable. */
  predicate ssaDefAssigns(WriteDefinition def, Expr value) {
    none() // handled in `DataFlowImpl.qll` instead
  }

  class Parameter = CfgNodes::ParamBaseCfgNode;

  /** Holds if SSA definition `def` initializes parameter `p` at function entry. */
  predicate ssaDefInitializesParam(WriteDefinition def, Parameter p) {
    none() // handled in `DataFlowImpl.qll` instead
  }

  class Guard extends CfgNodes::AstCfgNode {
    predicate hasCfgNode(SsaInput::BasicBlock bb, int i) { this = bb.getNode(i) }
  }

  /** Holds if the guard `guard` controls block `bb` upon evaluating to `branch`. */
  predicate guardControlsBlock(Guard guard, SsaInput::BasicBlock bb, boolean branch) {
    exists(ConditionBasicBlock conditionBlock, ConditionalSuccessor s |
      guard = conditionBlock.getLastNode() and
      s.getValue() = branch and
      conditionBlock.controls(bb, s)
    )
  }

  /** Gets an immediate conditional successor of basic block `bb`, if any. */
  SsaInput::BasicBlock getAConditionalBasicBlockSuccessor(SsaInput::BasicBlock bb, boolean branch) {
    exists(Cfg::ConditionalSuccessor s |
      result = bb.getASuccessor(s) and
      s.getValue() = branch
    )
  }
}

private module DataFlowIntegrationImpl = Impl::DataFlowIntegration<DataFlowIntegrationInput>;

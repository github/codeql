private import rust
private import codeql.rust.controlflow.BasicBlocks as BasicBlocks
private import BasicBlocks
private import codeql.rust.controlflow.ControlFlowGraph as Cfg
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
  exists(VariableAccess access |
    access = write and
    access.getVariable() = v
  |
    access instanceof VariableWriteAccess
    or
    access = any(CompoundAssignmentExpr cae).getLhs()
  )
}

private Expr withParens(Expr e) {
  result = e
  or
  result.(ParenExpr).getExpr() = withParens(e)
}

private predicate isRefTarget(VariableAccess va, Variable v) {
  va = v.getAnAccess() and
  exists(RefExpr re, Expr arg |
    va = re.getExpr() and // todo: restrict to `mut`
    arg = withParens(re)
  |
    arg = any(CallExpr ce).getArgList().getAnArg()
    or
    exists(MethodCallExpr mce |
      arg = mce.getArgList().getAnArg() or
      arg = mce.getReceiver()
    )
  )
}

module SsaInput implements SsaImplCommon::InputSig<Location> {
  class BasicBlock = BasicBlocks::BasicBlock;

  class ControlFlowNode = CfgNode;

  BasicBlock getImmediateBasicBlockDominator(BasicBlock bb) { result = bb.getImmediateDominator() }

  BasicBlock getABasicBlockSuccessor(BasicBlock bb) { result = bb.getASuccessor() }

  class ExitBasicBlock = BasicBlocks::ExitBasicBlock;

  class SourceVariable extends Variable {
    SourceVariable() {
      not this.isCaptured() and
      forall(VariableAccess va | va = this.getAnAccess() |
        va instanceof VariableReadAccess
        or
        variableWrite(va, this)
        or
        isRefTarget(va, this)
      )
    }
  }

  /**
   * Holds if the statement at index `i` of basic block `bb` contains a write to variable `v`.
   * `certain` is true if the write definitely occurs.
   */
  predicate variableWrite(BasicBlock bb, int i, SourceVariable v, boolean certain) {
    variableWriteActual(bb, i, v, _) and
    certain = true
    or
    exists(VariableAccess va |
      isRefTarget(va, v) and
      va = bb.getNode(i).getAstNode() and
      certain = false
    )
  }

  predicate variableRead(BasicBlock bb, int i, SourceVariable v, boolean certain) {
    exists(VariableAccess va |
      bb.getNode(i).getAstNode() = va and
      va = v.getAnAccess()
    |
      va instanceof VariableReadAccess
      or
      // although compound assignments, like `x += y`, may in fact not update `x`,
      // it makes sense to treat them as such
      va = any(CompoundAssignmentExpr cae).getLhs()
    ) and
    certain = true
    or
    exists(VariableAccess va |
      isRefTarget(va, v) and
      va = bb.getNode(i).getAstNode() and
      certain = false
    )
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
  exists(VariableReadAccess read |
    read.getVariable() = v and
    read = bb.getNode(i).getAstNode()
  )
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

cached
private module Cached {
  /**
   * Holds if `v` is written at index `i` in basic block `bb`, and the corresponding
   * AST write access is `write`.
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

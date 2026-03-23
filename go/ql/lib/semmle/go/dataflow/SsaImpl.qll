/**
 * INTERNAL: Analyses should use module `SSA` instead.
 *
 * Provides predicates for constructing an SSA representation for functions.
 */
overlay[local]
module;

import go
private import codeql.ssa.Ssa as SsaImplCommon
private import semmle.go.controlflow.BasicBlocks as BasicBlocks

private class BasicBlock = BasicBlocks::BasicBlock;

cached
private module Internal {
  /** Holds if the `i`th node of `bb` defines `v`. */
  cached
  predicate defAt(BasicBlock bb, int i, SsaSourceVariable v) {
    bb.getNode(i).(IR::Instruction).writes(v, _)
  }

  /** Holds if the `i`th node of `bb` reads `v`. */
  cached
  predicate useAt(BasicBlock bb, int i, SsaSourceVariable v) {
    bb.getNode(i).(IR::Instruction).reads(v)
  }

  /**
   * Holds if `v` is a captured variable which is declared in `declFun` and read in `useFun`.
   */
  private predicate readsCapturedVar(FuncDef useFun, SsaSourceVariable v, FuncDef declFun) {
    declFun = v.getDeclaringFunction() and
    useFun = any(IR::Instruction u | u.reads(v)).getRoot() and
    v.isCaptured()
  }

  /** Holds if the `i`th node of `bb` in function `f` is an entry node. */
  private predicate entryNode(FuncDef f, BasicBlock bb, int i) {
    f = bb.getScope() and
    bb.getNode(i).isEntryNode()
  }

  /**
   * Holds if the `i`th node of `bb` in function `f` is a function call.
   */
  private predicate callNode(FuncDef f, BasicBlock bb, int i) {
    f = bb.getScope() and
    bb.getNode(i).(IR::EvalInstruction).getExpr() instanceof CallExpr
  }

  /**
   * Holds if the `i`th node of basic block `bb` may induce a pseudo-definition for
   * modeling updates to captured variable `v`.
   */
  cached
  predicate mayCapture(BasicBlock bb, int i, SsaSourceVariable v) {
    exists(FuncDef capturingContainer, FuncDef declContainer |
      // capture initial value of variable declared in enclosing scope
      readsCapturedVar(capturingContainer, v, declContainer) and
      capturingContainer != declContainer and
      entryNode(capturingContainer, bb, i)
      or
      // re-capture value of variable after a call if it is assigned non-locally
      readsCapturedVar(capturingContainer, v, declContainer) and
      assignedThroughClosure(v) and
      callNode(capturingContainer, bb, i)
    )
  }

  /**
   * Holds if `v` is assigned outside its declaring function.
   */
  cached
  predicate assignedThroughClosure(SsaSourceVariable v) {
    any(IR::Instruction def | def.writes(v, _)).getRoot() != v.getDeclaringFunction()
  }

  /** SSA input. */
  cached
  module SsaInput implements SsaImplCommon::InputSig<Location, BasicBlock> {
    class SourceVariable = SsaSourceVariable;

    /**
     * Holds if the `i`th node of basic block `bb` is a (potential) write to source
     * variable `v`. The Boolean `certain` indicates whether the write is certain.
     *
     * Certain writes are explicit definitions; uncertain writes are captures.
     */
    cached
    predicate variableWrite(BasicBlock bb, int i, SourceVariable v, boolean certain) {
      defAt(bb, i, v) and certain = true
      or
      mayCapture(bb, i, v) and certain = false
    }

    /**
     * Holds if the `i`th node of basic block `bb` reads source variable `v`.
     *
     * We also add a synthetic uncertain read at the exit node of the declaring
     * function for captured variables. This ensures that definitions of captured
     * variables are included in the SSA graph even when the variable is not
     * locally read in the declaring function (but may be read by a nested function).
     */
    cached
    predicate variableRead(BasicBlock bb, int i, SourceVariable v, boolean certain) {
      useAt(bb, i, v) and certain = true
      or
      v.isCaptured() and
      bb.getScope() = v.getDeclaringFunction() and
      bb.getLastNode().isExitNode() and
      i = bb.length() - 1 and
      certain = false
    }
  }
}

import Internal
import SsaImplCommon::Make<Location, BasicBlocks::Cfg, SsaInput> as Impl

final class Definition = Impl::Definition;

final class WriteDefinition = Impl::WriteDefinition;

final class UncertainWriteDefinition = Impl::UncertainWriteDefinition;

final class PhiNode = Impl::PhiNode;

module Consistency = Impl::Consistency;

/**
 * NB: This predicate should be cached.
 *
 * Holds if the SSA definition of `v` at `def` reaches a read at index `i` in
 * basic block `bb`.
 */
cached
predicate ssaDefReachesRead(SsaSourceVariable v, Definition def, BasicBlock bb, int i) {
  Impl::ssaDefReachesRead(v, def, bb, i)
}

/**
 * NB: This predicate should be cached.
 *
 * Holds if the SSA definition of `v` at `def` reaches the end of basic block `bb`.
 */
cached
predicate ssaDefReachesEndOfBlock(BasicBlock bb, Definition def, SsaSourceVariable v) {
  Impl::ssaDefReachesEndOfBlock(bb, def, v)
}

/**
 * NB: This predicate should be cached.
 *
 * Holds if `inp` is an input to the phi node `phi` along the edge originating in `bb`.
 */
cached
predicate phiHasInputFromBlock(PhiNode phi, Definition inp, BasicBlock bb) {
  Impl::phiHasInputFromBlock(phi, inp, bb)
}

/**
 * NB: This predicate should be cached.
 *
 * Holds if `def` reaches the first use `use` without going through any other use,
 * but possibly through phi nodes.
 */
cached
predicate firstUse(Definition def, IR::Instruction use) {
  exists(BasicBlock bb, int i |
    Impl::firstUse(def, bb, i, _) and
    use = bb.getNode(i)
  )
}

/**
 * NB: This predicate should be cached.
 *
 * Holds if `use1` and `use2` form an adjacent use-use-pair of the same SSA
 * variable, that is, the value read in `use1` can reach `use2` without passing
 * through any other use or any SSA definition of the variable except for phi nodes
 * and uncertain implicit updates.
 */
cached
predicate adjacentUseUse(IR::Instruction use1, IR::Instruction use2) {
  exists(BasicBlock bb1, int i1, BasicBlock bb2, int i2 |
    Impl::adjacentUseUse(bb1, i1, bb2, i2, _, _) and
    use1 = bb1.getNode(i1) and
    use2 = bb2.getNode(i2)
  )
}

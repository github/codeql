private import codeql.ssa.Ssa as SsaImplCommon
private import codeql.ruby.AST
private import codeql.ruby.CFG as Cfg
private import codeql.ruby.ast.Variable
private import Cfg::CfgNodes::ExprNodes

private module SsaInput implements SsaImplCommon::InputSig {
  private import codeql.ruby.controlflow.BasicBlocks as BasicBlocks

  class BasicBlock = BasicBlocks::BasicBlock;

  BasicBlock getImmediateBasicBlockDominator(BasicBlock bb) { result = bb.getImmediateDominator() }

  BasicBlock getABasicBlockSuccessor(BasicBlock bb) { result = bb.getASuccessor() }

  class ExitBasicBlock = BasicBlocks::ExitBasicBlock;

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
        bb.getNode(i).getNode() = scope.(ModuleBase).getAControlFlowEntryNode()
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
  }
}

import SsaImplCommon::Make<SsaInput>

/** Holds if `v` is uninitialized at index `i` in entry block `bb`. */
predicate uninitializedWrite(Cfg::EntryBasicBlock bb, int i, LocalVariable v) {
  v.getDeclaringScope() = bb.getScope() and
  i = -1
}

/** Holds if `bb` contains a captured read of variable `v`. */
pragma[noinline]
private predicate hasCapturedVariableRead(Cfg::BasicBlock bb, LocalVariable v) {
  exists(LocalVariableReadAccess read |
    read = bb.getANode().getNode() and
    read.isCapturedAccess() and
    read.getVariable() = v
  )
}

/** Holds if `bb` contains a captured write to variable `v`. */
pragma[noinline]
private predicate writesCapturedVariable(Cfg::BasicBlock bb, LocalVariable v) {
  exists(LocalVariableWriteAccess write |
    write = bb.getANode().getNode() and
    write.isCapturedAccess() and
    write.getVariable() = v
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
 * Holds if captured variable `v` is read directly inside `scope`,
 * or inside a (transitively) nested scope of `scope`.
 */
pragma[noinline]
private predicate hasCapturedRead(Variable v, Cfg::CfgScope scope) {
  any(LocalVariableReadAccess read |
    read.getVariable() = v and scope = read.getCfgScope().getOuterCfgScope*()
  ).isCapturedAccess()
}

/**
 * Holds if `v` is written inside basic block `bb`, which is in the immediate
 * outer scope of `scope`.
 */
pragma[noinline]
private predicate variableWriteInOuterScope(Cfg::BasicBlock bb, LocalVariable v, Cfg::CfgScope scope) {
  SsaInput::variableWrite(bb, _, v, _) and
  scope.getOuterCfgScope() = bb.getScope()
}

pragma[noinline]
private predicate hasVariableWriteWithCapturedRead(
  Cfg::BasicBlock bb, LocalVariable v, Cfg::CfgScope scope
) {
  hasCapturedRead(v, scope) and
  variableWriteInOuterScope(bb, v, scope)
}

/**
 * Holds if the call `call` at index `i` in basic block `bb` may reach
 * a callable that reads captured variable `v`.
 */
private predicate capturedCallRead(CallCfgNode call, Cfg::BasicBlock bb, int i, LocalVariable v) {
  exists(Cfg::CfgScope scope |
    hasVariableWriteWithCapturedRead(bb.getAPredecessor*(), v, scope) and
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
    read = bb.getNode(i).getNode()
  )
}

/**
 * Holds if captured variable `v` is written directly inside `scope`,
 * or inside a (transitively) nested scope of `scope`.
 */
pragma[noinline]
private predicate hasCapturedWrite(Variable v, Cfg::CfgScope scope) {
  any(LocalVariableWriteAccess write |
    write.getVariable() = v and scope = write.getCfgScope().getOuterCfgScope*()
  ).isCapturedAccess()
}

/**
 * Holds if `v` is read inside basic block `bb`, which is in the immediate
 * outer scope of `scope`.
 */
pragma[noinline]
private predicate variableReadActualInOuterScope(
  Cfg::BasicBlock bb, LocalVariable v, Cfg::CfgScope scope
) {
  variableReadActual(bb, _, v) and
  bb.getScope() = scope.getOuterCfgScope()
}

pragma[noinline]
private predicate hasVariableReadWithCapturedWrite(
  Cfg::BasicBlock bb, LocalVariable v, Cfg::CfgScope scope
) {
  hasCapturedWrite(v, scope) and
  variableReadActualInOuterScope(bb, v, scope)
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
      hasVariableReadWithCapturedWrite(bb.getASuccessor*(), v, scope) and
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
    Cfg::BasicBlock bb, int i, LocalVariable v, VariableWriteAccess write
  ) {
    exists(AstNode n |
      write.getVariable() = v and
      n = bb.getNode(i).getNode()
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
      ssaDefReachesRead(v, def, bb, i) and
      variableReadActual(bb, i, v) and
      result = bb.getNode(i)
    )
  }

  pragma[noinline]
  private predicate defReachesCallReadInOuterScope(
    Definition def, CallCfgNode call, LocalVariable v, Cfg::CfgScope scope
  ) {
    exists(Cfg::BasicBlock bb, int i |
      ssaDefReachesRead(v, def, bb, i) and
      capturedCallRead(call, bb, i, v) and
      scope.getOuterCfgScope() = bb.getScope()
    )
  }

  pragma[noinline]
  private predicate hasCapturedEntryWrite(Definition entry, LocalVariable v, Cfg::CfgScope scope) {
    exists(Cfg::BasicBlock bb, int i |
      capturedEntryWrite(bb, i, v) and
      entry.definesAt(v, bb, i) and
      bb.getScope().getOuterCfgScope*() = scope
    )
  }

  /**
   * Holds if there is flow for a captured variable from the enclosing scope into a block.
   * ```rb
   * foo = 0
   * bar {
   *   puts foo
   * }
   * ```
   */
  cached
  predicate captureFlowIn(CallCfgNode call, Definition def, Definition entry) {
    exists(LocalVariable v, Cfg::CfgScope scope |
      defReachesCallReadInOuterScope(def, call, v, scope) and
      hasCapturedEntryWrite(entry, v, scope)
    |
      // If the read happens inside a block, we restrict to the call that
      // contains the block
      not scope instanceof Block
      or
      scope = call.getExpr().(MethodCall).getBlock()
    )
  }

  private import codeql.ruby.dataflow.SSA

  pragma[noinline]
  private predicate defReachesExitReadInInnerScope(
    Definition def, LocalVariable v, Cfg::CfgScope scope
  ) {
    exists(Cfg::BasicBlock bb, int i |
      ssaDefReachesRead(v, def, bb, i) and
      capturedExitRead(bb, i, v) and
      scope = bb.getScope().getOuterCfgScope*()
    )
  }

  pragma[noinline]
  private predicate hasCapturedExitRead(
    Definition exit, CallCfgNode call, LocalVariable v, Cfg::CfgScope scope
  ) {
    exists(Cfg::BasicBlock bb, int i |
      capturedCallWrite(call, bb, i, v) and
      exit.definesAt(v, bb, i) and
      bb.getScope() = scope.getOuterCfgScope()
    )
  }

  /**
   * Holds if there is outgoing flow for a captured variable that is updated in a block.
   * ```rb
   * foo = 0
   * bar {
   *   foo += 10
   * }
   * puts foo
   * ```
   */
  cached
  predicate captureFlowOut(CallCfgNode call, Definition def, Definition exit) {
    exists(LocalVariable v, Cfg::CfgScope scope |
      defReachesExitReadInInnerScope(def, v, scope) and
      hasCapturedExitRead(exit, call, v, _)
    |
      // If the read happens inside a block, we restrict to the call that
      // contains the block
      not scope instanceof Block
      or
      scope = call.getExpr().(MethodCall).getBlock()
    )
  }

  cached
  Definition phiHasInputFromBlock(PhiNode phi, Cfg::BasicBlock bb) {
    phiHasInputFromBlock(phi, result, bb)
  }

  /**
   * Holds if the value defined at SSA definition `def` can reach a read at `read`,
   * without passing through any other non-pseudo read.
   */
  cached
  predicate firstRead(Definition def, VariableReadAccessCfgNode read) {
    exists(Cfg::BasicBlock bb1, int i1, Cfg::BasicBlock bb2, int i2 |
      def.definesAt(_, bb1, i1) and
      adjacentDefNoUncertainReads(def, bb1, i1, bb2, i2) and
      read = bb2.getNode(i2)
    )
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
    exists(Cfg::BasicBlock bb1, int i1, Cfg::BasicBlock bb2, int i2 |
      read1 = bb1.getNode(i1) and
      variableReadActual(bb1, i1, _) and
      adjacentDefNoUncertainReads(def, bb1, i1, bb2, i2) and
      read2 = bb2.getNode(i2)
    )
  }

  /**
   * Holds if the read of `def` at `read` may be a last read. That is, `read`
   * can either reach another definition of the underlying source variable or
   * the end of the CFG scope, without passing through another non-pseudo read.
   */
  cached
  predicate lastRead(Definition def, VariableReadAccessCfgNode read) {
    exists(Cfg::BasicBlock bb, int i |
      lastRefNoUncertainReads(def, bb, i) and
      variableReadActual(bb, i, _) and
      read = bb.getNode(i)
    )
  }

  /**
   * Holds if the reference to `def` at index `i` in basic block `bb` can reach
   * another definition `next` of the same underlying source variable, without
   * passing through another write or non-pseudo read.
   *
   * The reference is either a read of `def` or `def` itself.
   */
  cached
  predicate lastRefBeforeRedef(Definition def, Cfg::BasicBlock bb, int i, Definition next) {
    lastRefRedefNoUncertainReads(def, bb, i, next)
  }

  cached
  Definition uncertainWriteDefinitionInput(UncertainWriteDefinition def) {
    uncertainWriteDefinitionInput(def, result)
  }
}

import Cached

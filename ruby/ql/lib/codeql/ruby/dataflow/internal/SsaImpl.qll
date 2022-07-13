private import SsaImplCommon
private import SsaImplSpecific as SsaImplSpecific
private import codeql.ruby.AST
private import codeql.ruby.CFG
private import codeql.ruby.ast.Variable
private import CfgNodes::ExprNodes

/** Holds if `v` is uninitialized at index `i` in entry block `bb`. */
predicate uninitializedWrite(EntryBasicBlock bb, int i, LocalVariable v) {
  v.getDeclaringScope() = bb.getScope() and
  i = -1
}

/** Holds if `bb` contains a caputured read of variable `v`. */
pragma[noinline]
private predicate hasCapturedVariableRead(BasicBlock bb, LocalVariable v) {
  exists(LocalVariableReadAccess read |
    read = bb.getANode().getNode() and
    read.isCapturedAccess() and
    read.getVariable() = v
  )
}

/** Holds if `bb` contains a caputured write to variable `v`. */
pragma[noinline]
private predicate writesCapturedVariable(BasicBlock bb, LocalVariable v) {
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
private predicate capturedExitRead(AnnotatedExitBasicBlock bb, int i, LocalVariable v) {
  bb.isNormal() and
  writesCapturedVariable(bb.getAPredecessor*(), v) and
  i = bb.length()
}

/**
 * Holds if captured variable `v` is read directly inside `scope`,
 * or inside a (transitively) nested scope of `scope`.
 */
pragma[noinline]
private predicate hasCapturedRead(Variable v, CfgScope scope) {
  any(LocalVariableReadAccess read |
    read.getVariable() = v and scope = read.getCfgScope().getOuterCfgScope*()
  ).isCapturedAccess()
}

/**
 * Holds if `v` is written inside basic block `bb`, which is in the immediate
 * outer scope of `scope`.
 */
pragma[noinline]
private predicate variableWriteInOuterScope(BasicBlock bb, LocalVariable v, CfgScope scope) {
  SsaImplSpecific::variableWrite(bb, _, v, _) and
  scope.getOuterCfgScope() = bb.getScope()
}

pragma[noinline]
private predicate hasVariableWriteWithCapturedRead(BasicBlock bb, LocalVariable v, CfgScope scope) {
  hasCapturedRead(v, scope) and
  variableWriteInOuterScope(bb, v, scope)
}

/**
 * Holds if the call `call` at index `i` in basic block `bb` may reach
 * a callable that reads captured variable `v`.
 */
private predicate capturedCallRead(
  CfgNodes::ExprNodes::CallCfgNode call, BasicBlock bb, int i, LocalVariable v
) {
  exists(CfgScope scope |
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
private predicate variableReadActual(BasicBlock bb, int i, LocalVariable v) {
  exists(VariableReadAccess read |
    read.getVariable() = v and
    read = bb.getNode(i).getNode()
  )
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

/**
 * Holds if captured variable `v` is written directly inside `scope`,
 * or inside a (transitively) nested scope of `scope`.
 */
pragma[noinline]
private predicate hasCapturedWrite(Variable v, CfgScope scope) {
  any(LocalVariableWriteAccess write |
    write.getVariable() = v and scope = write.getCfgScope().getOuterCfgScope*()
  ).isCapturedAccess()
}

/**
 * Holds if `v` is read inside basic block `bb`, which is in the immediate
 * outer scope of `scope`.
 */
pragma[noinline]
private predicate variableReadActualInOuterScope(BasicBlock bb, LocalVariable v, CfgScope scope) {
  variableReadActual(bb, _, v) and
  bb.getScope() = scope.getOuterCfgScope()
}

pragma[noinline]
private predicate hasVariableReadWithCapturedWrite(BasicBlock bb, LocalVariable v, CfgScope scope) {
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
  predicate capturedEntryWrite(EntryBasicBlock bb, int i, LocalVariable v) {
    hasCapturedVariableRead(bb.getASuccessor*(), v) and
    i = -1
  }

  /**
   * Holds if the call `call` at index `i` in basic block `bb` may reach a callable
   * that writes captured variable `v`.
   */
  cached
  predicate capturedCallWrite(
    CfgNodes::ExprNodes::CallCfgNode call, BasicBlock bb, int i, LocalVariable v
  ) {
    exists(CfgScope scope |
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
  predicate variableWriteActual(BasicBlock bb, int i, LocalVariable v, VariableWriteAccess write) {
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
    exists(LocalVariable v, BasicBlock bb, int i |
      ssaDefReachesRead(v, def, bb, i) and
      variableReadActual(bb, i, v) and
      result = bb.getNode(i)
    )
  }

  pragma[noinline]
  private predicate defReachesCallReadInOuterScope(
    Definition def, CfgNodes::ExprNodes::CallCfgNode call, LocalVariable v, CfgScope scope
  ) {
    exists(BasicBlock bb, int i |
      ssaDefReachesRead(v, def, bb, i) and
      capturedCallRead(call, bb, i, v) and
      scope.getOuterCfgScope() = bb.getScope()
    )
  }

  pragma[noinline]
  private predicate hasCapturedEntryWrite(Definition entry, LocalVariable v, CfgScope scope) {
    exists(BasicBlock bb, int i |
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
  predicate captureFlowIn(CfgNodes::ExprNodes::CallCfgNode call, Definition def, Definition entry) {
    exists(LocalVariable v, CfgScope scope |
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
  private predicate defReachesExitReadInInnerScope(Definition def, LocalVariable v, CfgScope scope) {
    exists(BasicBlock bb, int i |
      ssaDefReachesRead(v, def, bb, i) and
      capturedExitRead(bb, i, v) and
      scope = bb.getScope().getOuterCfgScope*()
    )
  }

  pragma[noinline]
  private predicate hasCapturedExitRead(
    Definition exit, CfgNodes::ExprNodes::CallCfgNode call, LocalVariable v, CfgScope scope
  ) {
    exists(BasicBlock bb, int i |
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
  predicate captureFlowOut(CfgNodes::ExprNodes::CallCfgNode call, Definition def, Definition exit) {
    exists(LocalVariable v, CfgScope scope |
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
  Definition phiHasInputFromBlock(PhiNode phi, BasicBlock bb) {
    phiHasInputFromBlock(phi, result, bb)
  }

  /**
   * Holds if the value defined at SSA definition `def` can reach a read at `read`,
   * without passing through any other non-pseudo read.
   */
  cached
  predicate firstRead(Definition def, VariableReadAccessCfgNode read) {
    exists(BasicBlock bb1, int i1, BasicBlock bb2, int i2 |
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
    exists(BasicBlock bb1, int i1, BasicBlock bb2, int i2 |
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
    exists(BasicBlock bb, int i |
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
  predicate lastRefBeforeRedef(Definition def, BasicBlock bb, int i, Definition next) {
    lastRefRedefNoUncertainReads(def, bb, i, next)
  }

  cached
  Definition uncertainWriteDefinitionInput(UncertainWriteDefinition def) {
    uncertainWriteDefinitionInput(def, result)
  }
}

import Cached

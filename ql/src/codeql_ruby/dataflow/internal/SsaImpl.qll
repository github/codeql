private import SsaImplCommon
private import codeql_ruby.AST
private import codeql_ruby.CFG
private import codeql_ruby.ast.Variable
private import CfgNodes::ExprNodes

/** Holds if `v` is uninitialized at index `i` in entry block `bb`. */
predicate uninitializedWrite(EntryBasicBlock bb, int i, LocalVariable v) {
  v.getDeclaringScope().getScopeElement() = bb.getScope() and
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

/**
 * Holds if an entry definition is needed for captured variable `v` at index
 * `i` in entry block `bb`.
 */
predicate capturedEntryWrite(EntryBasicBlock bb, int i, LocalVariable v) {
  hasCapturedVariableRead(bb.getASuccessor*(), v) and
  i = -1
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

private CfgScope getCaptureOuterCfgScope(Callable scope) {
  result = scope.getOuterCfgScope() and
  (
    scope instanceof Block
    or
    scope instanceof Lambda
  )
}

/** Holds if captured variable `v` is read inside `scope`. */
pragma[noinline]
private predicate hasCapturedRead(Variable v, CfgScope scope) {
  any(LocalVariableReadAccess read |
    read.getVariable() = v and scope = getCaptureOuterCfgScope*(read.getCfgScope())
  ).isCapturedAccess()
}

pragma[noinline]
private predicate hasVariableWriteWithCapturedRead(BasicBlock bb, LocalVariable v, CfgScope scope) {
  hasCapturedRead(v, scope) and
  exists(VariableWriteAccess write |
    write = bb.getANode().getNode() and
    write.getVariable() = v and
    bb.getScope() = scope.getOuterCfgScope()
  )
}

/**
 * Holds if the call at index `i` in basic block `bb` may reach a callable
 * that reads captured variable `v`.
 */
private predicate capturedCallRead(BasicBlock bb, int i, LocalVariable v) {
  exists(CfgScope scope |
    hasVariableWriteWithCapturedRead(bb.getAPredecessor*(), v, scope) and
    bb.getNode(i).getNode() instanceof Call
  |
    not scope instanceof Block
    or
    // If the read happens inside a block, we restrict to the call that
    // contains the block
    scope = any(Call c | bb.getNode(i) = c.getAControlFlowNode()).getBlock()
  )
}

/** Holds if captured variable `v` is written inside `scope`. */
pragma[noinline]
private predicate hasCapturedWrite(Variable v, CfgScope scope) {
  any(LocalVariableWriteAccess write |
    write.getVariable() = v and scope = getCaptureOuterCfgScope*(write.getCfgScope())
  ).isCapturedAccess()
}

/** Holds if `v` is read at index `i` in basic block `bb`. */
predicate variableReadActual(BasicBlock bb, int i, LocalVariable v) {
  exists(VariableReadAccess read |
    read.getVariable() = v and
    read = bb.getNode(i).getNode()
  )
}

/**
 * Holds if a pseudo read of `v` is inserted at index `i` in basic block `bb`.
 *
 * Pseudo reads are used to make otherwise dead assignments live, as they will
 * otherwise not get an SSA definition.
 */
predicate variableReadPseudo(BasicBlock bb, int i, LocalVariable v) {
  capturedCallRead(bb, i, v)
  or
  capturedExitRead(bb, i, v)
}

pragma[noinline]
private predicate hasVariableReadWithCapturedWrite(BasicBlock bb, LocalVariable v, CfgScope scope) {
  hasCapturedWrite(v, scope) and
  exists(VariableReadAccess read |
    read = bb.getANode().getNode() and
    read.getVariable() = v and
    bb.getScope() = scope.getOuterCfgScope()
  )
}

private predicate adjacentDefReaches(Definition def, BasicBlock bb1, int i1, BasicBlock bb2, int i2) {
  adjacentDefRead(def, bb1, i1, bb2, i2)
  or
  exists(BasicBlock bb3, int i3 |
    adjacentDefReaches(def, bb1, i1, bb3, i3) and
    variableReadPseudo(bb3, i3, _) and
    adjacentDefRead(def, bb3, i3, bb2, i2)
  )
}

pragma[noinline]
private predicate adjacentDefActualRead(
  Definition def, BasicBlock bb1, int i1, BasicBlock bb2, int i2
) {
  adjacentDefReaches(def, bb1, i1, bb2, i2) and
  variableReadActual(bb2, i2, _)
}

private predicate adjacentDefPseudoRead(
  Definition def, BasicBlock bb1, int i1, BasicBlock bb2, int i2
) {
  adjacentDefReaches(def, bb1, i1, bb2, i2) and
  variableReadPseudo(bb2, i2, _)
}

private predicate reachesLastRefRedef(Definition def, BasicBlock bb, int i, Definition next) {
  lastRefRedef(def, bb, i, next)
  or
  exists(BasicBlock bb0, int i0 |
    reachesLastRefRedef(def, bb0, i0, next) and
    adjacentDefPseudoRead(def, bb, i, bb0, i0)
  )
}

private predicate reachesLastRef(Definition def, BasicBlock bb, int i) {
  lastRef(def, bb, i)
  or
  exists(BasicBlock bb0, int i0 |
    reachesLastRef(def, bb0, i0) and
    adjacentDefPseudoRead(def, bb, i, bb0, i0)
  )
}

cached
private module Cached {
  /**
   * Holds if the call at index `i` in basic block `bb` may reach a callable
   * that writes captured variable `v`.
   */
  cached
  predicate capturedCallWrite(BasicBlock bb, int i, LocalVariable v) {
    exists(CfgScope scope |
      hasVariableReadWithCapturedWrite(bb.getASuccessor*(), v, scope) and
      bb.getNode(i).getNode() instanceof Call
    |
      not scope instanceof Block
      or
      // If the write happens inside a block, we restrict to the call that
      // contains the block
      scope = any(Call c | bb.getNode(i) = c.getAControlFlowNode()).getBlock()
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

  /**
   * Holds if the value defined at SSA definition `def` can reach a read at `read`,
   * without passing through any other non-pseudo read.
   */
  cached
  predicate firstRead(Definition def, VariableReadAccessCfgNode read) {
    exists(BasicBlock bb1, int i1, BasicBlock bb2, int i2 |
      def.definesAt(_, bb1, i1) and
      adjacentDefActualRead(def, bb1, i1, bb2, i2) and
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
      adjacentDefActualRead(def, bb1, i1, bb2, i2) and
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
      reachesLastRef(def, bb, i) and
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
    reachesLastRefRedef(def, bb, i, next) and
    not variableReadPseudo(bb, i, def.getSourceVariable())
  }
}

import Cached

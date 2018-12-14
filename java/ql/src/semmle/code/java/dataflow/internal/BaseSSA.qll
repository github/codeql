/**
 * Provides classes and predicates for SSA representation (Static Single Assignment form)
 * restricted to local variables.
 *
 * An SSA variable consists of the pair of a `BaseSsaSourceVariable` and a
 * `ControlFlowNode` at which it is defined. Each SSA variable is defined
 * either by a phi node, an implicit initial value (for parameters),
 * or an explicit update.
 *
 * This is a restricted version of SSA.qll that only handles `LocalScopeVariable`s
 * in order to not depend on virtual dispatch.
 */

import java

private newtype TBaseSsaSourceVariable =
  TLocalVar(Callable c, LocalScopeVariable v) {
    c = v.getCallable() or c = v.getAnAccess().getEnclosingCallable()
  }

/**
 * A local variable in the context of a `Callable` in which it is accessed.
 */
class BaseSsaSourceVariable extends TBaseSsaSourceVariable {
  /** Gets the variable corresponding to this `BaseSsaSourceVariable`. */
  LocalScopeVariable getVariable() { this = TLocalVar(_, result) }

  /**
   * Gets an access of this `BaseSsaSourceVariable`. This access is within `this.getEnclosingCallable()`.
   */
  cached
  VarAccess getAnAccess() {
    exists(LocalScopeVariable v, Callable c |
      this = TLocalVar(c, v) and result = v.getAnAccess() and result.getEnclosingCallable() = c
    )
  }

  /** Gets the `Callable` in which this `BaseSsaSourceVariable` is defined. */
  Callable getEnclosingCallable() { this = TLocalVar(result, _) }

  string toString() {
    exists(LocalScopeVariable v, Callable c | this = TLocalVar(c, v) |
      if c = v.getCallable()
      then result = v.getName()
      else result = c.getName() + "(..)." + v.getName()
    )
  }

  Location getLocation() {
    exists(LocalScopeVariable v | this = TLocalVar(_, v) and result = v.getLocation())
  }

  /** Gets the type of this variable. */
  Type getType() { result = this.getVariable().getType() }
}

cached
private module SsaImpl {
  /** Gets the destination variable of an update of a tracked variable. */
  cached
  BaseSsaSourceVariable getDestVar(VariableUpdate upd) {
    result.getAnAccess() = upd.(Assignment).getDest()
    or
    exists(LocalVariableDecl v | v = upd.(LocalVariableDeclExpr).getVariable() |
      result = TLocalVar(v.getCallable(), v)
    )
    or
    result.getAnAccess() = upd.(UnaryAssignExpr).getExpr()
  }

  /** Holds if `n` updates the local variable `v`. */
  cached
  predicate variableUpdate(BaseSsaSourceVariable v, ControlFlowNode n, BasicBlock b, int i) {
    exists(VariableUpdate a | a = n | getDestVar(a) = v) and
    b.getNode(i) = n and
    hasDominanceInformation(b)
  }

  /** Gets the definition point of a nested class in the parent scope. */
  private ControlFlowNode parentDef(NestedClass nc) {
    nc.(AnonymousClass).getClassInstanceExpr() = result or
    nc.(LocalClass).getLocalClassDeclStmt() = result
  }

  /**
   * Gets the enclosing type of a nested class.
   *
   * Differs from `RefType.getEnclosingType()` by including anonymous classes defined by lambdas.
   */
  private RefType desugaredGetEnclosingType(NestedClass inner) {
    exists(ControlFlowNode node |
      node = parentDef(inner) and
      node.getEnclosingCallable().getDeclaringType() = result
    )
  }

  /**
   * Gets the control flow node at which the variable is read to get the value for
   * a `VarAccess` inside a closure. `capturedvar` is the variable in its defining
   * scope, and `closurevar` is the variable in the closure.
   */
  private ControlFlowNode captureNode(
    BaseSsaSourceVariable capturedvar, BaseSsaSourceVariable closurevar
  ) {
    exists(
      LocalScopeVariable v, Callable inner, Callable outer, NestedClass innerclass, VarAccess va
    |
      va.getVariable() = v and
      inner = va.getEnclosingCallable() and
      outer = v.getCallable() and
      inner != outer and
      inner.getDeclaringType() = innerclass and
      result = parentDef(desugaredGetEnclosingType*(innerclass)) and
      result.getEnclosingStmt().getEnclosingCallable() = outer and
      capturedvar = TLocalVar(outer, v) and
      closurevar = TLocalVar(inner, v)
    )
  }

  /** Holds if `VarAccess` `use` of `v` occurs in `b` at index `i`. */
  private predicate variableUse(BaseSsaSourceVariable v, RValue use, BasicBlock b, int i) {
    v.getAnAccess() = use and b.getNode(i) = use
  }

  /** Holds if the value of `v` is captured in `b` at index `i`. */
  private predicate variableCapture(
    BaseSsaSourceVariable capturedvar, BaseSsaSourceVariable closurevar, BasicBlock b, int i
  ) {
    b.getNode(i) = captureNode(capturedvar, closurevar)
  }

  /** Holds if the value of `v` is read in `b` at index `i`. */
  private predicate variableUseOrCapture(BaseSsaSourceVariable v, BasicBlock b, int i) {
    variableUse(v, _, b, i) or variableCapture(v, _, b, i)
  }

  /*
   * Liveness analysis to restrict the size of the SSA representation.
   */

  private predicate liveAtEntry(BaseSsaSourceVariable v, BasicBlock b) {
    exists(int i | variableUseOrCapture(v, b, i) |
      not exists(int j | variableUpdate(v, _, b, j) | j < i)
    )
    or
    liveAtExit(v, b) and not variableUpdate(v, _, b, _)
  }

  private predicate liveAtExit(BaseSsaSourceVariable v, BasicBlock b) {
    liveAtEntry(v, b.getABBSuccessor())
  }

  /** Holds if a phi node for `v` is needed at the beginning of basic block `b`. */
  cached
  predicate phiNode(BaseSsaSourceVariable v, BasicBlock b) {
    liveAtEntry(v, b) and
    exists(BasicBlock def | dominanceFrontier(def, b) |
      variableUpdate(v, _, def, _) or phiNode(v, def)
    )
  }

  /** Holds if `v` has an implicit definition at the entry, `b`, of the callable. */
  cached
  predicate hasEntryDef(BaseSsaSourceVariable v, BasicBlock b) {
    exists(LocalScopeVariable l, Callable c | v = TLocalVar(c, l) and c.getBody() = b |
      l instanceof Parameter or
      l.getCallable() != c
    )
  }

  /**
   * The construction of SSA form ensures that each use of a variable is
   * dominated by its definition. A definition of an SSA variable therefore
   * reaches a `ControlFlowNode` if it is the _closest_ SSA variable definition
   * that dominates the node. If two definitions dominate a node then one must
   * dominate the other, so therefore the definition of _closest_ is given by the
   * dominator tree. Thus, reaching definitions can be calculated in terms of
   * dominance.
   */
  cached
  module SsaDefReaches {
    /**
     * Holds if `rankix` is the rank the index `i` at which there is an SSA definition or use of
     * `v` in the basic block `b`.
     *
     * Basic block indices are translated to rank indices in order to skip
     * irrelevant indices at which there is no definition or use when traversing
     * basic blocks.
     */
    private predicate defUseRank(BaseSsaSourceVariable v, BasicBlock b, int rankix, int i) {
      i = rank[rankix](int j |
          any(TrackedSsaDef def).definesAt(v, b, j) or variableUseOrCapture(v, b, j)
        )
    }

    /** Gets the maximum rank index for the given variable and basic block. */
    private int lastRank(BaseSsaSourceVariable v, BasicBlock b) {
      result = max(int rankix | defUseRank(v, b, rankix, _))
    }

    /** Holds if a definition of an SSA variable occurs at the specified rank index in basic block `b`. */
    private predicate ssaDefRank(
      BaseSsaSourceVariable v, TrackedSsaDef def, BasicBlock b, int rankix
    ) {
      exists(int i |
        def.definesAt(v, b, i) and
        defUseRank(v, b, rankix, i)
      )
    }

    /** Holds if the SSA definition reaches the rank index `rankix` in its own basic block `b`. */
    private predicate ssaDefReachesRank(
      BaseSsaSourceVariable v, TrackedSsaDef def, BasicBlock b, int rankix
    ) {
      ssaDefRank(v, def, b, rankix)
      or
      ssaDefReachesRank(v, def, b, rankix - 1) and
      rankix <= lastRank(v, b) and
      not ssaDefRank(v, _, b, rankix)
    }

    /**
     * Holds if the SSA definition of `v` at `def` reaches the end of a basic block `b`, at
     * which point it is still live, without crossing another SSA definition of `v`.
     */
    cached
    predicate ssaDefReachesEndOfBlock(BaseSsaSourceVariable v, TrackedSsaDef def, BasicBlock b) {
      liveAtExit(v, b) and
      (
        ssaDefReachesRank(v, def, b, lastRank(v, b))
        or
        exists(BasicBlock idom |
          bbIDominates(idom, b) and // It is sufficient to traverse the dominator graph, cf. discussion above.
          ssaDefReachesEndOfBlock(v, def, idom) and
          not any(TrackedSsaDef other).definesAt(v, b, _)
        )
      )
    }

    /**
     * Holds if the SSA definition of `v` at `def` reaches `use` in the same basic block
     * without crossing another SSA definition of `v`.
     */
    private predicate ssaDefReachesUseWithinBlock(
      BaseSsaSourceVariable v, TrackedSsaDef def, RValue use
    ) {
      exists(BasicBlock b, int rankix, int i |
        ssaDefReachesRank(v, def, b, rankix) and
        defUseRank(v, b, rankix, i) and
        variableUse(v, use, b, i)
      )
    }

    /**
     * Holds if the SSA definition of `v` at `def` reaches `use` without crossing another
     * SSA definition of `v`.
     */
    cached
    predicate ssaDefReachesUse(BaseSsaSourceVariable v, TrackedSsaDef def, RValue use) {
      ssaDefReachesUseWithinBlock(v, def, use)
      or
      exists(BasicBlock b |
        variableUse(v, use, b, _) and
        ssaDefReachesEndOfBlock(v, def, b.getABBPredecessor()) and
        not ssaDefReachesUseWithinBlock(v, _, use)
      )
    }

    /**
     * Holds if the SSA definition of `v` at `def` reaches the capture point of
     * `closurevar` in the same basic block without crossing another SSA
     * definition of `v`.
     */
    private predicate ssaDefReachesCaptureWithinBlock(
      BaseSsaSourceVariable v, TrackedSsaDef def, BaseSsaSourceVariable closurevar
    ) {
      exists(BasicBlock b, int rankix, int i |
        ssaDefReachesRank(v, def, b, rankix) and
        defUseRank(v, b, rankix, i) and
        variableCapture(v, closurevar, b, i)
      )
    }

    /**
     * Holds if the SSA definition of `v` at `def` reaches capture point of
     * `closurevar` without crossing another SSA definition of `v`.
     */
    cached
    predicate ssaDefReachesCapture(
      BaseSsaSourceVariable v, TrackedSsaDef def, BaseSsaSourceVariable closurevar
    ) {
      ssaDefReachesCaptureWithinBlock(v, def, closurevar)
      or
      exists(BasicBlock b |
        variableCapture(v, closurevar, b, _) and
        ssaDefReachesEndOfBlock(v, def, b.getABBPredecessor()) and
        not ssaDefReachesCaptureWithinBlock(v, _, closurevar)
      )
    }
  }
}
private import SsaImpl
private import SsaDefReaches

private newtype TBaseSsaVariable =
  TSsaPhiNode(BaseSsaSourceVariable v, BasicBlock b) { phiNode(v, b) } or
  TSsaUpdate(BaseSsaSourceVariable v, ControlFlowNode n, BasicBlock b, int i) {
    variableUpdate(v, n, b, i)
  } or
  TSsaEntryDef(BaseSsaSourceVariable v, BasicBlock b) { hasEntryDef(v, b) }

/**
 * An SSA definition excluding those variables that use a trivial SSA construction.
 */
private class TrackedSsaDef extends BaseSsaVariable {
  /**
   * Holds if this SSA definition occurs at the specified position.
   * Phi nodes are placed at index -1.
   */
  predicate definesAt(BaseSsaSourceVariable v, BasicBlock b, int i) {
    this = TSsaPhiNode(v, b) and i = -1
    or
    this = TSsaUpdate(v, _, b, i)
    or
    this = TSsaEntryDef(v, b) and i = 0
  }
}

/**
 * An SSA variable.
 */
class BaseSsaVariable extends TBaseSsaVariable {
  /** Gets the SSA source variable underlying this SSA variable. */
  BaseSsaSourceVariable getSourceVariable() {
    this = TSsaPhiNode(result, _) or
    this = TSsaUpdate(result, _, _, _) or
    this = TSsaEntryDef(result, _)
  }

  /** Gets the `ControlFlowNode` at which this SSA variable is defined. */
  ControlFlowNode getCFGNode() {
    this = TSsaPhiNode(_, result) or
    this = TSsaUpdate(_, result, _, _) or
    this = TSsaEntryDef(_, result)
  }

  string toString() { none() }

  Location getLocation() { result = getCFGNode().getLocation() }

  /** Gets the `BasicBlock` in which this SSA variable is defined. */
  BasicBlock getBasicBlock() { result = getCFGNode().getBasicBlock() }

  /** Gets an access of this SSA variable. */
  RValue getAUse() { ssaDefReachesUse(_, this, result) }

  /** Holds if this SSA variable is live at the end of `b`. */
  predicate isLiveAtEndOfBlock(BasicBlock b) { ssaDefReachesEndOfBlock(_, this, b) }

  /** Gets an input to the phi node defining the SSA variable. */
  private BaseSsaVariable getAPhiInput() { result = this.(BaseSsaPhiNode).getAPhiInput() }

  /** Gets a definition in the same callable that ultimately defines this variable and is not itself a phi node. */
  BaseSsaVariable getAnUltimateLocalDefinition() {
    result = this.getAPhiInput*() and not result instanceof BaseSsaPhiNode
  }

  /**
   * Gets an SSA variable whose value can flow to this one in one step. This
   * includes inputs to phi nodes and the captured ssa variable for a closure
   * variable.
   */
  private BaseSsaVariable getAPhiInputOrCapturedVar() {
    result = this.(BaseSsaPhiNode).getAPhiInput() or
    this.(BaseSsaImplicitInit).captures(result)
  }

  /** Gets a definition that ultimately defines this variable and is not itself a phi node. */
  BaseSsaVariable getAnUltimateDefinition() {
    result = this.getAPhiInputOrCapturedVar*() and not result instanceof BaseSsaPhiNode
  }
}

/** An SSA variable that is defined by a `VariableUpdate`. */
class BaseSsaUpdate extends BaseSsaVariable, TSsaUpdate {
  BaseSsaUpdate() {
    exists(VariableUpdate upd | upd = this.getCFGNode() and getDestVar(upd) = getSourceVariable())
  }

  override string toString() { result = "SSA def(" + getSourceVariable() + ")" }

  /** Gets the `VariableUpdate` defining the SSA variable. */
  VariableUpdate getDefiningExpr() {
    result = this.getCFGNode() and getDestVar(result) = getSourceVariable()
  }
}

/**
 * An SSA variable that is defined by its initial value in the callable. This
 * includes initial values of parameters, fields, and closure variables.
 */
class BaseSsaImplicitInit extends BaseSsaVariable, TSsaEntryDef {
  override string toString() { result = "SSA init(" + getSourceVariable() + ")" }

  /** Holds if this is a closure variable that captures the value of `capturedvar`. */
  predicate captures(BaseSsaVariable capturedvar) {
    ssaDefReachesCapture(_, capturedvar, getSourceVariable())
  }

  /**
   * Holds if the SSA variable is a parameter defined by its initial value in the callable.
   */
  predicate isParameterDefinition(Parameter p) {
    getSourceVariable() = TLocalVar(p.getCallable(), p) and p.getCallable().getBody() = getCFGNode()
  }
}

/** An SSA phi node. */
class BaseSsaPhiNode extends BaseSsaVariable, TSsaPhiNode {
  override string toString() { result = "SSA phi(" + getSourceVariable() + ")" }

  /** Gets an input to the phi node defining the SSA variable. */
  BaseSsaVariable getAPhiInput() {
    exists(BasicBlock phiPred, BaseSsaSourceVariable v |
      v = getSourceVariable() and
      getCFGNode().(BasicBlock).getABBPredecessor() = phiPred and
      ssaDefReachesEndOfBlock(v, result, phiPred)
    )
  }
}

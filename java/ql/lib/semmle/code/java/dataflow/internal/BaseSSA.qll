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
overlay[local?]
module;

import java
private import codeql.ssa.Ssa as SsaImplCommon

cached
private module BaseSsaStage {
  cached
  predicate ref() { any() }

  cached
  predicate backref() {
    (exists(TLocalVar(_, _)) implies any()) and
    (exists(any(BaseSsaSourceVariable v).getAnAccess()) implies any()) and
    (exists(getAUse(_)) implies any())
  }
}

cached
private newtype TBaseSsaSourceVariable =
  TLocalVar(Callable c, LocalScopeVariable v) {
    BaseSsaStage::ref() and
    c = v.getCallable()
    or
    c = v.getAnAccess().getEnclosingCallable()
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
    BaseSsaStage::ref() and
    exists(LocalScopeVariable v, Callable c |
      this = TLocalVar(c, v) and result = v.getAnAccess() and result.getEnclosingCallable() = c
    )
  }

  /** Gets the `Callable` in which this `BaseSsaSourceVariable` is defined. */
  Callable getEnclosingCallable() { this = TLocalVar(result, _) }

  /** Gets a textual representation of this element. */
  string toString() {
    exists(LocalScopeVariable v, Callable c | this = TLocalVar(c, v) |
      if c = v.getCallable()
      then result = v.getName()
      else result = c.getName() + "(..)." + v.getName()
    )
  }

  /** Gets the source location for this element. */
  Location getLocation() {
    exists(LocalScopeVariable v | this = TLocalVar(_, v) and result = v.getLocation())
  }

  /** Gets the type of this variable. */
  Type getType() { result = this.getVariable().getType() }
}

private module BaseSsaImpl {
  /** Gets the destination variable of an update of a tracked variable. */
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
  predicate variableUpdate(BaseSsaSourceVariable v, ControlFlowNode n, BasicBlock b, int i) {
    exists(VariableUpdate a | a.getControlFlowNode() = n | getDestVar(a) = v) and
    b.getNode(i) = n and
    hasDominanceInformation(b)
  }

  /** Gets the definition point of a nested class in the parent scope. */
  private ControlFlowNode parentDef(NestedClass nc) {
    nc.(AnonymousClass).getClassInstanceExpr().getControlFlowNode() = result or
    nc.(LocalClass).getLocalTypeDeclStmt().getControlFlowNode() = result
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

  /** Holds if the value of `v` is captured in `b` at index `i`. */
  predicate variableCapture(
    BaseSsaSourceVariable capturedvar, BaseSsaSourceVariable closurevar, BasicBlock b, int i
  ) {
    b.getNode(i) = captureNode(capturedvar, closurevar)
  }

  /** Holds if `v` has an implicit definition at the entry, `b`, of the callable. */
  predicate hasEntryDef(BaseSsaSourceVariable v, BasicBlock b) {
    exists(LocalScopeVariable l, Callable c |
      v = TLocalVar(c, l) and c.getBody().getBasicBlock() = b
    |
      l instanceof Parameter or
      l.getCallable() != c
    )
  }
}

private import BaseSsaImpl

private module SsaInput implements SsaImplCommon::InputSig<Location> {
  private import java as J

  class BasicBlock = J::BasicBlock;

  class ControlFlowNode = J::ControlFlowNode;

  BasicBlock getImmediateBasicBlockDominator(BasicBlock bb) { result.immediatelyDominates(bb) }

  BasicBlock getABasicBlockSuccessor(BasicBlock bb) { result = bb.getASuccessor() }

  class SourceVariable = BaseSsaSourceVariable;

  /**
   * Holds if the `i`th node of basic block `bb` is a write to source variable
   * `v`.
   */
  predicate variableWrite(BasicBlock bb, int i, SourceVariable v, boolean certain) {
    variableUpdate(v, _, bb, i) and
    certain = true
    or
    hasEntryDef(v, bb) and
    i = 0 and
    certain = true
  }

  /**
   * Holds if the `i`th of basic block `bb` reads source variable `v`.
   */
  predicate variableRead(BasicBlock bb, int i, SourceVariable v, boolean certain) {
    hasDominanceInformation(bb) and
    (
      exists(VarRead use |
        v.getAnAccess() = use and bb.getNode(i) = use.getControlFlowNode() and certain = true
      )
      or
      variableCapture(v, _, bb, i) and
      certain = false
    )
  }
}

private module Impl = SsaImplCommon::Make<Location, SsaInput>;

private import Cached

cached
private module Cached {
  cached
  VarRead getAUse(Impl::Definition def) {
    BaseSsaStage::ref() and
    exists(BaseSsaSourceVariable v, BasicBlock bb, int i |
      Impl::ssaDefReachesRead(v, def, bb, i) and
      result.getControlFlowNode() = bb.getNode(i) and
      result = v.getAnAccess()
    )
  }

  cached
  predicate ssaDefReachesEndOfBlock(BasicBlock bb, Impl::Definition def) {
    Impl::ssaDefReachesEndOfBlock(bb, def, _)
  }

  cached
  predicate firstUse(Impl::Definition def, VarRead use) {
    exists(BasicBlock bb, int i |
      Impl::firstUse(def, bb, i, _) and
      use.getControlFlowNode() = bb.getNode(i)
    )
  }

  cached
  predicate ssaUpdate(Impl::Definition def, VariableUpdate upd) {
    exists(BaseSsaSourceVariable v, BasicBlock bb, int i |
      def.definesAt(v, bb, i) and
      variableUpdate(v, upd.getControlFlowNode(), bb, i) and
      getDestVar(upd) = v
    )
  }

  cached
  predicate ssaImplicitInit(Impl::WriteDefinition def) {
    exists(BaseSsaSourceVariable v, BasicBlock bb, int i |
      def.definesAt(v, bb, i) and
      hasEntryDef(v, bb) and
      i = 0
    )
  }

  /** Holds if `init` is a closure variable that captures the value of `capturedvar`. */
  cached
  predicate captures(BaseSsaImplicitInit init, BaseSsaVariable capturedvar) {
    exists(BasicBlock bb, int i |
      Impl::ssaDefReachesRead(_, capturedvar, bb, i) and
      variableCapture(capturedvar.getSourceVariable(), init.getSourceVariable(), bb, i)
    )
  }

  cached
  predicate phiHasInputFromBlock(Impl::PhiNode phi, Impl::Definition inp, BasicBlock bb) {
    Impl::phiHasInputFromBlock(phi, inp, bb)
  }

  cached
  module SsaPublic {
    /**
     * Holds if `use1` and `use2` form an adjacent use-use-pair of the same SSA
     * variable, that is, the value read in `use1` can reach `use2` without passing
     * through any other use or any SSA definition of the variable.
     */
    cached
    predicate baseSsaAdjacentUseUseSameVar(VarRead use1, VarRead use2) {
      exists(BasicBlock bb1, int i1, BasicBlock bb2, int i2 |
        use1.getControlFlowNode() = bb1.getNode(i1) and
        use2.getControlFlowNode() = bb2.getNode(i2) and
        Impl::adjacentUseUse(bb1, i1, bb2, i2, _, true)
      )
    }

    /**
     * Holds if `use1` and `use2` form an adjacent use-use-pair of the same
     * `SsaSourceVariable`, that is, the value read in `use1` can reach `use2`
     * without passing through any other use or any SSA definition of the variable
     * except for phi nodes.
     */
    cached
    predicate baseSsaAdjacentUseUse(VarRead use1, VarRead use2) {
      exists(BasicBlock bb1, int i1, BasicBlock bb2, int i2 |
        use1.getControlFlowNode() = bb1.getNode(i1) and
        use2.getControlFlowNode() = bb2.getNode(i2) and
        Impl::adjacentUseUse(bb1, i1, bb2, i2, _, _)
      )
    }
  }
}

import SsaPublic

/**
 * An SSA variable.
 */
class BaseSsaVariable extends Impl::Definition {
  /** Gets the `ControlFlowNode` at which this SSA variable is defined. */
  ControlFlowNode getCfgNode() {
    exists(BasicBlock bb, int i | this.definesAt(_, bb, i) and result = bb.getNode(0.maximum(i)))
  }

  /** Gets an access of this SSA variable. */
  VarRead getAUse() { result = getAUse(this) }

  /**
   * Gets an access of the SSA source variable underlying this SSA variable
   * that can be reached from this SSA variable without passing through any
   * other uses, but potentially through phi nodes.
   *
   * Subsequent uses can be found by following the steps defined by
   * `baseSsaAdjacentUseUse`.
   */
  VarRead getAFirstUse() { firstUse(this, result) }

  /** Holds if this SSA variable is live at the end of `b`. */
  predicate isLiveAtEndOfBlock(BasicBlock b) { ssaDefReachesEndOfBlock(b, this) }

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
class BaseSsaUpdate extends BaseSsaVariable instanceof Impl::WriteDefinition {
  BaseSsaUpdate() { ssaUpdate(this, _) }

  /** Gets the `VariableUpdate` defining the SSA variable. */
  VariableUpdate getDefiningExpr() { ssaUpdate(this, result) }
}

/**
 * An SSA variable that is defined by its initial value in the callable. This
 * includes initial values of parameters, fields, and closure variables.
 */
class BaseSsaImplicitInit extends BaseSsaVariable instanceof Impl::WriteDefinition {
  BaseSsaImplicitInit() { ssaImplicitInit(this) }

  /** Holds if this is a closure variable that captures the value of `capturedvar`. */
  predicate captures(BaseSsaVariable capturedvar) { captures(this, capturedvar) }

  /**
   * Holds if the SSA variable is a parameter defined by its initial value in the callable.
   */
  predicate isParameterDefinition(Parameter p) {
    this.getSourceVariable() = TLocalVar(p.getCallable(), p) and
    p.getCallable().getBody().getControlFlowNode() = this.getCfgNode()
  }
}

/** An SSA phi node. */
class BaseSsaPhiNode extends BaseSsaVariable instanceof Impl::PhiNode {
  /** Gets an input to the phi node defining the SSA variable. */
  BaseSsaVariable getAPhiInput() { this.hasInputFromBlock(result, _) }

  /** Holds if `inp` is an input to the phi node along the edge originating in `bb`. */
  predicate hasInputFromBlock(BaseSsaVariable inp, BasicBlock bb) {
    phiHasInputFromBlock(this, inp, bb)
  }
}

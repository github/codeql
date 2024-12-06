overlay[local?]
module;

import java
private import codeql.ssa.Ssa as SsaImplCommon
private import semmle.code.java.dataflow.SSA
private import semmle.code.java.dispatch.VirtualDispatch
private import semmle.code.java.dispatch.WrappedInvocation
private import semmle.code.java.controlflow.Guards as Guards

predicate fieldAccessInCallable(FieldAccess fa, Field f, Callable c) {
  f = fa.getField() and
  c = fa.getEnclosingCallable()
}

cached
newtype TSsaSourceVariable =
  TLocalVar(Callable c, LocalScopeVariable v) {
    c = v.getCallable() or c = v.getAnAccess().getEnclosingCallable()
  } or
  TPlainField(Callable c, Field f) {
    exists(FieldRead fr |
      fieldAccessInCallable(fr, f, c) and
      (fr.isOwnFieldAccess() or f.isStatic())
    )
  } or
  TEnclosingField(Callable c, Field f, RefType t) {
    exists(FieldRead fr | fieldAccessInCallable(fr, f, c) and fr.isEnclosingFieldAccess(t))
  } or
  TQualifiedField(Callable c, SsaSourceVariable q, InstanceField f) {
    exists(FieldRead fr | fieldAccessInCallable(fr, f, c) and fr.getQualifier() = q.getAnAccess())
  }

private module TrackedVariablesImpl {
  /** Gets the number of accesses of `f`. */
  private int numberOfAccesses(SsaSourceField f) {
    result = strictcount(FieldAccess fa | fa = f.getAnAccess())
  }

  /** Holds if `f` is accessed inside a loop. */
  private predicate loopAccessed(SsaSourceField f) {
    exists(LoopStmt l, FieldRead fr | fr = f.getAnAccess() |
      l.getBody() = fr.getEnclosingStmt().getEnclosingStmt*() or
      l.getCondition() = fr.getParent*() or
      l.(ForStmt).getAnUpdate() = fr.getParent*()
    )
  }

  /** Holds if `f` is accessed more than once or inside a loop. */
  private predicate multiAccessed(SsaSourceField f) { loopAccessed(f) or 1 < numberOfAccesses(f) }

  /**
   * Holds if `f` is a field that is interesting as a basis for SSA.
   *
   * - A field that is read twice is interesting as we want to know whether the
   *   reads refer to the same value.
   * - A field that is both written and read is interesting as we want to know
   *   whether the read might get the written value.
   * - A field that is read in a loop is interesting as we want to know whether
   *   the value is the same in different iterations (that is, whether the SSA
   *   definition can be placed outside the loop).
   * - A volatile field is never interesting, since all reads must reread from
   *   memory and we are forced to assume that the value can change at any point.
   */
  cached
  predicate trackField(SsaSourceField f) { multiAccessed(f) and not f.isVolatile() }

  /**
   * The variables that form the basis of the non-trivial SSA construction.
   * Fields that aren't tracked get a trivial SSA construction (a definition
   * prior to every read).
   */
  class TrackedVar extends SsaSourceVariable {
    TrackedVar() {
      this = TLocalVar(_, _) or
      trackField(this)
    }
  }

  class TrackedField extends TrackedVar, SsaSourceField { }
}

private import TrackedVariablesImpl

private predicate untrackedFieldWrite(BasicBlock bb, int i, SsaSourceVariable v) {
  v =
    any(SsaSourceField nf |
      bb.getNode(i + 1) = nf.getAnAccess().(FieldRead).getControlFlowNode() and not trackField(nf)
    )
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
private ControlFlowNode captureNode(TrackedVar capturedvar, TrackedVar closurevar) {
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
private predicate variableCapture(TrackedVar capturedvar, TrackedVar closurevar, BasicBlock b, int i) {
  b.getNode(i) = captureNode(capturedvar, closurevar)
}

/** Holds if `n` must update the locally tracked variable `v`. */
pragma[nomagic]
private predicate certainVariableUpdate(TrackedVar v, ControlFlowNode n, BasicBlock b, int i) {
  exists(VariableUpdate a | a.getControlFlowNode() = n | getDestVar(a) = v) and
  b.getNode(i) = n and
  hasDominanceInformation(b)
  or
  certainVariableUpdate(v.getQualifier(), n, b, i)
}

/** Holds if `v` has an implicit definition at the entry, `b`, of the callable. */
pragma[nomagic]
private predicate hasEntryDef(TrackedVar v, BasicBlock b) {
  exists(LocalScopeVariable l, Callable c |
    v = TLocalVar(c, l) and c.getBody().getControlFlowNode() = b
  |
    l instanceof Parameter or
    l.getCallable() != c
  )
  or
  v instanceof SsaSourceField and v.getEnclosingCallable().getBody().getControlFlowNode() = b
}

/** Holds if `n` might update the locally tracked variable `v`. */
pragma[nomagic]
private predicate uncertainVariableUpdate(TrackedVar v, ControlFlowNode n, BasicBlock b, int i) {
  exists(Call c | c = n.asCall() | updatesNamedField(c, v, _)) and
  b.getNode(i) = n and
  hasDominanceInformation(b)
  or
  uncertainVariableUpdate(v.getQualifier(), n, b, i)
}

private module SsaInput implements SsaImplCommon::InputSig<Location> {
  private import java as J
  private import semmle.code.java.controlflow.Dominance as Dom

  class BasicBlock = J::BasicBlock;

  class ControlFlowNode = J::ControlFlowNode;

  BasicBlock getImmediateBasicBlockDominator(BasicBlock bb) { Dom::bbIDominates(result, bb) }

  BasicBlock getABasicBlockSuccessor(BasicBlock bb) { result = bb.getABBSuccessor() }

  class SourceVariable = SsaSourceVariable;

  /**
   * Holds if the `i`th node of basic block `bb` is a (potential) write to source
   * variable `v`. The Boolean `certain` indicates whether the write is certain.
   *
   * This includes implicit writes via calls.
   */
  predicate variableWrite(BasicBlock bb, int i, SourceVariable v, boolean certain) {
    certainVariableUpdate(v, _, bb, i) and
    certain = true
    or
    untrackedFieldWrite(bb, i, v) and
    certain = true
    or
    hasEntryDef(v, bb) and
    i = 0 and
    certain = true
    or
    uncertainVariableUpdate(v, _, bb, i) and
    certain = false
  }

  /**
   * Holds if the `i`th of basic block `bb` reads source variable `v`.
   *
   * This includes implicit reads via calls.
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

import SsaImplCommon::Make<Location, SsaInput> as Impl

final class Definition = Impl::Definition;

final class WriteDefinition = Impl::WriteDefinition;

final class UncertainWriteDefinition = Impl::UncertainWriteDefinition;

final class PhiNode = Impl::PhiNode;

class UntrackedDef extends Definition {
  private VarRead read;

  UntrackedDef() { ssaUntrackedDef(this, read) }

  string toString() { result = read.toString() }

  Location getLocation() { result = read.getLocation() }
}

cached
private module Cached {
  /** Gets the destination variable of an update of a tracked variable. */
  cached
  TrackedVar getDestVar(VariableUpdate upd) {
    result.getAnAccess() = upd.(Assignment).getDest()
    or
    exists(LocalVariableDecl v | v = upd.(LocalVariableDeclExpr).getVariable() |
      result = TLocalVar(v.getCallable(), v)
    )
    or
    result.getAnAccess() = upd.(UnaryAssignExpr).getExpr()
  }

  cached
  predicate ssaExplicitUpdate(SsaUpdate def, VariableUpdate upd) {
    exists(SsaSourceVariable v, BasicBlock bb, int i |
      def.definesAt(v, bb, i) and
      certainVariableUpdate(v, upd.getControlFlowNode(), bb, i) and
      getDestVar(upd) = def.getSourceVariable()
    )
  }

  cached
  predicate ssaUntrackedDef(Definition def, VarRead read) {
    exists(SsaSourceVariable v, BasicBlock bb, int i |
      def.definesAt(v, bb, i) and
      untrackedFieldWrite(bb, i, v) and
      read.getControlFlowNode() = bb.getNode(i + 1)
    )
  }

  /*
   * The SSA construction for a field `f` relies on implicit update nodes at
   * every call site that conceivably could reach an update of the field.
   *
   * At a first approximation we need to find update paths of the form:
   *   Callable --(callEdge)-->* Callable(setter of f)
   *
   * This can be improved by excluding paths ending in:
   *   Constructor --(intraInstanceCallEdge)-->+ Method(setter of this.f)
   * as these updates are guaranteed not to alias with the `f` under
   * consideration.
   *
   * This set of paths can be expressed positively by noting that those
   * that set `this.f` end in zero or more `intraInstanceCallEdge`s between
   * methods, and before those is either the originating `Call` or a
   * `crossInstanceCallEdge`.
   */

  /**
   * Holds if `fw` is a field write that is not relevant as an implicit SSA
   * update, since it is an initialization and therefore cannot alias.
   */
  private predicate init(FieldWrite fw) {
    fw.getEnclosingCallable() instanceof InitializerMethod
    or
    fw.getEnclosingCallable() instanceof Constructor and fw.isOwnFieldAccess()
    or
    exists(LocalVariableDecl v |
      v.getAnAccess() = fw.getQualifier() and
      forex(VariableAssign va | va.getDestVar() = v and exists(va.getSource()) |
        va.getSource() instanceof ClassInstanceExpr
      )
    )
  }

  /**
   * Holds if `fw` is an update of `f` in `c` that is relevant for SSA construction.
   */
  cached
  predicate relevantFieldUpdate(Callable c, Field f, FieldWrite fw) {
    fw = f.getAnAccess() and
    not init(fw) and
    fw.getEnclosingCallable() = c and
    exists(TrackedField nf | nf.getField() = f)
  }

  /** Holds if `c` can change the value of `this.f` and is relevant for SSA construction. */
  private predicate setsOwnField(Method c, Field f) {
    exists(FieldWrite fw | relevantFieldUpdate(c, f, fw) and fw.isOwnFieldAccess())
  }

  /**
   * Holds if `c` can change the value of `f` and is relevant for SSA
   * construction excluding those cases covered by `setsOwnField`.
   */
  private predicate setsOtherField(Callable c, Field f) {
    exists(FieldWrite fw | relevantFieldUpdate(c, f, fw) and not fw.isOwnFieldAccess())
  }

  pragma[nomagic]
  private predicate innerclassSupertypeStar(InnerClass t1, RefType t2) {
    t1.getASourceSupertype*().getSourceDeclaration() = t2
  }

  /**
   * Holds if `(c1,m2)` is a call edge to a method that does not change the value
   * of `this`.
   *
   * Constructor-to-constructor calls can also be intra-instance, but are not
   * included, as this does not affect whether a call chain ends in
   *
   * ```
   *   Constructor --(intraInstanceCallEdge)-->+ Method(setter of this.f)
   * ```
   */
  private predicate intraInstanceCallEdge(Callable c1, Method m2) {
    exists(MethodCall ma, RefType t1 |
      ma.getCaller() = c1 and
      m2 = viableImpl_v2(ma) and
      not m2.isStatic() and
      (
        not exists(ma.getQualifier()) or
        ma.getQualifier() instanceof ThisAccess or
        ma.getQualifier() instanceof SuperAccess
      ) and
      c1.getDeclaringType() = t1 and
      if t1 instanceof InnerClass
      then
        innerclassSupertypeStar(t1, ma.getCallee().getSourceDeclaration().getDeclaringType()) and
        not exists(ma.getQualifier().(ThisAccess).getQualifier()) and
        not exists(ma.getQualifier().(SuperAccess).getQualifier())
      else any()
    )
  }

  private Callable tgt(Call c) {
    result = viableImpl_v2(c)
    or
    result = getRunnerTarget(c)
    or
    c instanceof ConstructorCall and result = c.getCallee().getSourceDeclaration()
  }

  /** Holds if `(c1,c2)` is an edge in the call graph. */
  private predicate callEdge(Callable c1, Callable c2) {
    exists(Call c | c.getCaller() = c1 and c2 = tgt(c))
  }

  /** Holds if `(c1,c2)` is an edge in the call graph excluding `intraInstanceCallEdge`. */
  private predicate crossInstanceCallEdge(Callable c1, Callable c2) {
    callEdge(c1, c2) and not intraInstanceCallEdge(c1, c2)
  }

  /**
   * Holds if `call` is relevant as a potential update of `f`. This requires the
   * existence of an update to `f` somewhere.
   */
  private predicate relevantCall(Call call, TrackedField f) {
    call.getEnclosingCallable() = f.getEnclosingCallable() and
    relevantFieldUpdate(_, f.getField(), _)
  }

  private predicate source(Call call, TrackedField f, Field field, Callable c, boolean fresh) {
    relevantCall(call, f) and
    field = f.getField() and
    c = tgt(call) and
    if c instanceof Constructor then fresh = true else fresh = false
  }

  /**
   * A callable in a potential call-chain between a source that cares about the
   * value of some field `f` and a sink that may overwrite `f`. The boolean
   * `fresh` indicates whether the instance `this` in `c` has been freshly
   * allocated along the call-chain.
   */
  private newtype TCallableNode =
    MkCallableNode(Callable c, boolean fresh) { source(_, _, _, c, fresh) or edge(_, c, fresh) }

  private predicate edge(TCallableNode n, Callable c2, boolean f2) {
    exists(Callable c1, boolean f1 | n = MkCallableNode(c1, f1) |
      intraInstanceCallEdge(c1, c2) and f2 = f1
      or
      crossInstanceCallEdge(c1, c2) and
      if c2 instanceof Constructor then f2 = true else f2 = false
    )
  }

  private predicate edge(TCallableNode n1, TCallableNode n2) {
    exists(Callable c2, boolean f2 |
      edge(n1, c2, f2) and
      n2 = MkCallableNode(c2, f2)
    )
  }

  pragma[noinline]
  private predicate source(Call call, TrackedField f, Field field, TCallableNode n) {
    exists(Callable c, boolean fresh |
      source(call, f, field, c, fresh) and
      n = MkCallableNode(c, fresh)
    )
  }

  private predicate sink(Callable c, Field f, TCallableNode n) {
    setsOwnField(c, f) and n = MkCallableNode(c, false)
    or
    setsOtherField(c, f) and n = MkCallableNode(c, _)
  }

  private predicate prunedNode(TCallableNode n) {
    sink(_, _, n)
    or
    exists(TCallableNode mid | edge(n, mid) and prunedNode(mid))
  }

  private predicate prunedEdge(TCallableNode n1, TCallableNode n2) {
    prunedNode(n1) and
    prunedNode(n2) and
    edge(n1, n2)
  }

  private predicate edgePlus(TCallableNode c1, TCallableNode c2) = fastTC(prunedEdge/2)(c1, c2)

  /**
   * Holds if there exists a call-chain originating in `call` that can update `f` on some instance
   * where `f` and `call` share the same enclosing callable in which a
   * `FieldRead` of `f` is reachable from `call`.
   */
  pragma[noopt]
  private predicate updatesNamedFieldImpl(Call call, TrackedField f, Callable setter) {
    exists(TCallableNode src, TCallableNode sink, Field field |
      source(call, f, field, src) and
      sink(setter, field, sink) and
      (src = sink or edgePlus(src, sink))
    )
  }

  bindingset[call, f]
  pragma[inline_late]
  private predicate updatesNamedField0(Call call, TrackedField f, Callable setter) {
    updatesNamedField(call, f, setter)
  }

  cached
  predicate defUpdatesNamedField(SsaImplicitUpdate def, TrackedField f, Callable setter) {
    f = def.getSourceVariable() and
    updatesNamedField0(def.getCfgNode().asCall(), f, setter)
  }

  cached
  predicate ssaUncertainImplicitUpdate(SsaImplicitUpdate def) {
    exists(SsaSourceVariable v, BasicBlock bb, int i |
      def.definesAt(v, bb, i) and
      uncertainVariableUpdate(v, _, bb, i)
    )
  }

  cached
  predicate ssaImplicitInit(WriteDefinition def) {
    exists(SsaSourceVariable v, BasicBlock bb, int i |
      def.definesAt(v, bb, i) and
      hasEntryDef(v, bb) and
      i = 0
    )
  }

  /** Holds if `init` is a closure variable that captures the value of `capturedvar`. */
  cached
  predicate captures(SsaImplicitInit init, SsaVariable capturedvar) {
    exists(BasicBlock bb, int i |
      Impl::ssaDefReachesRead(_, capturedvar, bb, i) and
      variableCapture(capturedvar.getSourceVariable(), init.getSourceVariable(), bb, i)
    )
  }

  /**
   * Holds if the SSA definition of `v` at `def` reaches `redef` without crossing another
   * SSA definition of `v`.
   */
  cached
  predicate ssaDefReachesUncertainDef(TrackedSsaDef def, SsaUncertainImplicitUpdate redef) {
    Impl::uncertainWriteDefinitionInput(redef, def)
  }

  /**
   * Holds if the value defined at `def` can reach `use` without passing through
   * any other uses, but possibly through phi nodes and uncertain implicit updates.
   */
  cached
  predicate firstUse(Definition def, VarRead use) {
    exists(BasicBlock bb, int i |
      Impl::firstUse(def, bb, i, _) and
      use.getControlFlowNode() = bb.getNode(i)
    )
  }

  cached
  VarRead getAUse(Definition def) {
    exists(SsaSourceVariable v, BasicBlock bb, int i |
      Impl::ssaDefReachesRead(v, def, bb, i) and
      result.getControlFlowNode() = bb.getNode(i) and
      result = v.getAnAccess()
    )
  }

  cached
  predicate ssaDefReachesEndOfBlock(BasicBlock bb, Definition def) {
    Impl::ssaDefReachesEndOfBlock(bb, def, _)
  }

  cached
  predicate phiHasInputFromBlock(PhiNode phi, Definition inp, BasicBlock bb) {
    Impl::phiHasInputFromBlock(phi, inp, bb)
  }

  cached
  module DataFlowIntegration {
    import DataFlowIntegrationImpl

    cached
    predicate localFlowStep(TrackedVar v, Node nodeFrom, Node nodeTo, boolean isUseStep) {
      DataFlowIntegrationImpl::localFlowStep(v, nodeFrom, nodeTo, isUseStep)
    }

    cached
    predicate localMustFlowStep(TrackedVar v, Node nodeFrom, Node nodeTo) {
      DataFlowIntegrationImpl::localMustFlowStep(v, nodeFrom, nodeTo)
    }

    signature predicate guardChecksSig(Guards::Guard g, Expr e, boolean branch);

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

  cached
  module SsaPublic {
    /**
     * Holds if `use1` and `use2` form an adjacent use-use-pair of the same SSA
     * variable, that is, the value read in `use1` can reach `use2` without passing
     * through any other use or any SSA definition of the variable.
     */
    cached
    predicate adjacentUseUseSameVar(VarRead use1, VarRead use2) {
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
     * except for phi nodes and uncertain implicit updates.
     */
    cached
    predicate adjacentUseUse(VarRead use1, VarRead use2) {
      exists(BasicBlock bb1, int i1, BasicBlock bb2, int i2 |
        use1.getControlFlowNode() = bb1.getNode(i1) and
        use2.getControlFlowNode() = bb2.getNode(i2) and
        Impl::adjacentUseUse(bb1, i1, bb2, i2, _, _)
      )
    }
  }

  /**
   * Provides internal implementation predicates that are not cached and should not
   * be used outside of this file.
   */
  cached // needed to avoid compilation error; has no actual effect
  module Internal {
    predicate updatesNamedField = updatesNamedFieldImpl/3; // use alias to avoid caching
  }
}

import Cached
private import Internal

/**
 * An SSA definition excluding those variables that use a trivial SSA construction.
 */
private class TrackedSsaDef extends Definition {
  TrackedSsaDef() { not this.getSourceVariable() = any(SsaSourceField f | not trackField(f)) }

  /**
   * Holds if this SSA definition occurs at the specified position.
   * Phi nodes are placed at index -1.
   */
  predicate definesAt(TrackedVar v, BasicBlock b, int i) { super.definesAt(v, b, i) }
}

private module DataFlowIntegrationInput implements Impl::DataFlowIntegrationInputSig {
  private import java as J

  class Expr instanceof J::Expr {
    string toString() { result = super.toString() }

    Location getLocation() { result = super.getLocation() }

    predicate hasCfgNode(BasicBlock bb, int i) {
      super.getControlFlowNode() = bb.(J::BasicBlock).getNode(i)
    }
  }

  Expr getARead(Definition def) { result = getAUse(def) }

  predicate ssaDefHasSource(WriteDefinition def) {
    def instanceof SsaExplicitUpdate or def.(SsaImplicitInit).isParameterDefinition(_)
  }

  predicate allowFlowIntoUncertainDef(UncertainWriteDefinition def) {
    def instanceof SsaUncertainImplicitUpdate
  }

  class Guard extends Guards::Guard {
    /**
     * Holds if the control flow branching from `bb1` is dependent on this guard,
     * and that the edge from `bb1` to `bb2` corresponds to the evaluation of this
     * guard to `branch`.
     */
    predicate controlsBranchEdge(BasicBlock bb1, BasicBlock bb2, boolean branch) {
      super.hasBranchEdge(bb1, bb2, branch)
    }
  }

  /** Holds if the guard `guard` directly controls block `bb` upon evaluating to `branch`. */
  predicate guardDirectlyControlsBlock(Guard guard, BasicBlock bb, boolean branch) {
    guard.directlyControls(bb, branch)
  }

  /** Holds if the guard `guard` controls block `bb` upon evaluating to `branch`. */
  predicate guardControlsBlock(Guard guard, BasicBlock bb, boolean branch) {
    guard.controls(bb, branch)
  }

  predicate includeWriteDefsInFlowStep() { none() }
}

private module DataFlowIntegrationImpl = Impl::DataFlowIntegration<DataFlowIntegrationInput>;

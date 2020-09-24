/**
 * Provides classes and predicates for SSA representation (Static Single Assignment form).
 *
 * An SSA variable consists of the pair of a `SsaSourceVariable` and a
 * `ControlFlowNode` at which it is defined. Each SSA variable is defined
 * either by a phi node, an implicit initial value (for parameters and fields),
 * an explicit update, or an implicit update (for fields).
 * An implicit update occurs either at a `Call` that might modify a field, at
 * another update that can update the qualifier of a field, or at a `FieldRead`
 * of the field in case the field is not amenable to a non-trivial SSA
 * representation.
 */

import java
private import semmle.code.java.dispatch.VirtualDispatch
private import semmle.code.java.dispatch.WrappedInvocation

private predicate fieldAccessInCallable(FieldAccess fa, Field f, Callable c) {
  f = fa.getField() and
  c = fa.getEnclosingCallable()
}

cached
private newtype TSsaSourceVariable =
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

/**
 * A fully qualified variable in the context of a `Callable` in which it is
 * accessed.
 *
 * This is either a local variable or a fully qualified field, `q.f1.f2....fn`,
 * where the base qualifier `q` is either `this`, a local variable, or a type
 * in case `f1` is static.
 */
class SsaSourceVariable extends TSsaSourceVariable {
  /** Gets the variable corresponding to this `SsaSourceVariable`. */
  Variable getVariable() {
    this = TLocalVar(_, result) or
    this = TPlainField(_, result) or
    this = TEnclosingField(_, result, _) or
    this = TQualifiedField(_, _, result)
  }

  /**
   * Gets an access of this `SsaSourceVariable`. This access is within
   * `this.getEnclosingCallable()`. Note that `LocalScopeVariable`s that are
   * accessed from nested callables are therefore associated with several
   * `SsaSourceVariable`s.
   */
  cached
  VarAccess getAnAccess() {
    exists(LocalScopeVariable v, Callable c |
      this = TLocalVar(c, v) and result = v.getAnAccess() and result.getEnclosingCallable() = c
    )
    or
    exists(Field f, Callable c | fieldAccessInCallable(result, f, c) |
      (result.(FieldAccess).isOwnFieldAccess() or f.isStatic()) and
      this = TPlainField(c, f)
      or
      exists(RefType t |
        this = TEnclosingField(c, f, t) and result.(FieldAccess).isEnclosingFieldAccess(t)
      )
      or
      exists(SsaSourceVariable q |
        result.getQualifier() = q.getAnAccess() and this = TQualifiedField(c, q, f)
      )
    )
  }

  /** Gets the `Callable` in which this `SsaSourceVariable` is defined. */
  Callable getEnclosingCallable() {
    this = TLocalVar(result, _) or
    this = TPlainField(result, _) or
    this = TEnclosingField(result, _, _) or
    this = TQualifiedField(result, _, _)
  }

  /** Gets a textual representation of this `SsaSourceVariable`. */
  string toString() {
    exists(LocalScopeVariable v, Callable c | this = TLocalVar(c, v) |
      if c = v.getCallable()
      then result = v.getName()
      else result = c.getName() + "(..)." + v.getName()
    )
    or
    result = this.(SsaSourceField).ppQualifier() + "." + getVariable().toString()
  }

  /**
   * Gets the first access to `this` in terms of source code location. This is
   * used as the representative location for named fields that otherwise would
   * not have a specific source code location.
   */
  private VarAccess getFirstAccess() {
    result =
      min(this.getAnAccess() as a
        order by
          a.getLocation().getStartLine(), a.getLocation().getStartColumn()
      )
  }

  /** Gets the source location for this element. */
  Location getLocation() {
    exists(LocalScopeVariable v | this = TLocalVar(_, v) and result = v.getLocation())
    or
    this instanceof SsaSourceField and result = getFirstAccess().getLocation()
  }

  /** Gets the type of this variable. */
  Type getType() { result = this.getVariable().getType() }

  /** Gets the qualifier, if any. */
  SsaSourceVariable getQualifier() { this = TQualifiedField(_, result, _) }

  /** Gets an SSA variable that has this variable as its underlying source variable. */
  SsaVariable getAnSsaVariable() { result.getSourceVariable() = this }
}

/**
 * A fully qualified field in the context of a `Callable` in which it is
 * accessed.
 */
class SsaSourceField extends SsaSourceVariable {
  SsaSourceField() {
    this = TPlainField(_, _) or this = TEnclosingField(_, _, _) or this = TQualifiedField(_, _, _)
  }

  /** Gets the field corresponding to this named field. */
  Field getField() { result = getVariable() }

  /** Gets a string representation of the qualifier. */
  string ppQualifier() {
    exists(Field f | this = TPlainField(_, f) |
      if f.isStatic() then result = f.getDeclaringType().getQualifiedName() else result = "this"
    )
    or
    exists(Field f, RefType t | this = TEnclosingField(_, f, t) | result = t.toString() + ".this")
    or
    exists(SsaSourceVariable q | this = TQualifiedField(_, q, _) | result = q.toString())
  }

  /** Holds if the field itself or any of the fields part of the qualifier are volatile. */
  predicate isVolatile() {
    getField().isVolatile() or
    getQualifier().(SsaSourceField).isVolatile()
  }
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

cached
private module SsaImpl {
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

  /** Holds if `n` must update the locally tracked variable `v`. */
  cached
  predicate certainVariableUpdate(TrackedVar v, ControlFlowNode n, BasicBlock b, int i) {
    exists(VariableUpdate a | a = n | getDestVar(a) = v) and
    b.getNode(i) = n and
    hasDominanceInformation(b)
    or
    certainVariableUpdate(v.getQualifier(), n, b, i)
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

  /** Holds if `VarAccess` `use` of `v` occurs in `b` at index `i`. */
  private predicate variableUse(TrackedVar v, RValue use, BasicBlock b, int i) {
    v.getAnAccess() = use and b.getNode(i) = use
  }

  /** Holds if the value of `v` is captured in `b` at index `i`. */
  private predicate variableCapture(
    TrackedVar capturedvar, TrackedVar closurevar, BasicBlock b, int i
  ) {
    b.getNode(i) = captureNode(capturedvar, closurevar)
  }

  /** Holds if the value of `v` is read in `b` at index `i`. */
  private predicate variableUseOrCapture(TrackedVar v, BasicBlock b, int i) {
    variableUse(v, _, b, i) or variableCapture(v, _, b, i)
  }

  /*
   * Liveness analysis to restrict the size of the SSA representation.
   */

  private predicate liveAtEntry(TrackedVar v, BasicBlock b) {
    exists(int i | variableUseOrCapture(v, b, i) |
      not exists(int j | certainVariableUpdate(v, _, b, j) | j < i)
    )
    or
    liveAtExit(v, b) and not certainVariableUpdate(v, _, b, _)
  }

  private predicate liveAtExit(TrackedVar v, BasicBlock b) { liveAtEntry(v, b.getABBSuccessor()) }

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
    t1.getASupertype*().getSourceDeclaration() = t2
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
    exists(MethodAccess ma, RefType t1 |
      ma.getCaller() = c1 and
      m2 = viableImpl(ma) and
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
    result = viableImpl(c)
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

  /** Holds if a call to `x.c` can change the value of `x.f`. The actual update occurs in `setter`. */
  private predicate setsOwnFieldTransitive(Method c, Field f, Method setter) {
    setsOwnField(setter, f) and intraInstanceCallEdge*(c, setter)
  }

  /** Holds if a call to `c` can change the value of `f` on some instance. The actual update occurs in `setter`. */
  private predicate generalSetter(Callable c, Field f, Callable setter) {
    exists(Method ownsetter |
      setsOwnFieldTransitive(ownsetter, f, setter) and
      crossInstanceCallEdge(c, ownsetter)
    )
    or
    setsOtherField(c, f) and c = setter
  }

  /**
   * Holds if `call` occurs in the same basic block, `b`, as `f` at index `i` and
   * `f` has an update somewhere.
   */
  private predicate updateCandidate(TrackedField f, Call call, BasicBlock b, int i) {
    b.getNode(i) = call and
    call.getEnclosingCallable() = f.getEnclosingCallable() and
    relevantFieldUpdate(_, f.getField(), _)
  }

  /**
   * Holds if `rankix` is the rank of index `i` at which there is a use, a
   * certain update, or a potential update of `f` in the basic block `b`.
   *
   * Basic block indices are translated to rank indices in order to skip
   * irrelevant indices at which there is update or use when traversing
   * basic blocks.
   */
  private predicate callDefUseRank(TrackedField f, BasicBlock b, int rankix, int i) {
    updateCandidate(f, _, b, _) and
    i =
      rank[rankix](int j |
        certainVariableUpdate(f, _, b, j) or
        variableUseOrCapture(f, b, j) or
        updateCandidate(f, _, b, j)
      )
  }

  /**
   * Holds if `f` is live in `b` at index `i`. The rank of `i` is `rankix` as
   * defined by `callDefUseRank`.
   */
  private predicate liveAtRank(TrackedField f, BasicBlock b, int rankix, int i) {
    callDefUseRank(f, b, rankix, i) and
    (
      rankix = max(int rix | callDefUseRank(f, b, rix, _)) and liveAtExit(f, b)
      or
      variableUseOrCapture(f, b, i)
      or
      exists(int j | liveAtRank(f, b, rankix + 1, j) and not certainVariableUpdate(f, _, b, j))
    )
  }

  /**
   * Holds if `call` is relevant as a potential update of `f`. This requires the
   * existence of an update to `f` somewhere and that `f` is live at `call`.
   */
  private predicate relevantCall(Call call, TrackedField f) {
    exists(BasicBlock b, int i |
      updateCandidate(f, call, b, i) and
      liveAtRank(f, b, _, i)
    )
  }

  /**
   * Holds if `c` is a relevant part of the call graph for
   * `updatesNamedFieldPart1` based on following edges in forward direction.
   */
  private predicate pruneFromLeft(Callable c) {
    exists(Call call, SsaSourceField f |
      generalSetter(_, f.getField(), _) and
      relevantCall(call, f) and
      c = tgt(call)
    )
    or
    exists(Callable mid | pruneFromLeft(mid) and callEdge(mid, c))
  }

  /**
   * Holds if `c` is a relevant part of the call graph for
   * `updatesNamedFieldPart1` based on following edges in backward direction.
   */
  private predicate pruneFromRight(Callable c) {
    generalSetter(c, _, _)
    or
    exists(Callable mid | callEdge(c, mid) and pruneFromRight(mid))
  }

  /** A restriction of the call graph to the parts that are relevant for `updatesNamedFieldPart1`. */
  private class PrunedCallable extends Callable {
    PrunedCallable() { pruneFromLeft(this) and pruneFromRight(this) }
  }

  private predicate callEdgePruned(PrunedCallable c1, PrunedCallable c2) { callEdge(c1, c2) }

  private predicate callEdgePlus(PrunedCallable c1, PrunedCallable c2) =
    fastTC(callEdgePruned/2)(c1, c2)

  pragma[noinline]
  private predicate updatesNamedFieldPrefix(Call call, TrackedField f, Callable c1, Field field) {
    relevantCall(call, f) and
    field = f.getField() and
    c1 = tgt(call)
  }

  pragma[noinline]
  private predicate generalSetterProj(Callable c, Field f) { generalSetter(c, f, _) }

  /**
   * Holds if `call` may change the value of `f` on some instance, which may or
   * may not alias with `this`. The actual update occurs in `setter`.
   */
  pragma[noopt]
  private predicate updatesNamedFieldPart1(Call call, TrackedField f, Callable setter) {
    exists(Callable c1, Callable c2, Field field |
      updatesNamedFieldPrefix(call, f, c1, field) and
      generalSetterProj(c2, field) and
      (c1 = c2 or callEdgePlus(c1, c2)) and
      generalSetter(c2, field, setter)
    )
  }

  /** Holds if `call` may change the value of `f` on `this`. The actual update occurs in `setter`. */
  private predicate updatesNamedFieldPart2(Call call, TrackedField f, Callable setter) {
    relevantCall(call, f) and
    setsOwnFieldTransitive(tgt(call), f.getField(), setter)
  }

  /**
   * Holds if there exists a call-chain originating in `call` that can update `f` on some instance
   * where `f` and `call` share the same enclosing callable in which a
   * `FieldRead` of `f` is reachable from `call`.
   */
  cached
  predicate updatesNamedField(Call call, TrackedField f, Callable setter) {
    updatesNamedFieldPart1(call, f, setter) or updatesNamedFieldPart2(call, f, setter)
  }

  /** Holds if `n` might update the locally tracked variable `v`. */
  cached
  predicate uncertainVariableUpdate(TrackedVar v, ControlFlowNode n, BasicBlock b, int i) {
    exists(Call c | c = n | updatesNamedField(c, v, _)) and
    b.getNode(i) = n and
    hasDominanceInformation(b)
    or
    uncertainVariableUpdate(v.getQualifier(), n, b, i)
  }

  /** Holds if `n` updates the locally tracked variable `v`. */
  private predicate variableUpdate(TrackedVar v, ControlFlowNode n, BasicBlock b, int i) {
    certainVariableUpdate(v, n, b, i) or uncertainVariableUpdate(v, n, b, i)
  }

  /** Holds if a phi node for `v` is needed at the beginning of basic block `b`. */
  cached
  predicate phiNode(TrackedVar v, BasicBlock b) {
    liveAtEntry(v, b) and
    exists(BasicBlock def | dominanceFrontier(def, b) |
      variableUpdate(v, _, def, _) or phiNode(v, def)
    )
  }

  /** Holds if `v` has an implicit definition at the entry, `b`, of the callable. */
  cached
  predicate hasEntryDef(TrackedVar v, BasicBlock b) {
    exists(LocalScopeVariable l, Callable c | v = TLocalVar(c, l) and c.getBody() = b |
      l instanceof Parameter or
      l.getCallable() != c
    )
    or
    v instanceof SsaSourceField and v.getEnclosingCallable().getBody() = b and liveAtEntry(v, b)
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
    private predicate defUseRank(TrackedVar v, BasicBlock b, int rankix, int i) {
      i =
        rank[rankix](int j |
          any(TrackedSsaDef def).definesAt(v, b, j) or variableUseOrCapture(v, b, j)
        )
    }

    /** Gets the maximum rank index for the given variable and basic block. */
    private int lastRank(TrackedVar v, BasicBlock b) {
      result = max(int rankix | defUseRank(v, b, rankix, _))
    }

    /** Holds if a definition of an SSA variable occurs at the specified rank index in basic block `b`. */
    private predicate ssaDefRank(TrackedVar v, TrackedSsaDef def, BasicBlock b, int rankix) {
      exists(int i |
        def.definesAt(v, b, i) and
        defUseRank(v, b, rankix, i)
      )
    }

    /** Holds if the SSA definition reaches the rank index `rankix` in its own basic block `b`. */
    private predicate ssaDefReachesRank(TrackedVar v, TrackedSsaDef def, BasicBlock b, int rankix) {
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
    predicate ssaDefReachesEndOfBlock(TrackedVar v, TrackedSsaDef def, BasicBlock b) {
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
    private predicate ssaDefReachesUseWithinBlock(TrackedVar v, TrackedSsaDef def, RValue use) {
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
    predicate ssaDefReachesUse(TrackedVar v, TrackedSsaDef def, RValue use) {
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
      TrackedVar v, TrackedSsaDef def, TrackedVar closurevar
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
    predicate ssaDefReachesCapture(TrackedVar v, TrackedSsaDef def, TrackedVar closurevar) {
      ssaDefReachesCaptureWithinBlock(v, def, closurevar)
      or
      exists(BasicBlock b |
        variableCapture(v, closurevar, b, _) and
        ssaDefReachesEndOfBlock(v, def, b.getABBPredecessor()) and
        not ssaDefReachesCaptureWithinBlock(v, _, closurevar)
      )
    }

    /**
     * Holds if the SSA definition of `v` at `def` reaches `redef` in the same basic block
     * without crossing another SSA definition of `v`.
     */
    private predicate ssaDefReachesUncertainDefWithinBlock(
      TrackedVar v, TrackedSsaDef def, SsaUncertainImplicitUpdate redef
    ) {
      exists(BasicBlock b, int rankix, int i |
        ssaDefReachesRank(v, def, b, rankix) and
        defUseRank(v, b, rankix + 1, i) and
        redef.(TrackedSsaDef).definesAt(v, b, i)
      )
    }

    /**
     * Holds if the SSA definition of `v` at `def` reaches `redef` without crossing another
     * SSA definition of `v`.
     */
    cached
    predicate ssaDefReachesUncertainDef(
      TrackedVar v, TrackedSsaDef def, SsaUncertainImplicitUpdate redef
    ) {
      ssaDefReachesUncertainDefWithinBlock(v, def, redef)
      or
      exists(BasicBlock b |
        redef.(TrackedSsaDef).definesAt(v, b, _) and
        ssaDefReachesEndOfBlock(v, def, b.getABBPredecessor()) and
        not ssaDefReachesUncertainDefWithinBlock(v, _, redef)
      )
    }
  }

  private module AdjacentUsesImpl {
    /**
     * Holds if `rankix` is the rank the index `i` at which there is an SSA definition or explicit use of
     * `v` in the basic block `b`.
     */
    private predicate defUseRank(TrackedVar v, BasicBlock b, int rankix, int i) {
      i = rank[rankix](int j | any(TrackedSsaDef def).definesAt(v, b, j) or variableUse(v, _, b, j))
    }

    /** Gets the maximum rank index for the given variable and basic block. */
    private int lastRank(TrackedVar v, BasicBlock b) {
      result = max(int rankix | defUseRank(v, b, rankix, _))
    }

    /** Holds if `v` is defined or used in `b`. */
    private predicate varOccursInBlock(TrackedVar v, BasicBlock b) { defUseRank(v, b, _, _) }

    /** Holds if `v` occurs in `b` or one of `b`'s transitive successors. */
    private predicate blockPrecedesVar(TrackedVar v, BasicBlock b) {
      varOccursInBlock(v, b)
      or
      ssaDefReachesEndOfBlock(v, _, b)
    }

    /**
     * Holds if `b2` is a transitive successor of `b1` and `v` occurs in `b1` and
     * in `b2` or one of its transitive successors but not in any block on the path
     * between `b1` and `b2`.
     */
    private predicate varBlockReaches(TrackedVar v, BasicBlock b1, BasicBlock b2) {
      varOccursInBlock(v, b1) and
      b2 = b1.getABBSuccessor() and
      blockPrecedesVar(v, b2)
      or
      exists(BasicBlock mid |
        varBlockReaches(v, b1, mid) and
        b2 = mid.getABBSuccessor() and
        not varOccursInBlock(v, mid) and
        blockPrecedesVar(v, b2)
      )
    }

    /**
     * Holds if `b2` is a transitive successor of `b1` and `v` occurs in `b1` and
     * `b2` but not in any block on the path between `b1` and `b2`.
     */
    private predicate varBlockStep(TrackedVar v, BasicBlock b1, BasicBlock b2) {
      varBlockReaches(v, b1, b2) and
      varOccursInBlock(v, b2)
    }

    /**
     * Holds if `v` occurs at index `i1` in `b1` and at index `i2` in `b2` and
     * there is a path between them without any occurrence of `v`.
     */
    predicate adjacentVarRefs(TrackedVar v, BasicBlock b1, int i1, BasicBlock b2, int i2) {
      exists(int rankix |
        b1 = b2 and
        defUseRank(v, b1, rankix, i1) and
        defUseRank(v, b2, rankix + 1, i2)
      )
      or
      defUseRank(v, b1, lastRank(v, b1), i1) and
      varBlockStep(v, b1, b2) and
      defUseRank(v, b2, 1, i2)
    }
  }

  private import AdjacentUsesImpl

  /**
   * Holds if the value defined at `def` can reach `use` without passing through
   * any other uses, but possibly through phi nodes and uncertain implicit updates.
   */
  cached
  predicate firstUse(TrackedSsaDef def, RValue use) {
    exists(TrackedVar v, BasicBlock b1, int i1, BasicBlock b2, int i2 |
      adjacentVarRefs(v, b1, i1, b2, i2) and
      def.definesAt(v, b1, i1) and
      variableUse(v, use, b2, i2)
    )
    or
    exists(TrackedVar v, TrackedSsaDef redef, BasicBlock b1, int i1, BasicBlock b2, int i2 |
      redef instanceof SsaUncertainImplicitUpdate or redef instanceof SsaPhiNode
    |
      adjacentVarRefs(v, b1, i1, b2, i2) and
      def.definesAt(v, b1, i1) and
      redef.definesAt(v, b2, i2) and
      firstUse(redef, use)
    )
  }

  cached
  module SsaPublic {
    /**
     * Holds if `use1` and `use2` form an adjacent use-use-pair of the same SSA
     * variable, that is, the value read in `use1` can reach `use2` without passing
     * through any other use or any SSA definition of the variable.
     */
    cached
    predicate adjacentUseUseSameVar(RValue use1, RValue use2) {
      exists(TrackedVar v, BasicBlock b1, int i1, BasicBlock b2, int i2 |
        adjacentVarRefs(v, b1, i1, b2, i2) and
        variableUse(v, use1, b1, i1) and
        variableUse(v, use2, b2, i2)
      )
    }

    /**
     * Holds if `use1` and `use2` form an adjacent use-use-pair of the same
     * `SsaSourceVariable`, that is, the value read in `use1` can reach `use2`
     * without passing through any other use or any SSA definition of the variable
     * except for phi nodes and uncertain implicit updates.
     */
    cached
    predicate adjacentUseUse(RValue use1, RValue use2) {
      adjacentUseUseSameVar(use1, use2)
      or
      exists(TrackedVar v, TrackedSsaDef def, BasicBlock b1, int i1, BasicBlock b2, int i2 |
        adjacentVarRefs(v, b1, i1, b2, i2) and
        variableUse(v, use1, b1, i1) and
        def.definesAt(v, b2, i2) and
        firstUse(def, use2) and
        (def instanceof SsaUncertainImplicitUpdate or def instanceof SsaPhiNode)
      )
    }
  }
}

private import SsaImpl
private import SsaDefReaches
import SsaPublic

cached
private newtype TSsaVariable =
  TSsaPhiNode(TrackedVar v, BasicBlock b) { phiNode(v, b) } or
  TSsaCertainUpdate(TrackedVar v, ControlFlowNode n, BasicBlock b, int i) {
    certainVariableUpdate(v, n, b, i)
  } or
  TSsaUncertainUpdate(TrackedVar v, ControlFlowNode n, BasicBlock b, int i) {
    uncertainVariableUpdate(v, n, b, i)
  } or
  TSsaEntryDef(TrackedVar v, BasicBlock b) { hasEntryDef(v, b) } or
  TSsaUntracked(SsaSourceField nf, ControlFlowNode n) {
    n = nf.getAnAccess().(FieldRead) and not trackField(nf)
  }

/**
 * An SSA definition excluding those variables that use a trivial SSA construction.
 */
private class TrackedSsaDef extends SsaVariable {
  TrackedSsaDef() { not this = TSsaUntracked(_, _) }

  /**
   * Holds if this SSA definition occurs at the specified position.
   * Phi nodes are placed at index -1.
   */
  predicate definesAt(TrackedVar v, BasicBlock b, int i) {
    this = TSsaPhiNode(v, b) and i = -1
    or
    this = TSsaCertainUpdate(v, _, b, i)
    or
    this = TSsaUncertainUpdate(v, _, b, i)
    or
    this = TSsaEntryDef(v, b) and i = 0
  }
}

/**
 * An SSA variable.
 */
class SsaVariable extends TSsaVariable {
  /** Gets the SSA source variable underlying this SSA variable. */
  SsaSourceVariable getSourceVariable() {
    this = TSsaPhiNode(result, _) or
    this = TSsaCertainUpdate(result, _, _, _) or
    this = TSsaUncertainUpdate(result, _, _, _) or
    this = TSsaEntryDef(result, _) or
    this = TSsaUntracked(result, _)
  }

  /** Gets the `ControlFlowNode` at which this SSA variable is defined. */
  ControlFlowNode getCFGNode() {
    this = TSsaPhiNode(_, result) or
    this = TSsaCertainUpdate(_, result, _, _) or
    this = TSsaUncertainUpdate(_, result, _, _) or
    this = TSsaEntryDef(_, result) or
    this = TSsaUntracked(_, result)
  }

  /** Gets a textual representation of this SSA variable. */
  string toString() { none() }

  /** Gets the source location for this element. */
  Location getLocation() { result = getCFGNode().getLocation() }

  /** Gets the `BasicBlock` in which this SSA variable is defined. */
  BasicBlock getBasicBlock() { result = getCFGNode().getBasicBlock() }

  /** Gets an access of this SSA variable. */
  RValue getAUse() {
    ssaDefReachesUse(_, this, result) or
    this = TSsaUntracked(_, result)
  }

  /**
   * Gets an access of the SSA source variable underlying this SSA variable
   * that can be reached from this SSA variable without passing through any
   * other uses, but potentially through phi nodes and uncertain implicit
   * updates.
   *
   * Subsequent uses can be found by following the steps defined by
   * `adjacentUseUse`.
   */
  RValue getAFirstUse() {
    firstUse(this, result) or
    this = TSsaUntracked(_, result)
  }

  /** Holds if this SSA variable is live at the end of `b`. */
  predicate isLiveAtEndOfBlock(BasicBlock b) { ssaDefReachesEndOfBlock(_, this, b) }

  /**
   * Gets an SSA variable whose value can flow to this one in one step. This
   * includes inputs to phi nodes, the prior definition of uncertain updates,
   * and the captured ssa variable for a closure variable.
   */
  SsaVariable getAPhiInputOrPriorDef() {
    result = this.(SsaPhiNode).getAPhiInput() or
    result = this.(SsaUncertainImplicitUpdate).getPriorDef() or
    this.(SsaImplicitInit).captures(result)
  }

  /** Gets a definition that ultimately defines this variable and is not itself a phi node. */
  SsaVariable getAnUltimateDefinition() {
    result = this.getAPhiInputOrPriorDef*() and not result instanceof SsaPhiNode
  }
}

/** An SSA variable that either explicitly or implicitly updates the variable. */
class SsaUpdate extends SsaVariable {
  SsaUpdate() {
    this = TSsaCertainUpdate(_, _, _, _) or
    this = TSsaUncertainUpdate(_, _, _, _) or
    this = TSsaUntracked(_, _)
  }
}

/** An SSA variable that is defined by a `VariableUpdate`. */
class SsaExplicitUpdate extends SsaUpdate, TSsaCertainUpdate {
  SsaExplicitUpdate() {
    exists(VariableUpdate upd | upd = this.getCFGNode() and getDestVar(upd) = getSourceVariable())
  }

  override string toString() { result = "SSA def(" + getSourceVariable() + ")" }

  /** Gets the `VariableUpdate` defining the SSA variable. */
  VariableUpdate getDefiningExpr() {
    result = this.getCFGNode() and getDestVar(result) = getSourceVariable()
  }
}

/**
 * An SSA variable that represents any sort of implicit update. This can be a
 * `Call` that might reach a non-local update of the field, an explicit or
 * implicit update of the qualifier of the field, or the implicit update that
 * occurs just prior to a `FieldRead` of an untracked field.
 */
class SsaImplicitUpdate extends SsaUpdate {
  SsaImplicitUpdate() { not this instanceof SsaExplicitUpdate }

  override string toString() {
    result = "SSA impl upd[" + getKind() + "](" + getSourceVariable() + ")"
  }

  private string getKind() {
    this = TSsaUntracked(_, _) and result = "untracked"
    or
    certainVariableUpdate(getSourceVariable().getQualifier(), getCFGNode(), _, _) and
    result = "explicit qualifier"
    or
    if uncertainVariableUpdate(getSourceVariable().getQualifier(), getCFGNode(), _, _)
    then
      if exists(getANonLocalUpdate())
      then result = "nonlocal + nonlocal qualifier"
      else result = "nonlocal qualifier"
    else (
      exists(getANonLocalUpdate()) and result = "nonlocal"
    )
  }

  /**
   * Gets a reachable `FieldWrite` that might represent this ssa update, if any.
   */
  FieldWrite getANonLocalUpdate() {
    exists(SsaSourceField f, Callable setter |
      f = getSourceVariable() and
      relevantFieldUpdate(setter, f.getField(), result) and
      updatesNamedField(getCFGNode(), f, setter)
    )
  }

  /**
   * Holds if this ssa variable might change the value to something unknown.
   *
   * Examples include updates that might change the value of the qualifier, or
   * reads from untracked variables, for example those where the field or one
   * of its qualifiers is volatile.
   */
  predicate assignsUnknownValue() {
    this = TSsaUntracked(_, _) or
    certainVariableUpdate(getSourceVariable().getQualifier(), getCFGNode(), _, _) or
    uncertainVariableUpdate(getSourceVariable().getQualifier(), getCFGNode(), _, _)
  }
}

/**
 * An SSA variable that represents an uncertain implicit update of the value.
 * This is a `Call` that might reach a non-local update of the field or one of
 * its qualifiers.
 */
class SsaUncertainImplicitUpdate extends SsaImplicitUpdate, TSsaUncertainUpdate {
  /**
   * Gets the immediately preceding definition. Since this update is uncertain
   * the value from the preceding definition might still be valid.
   */
  SsaVariable getPriorDef() { ssaDefReachesUncertainDef(_, result, this) }
}

/**
 * An SSA variable that is defined by its initial value in the callable. This
 * includes initial values of parameters, fields, and closure variables.
 */
class SsaImplicitInit extends SsaVariable, TSsaEntryDef {
  override string toString() { result = "SSA init(" + getSourceVariable() + ")" }

  /** Holds if this is a closure variable that captures the value of `capturedvar`. */
  predicate captures(SsaVariable capturedvar) {
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
class SsaPhiNode extends SsaVariable, TSsaPhiNode {
  override string toString() { result = "SSA phi(" + getSourceVariable() + ")" }

  /** Gets an input to the phi node defining the SSA variable. */
  SsaVariable getAPhiInput() {
    exists(BasicBlock phiPred, TrackedVar v |
      v = getSourceVariable() and
      getCFGNode().(BasicBlock).getABBPredecessor() = phiPred and
      ssaDefReachesEndOfBlock(v, result, phiPred)
    )
  }

  /** Holds if `inp` is an input to the phi node along the edge originating in `bb`. */
  predicate hasInputFromBlock(SsaVariable inp, BasicBlock bb) {
    this.getAPhiInput() = inp and
    this.getBasicBlock().getABBPredecessor() = bb and
    inp.isLiveAtEndOfBlock(bb)
  }
}

private class RefTypeCastExpr extends CastExpr {
  RefTypeCastExpr() { this.getType() instanceof RefType }
}

/**
 * Gets an expression that has the same value as the given SSA variable.
 *
 * The `VarAccess` represents the access to `v` that `result` has the same value as.
 */
Expr sameValue(SsaVariable v, VarAccess va) {
  result = v.getAUse() and result = va
  or
  result.(AssignExpr).getDest() = va and result = v.(SsaExplicitUpdate).getDefiningExpr()
  or
  result.(AssignExpr).getSource() = sameValue(v, va)
  or
  result.(RefTypeCastExpr).getExpr() = sameValue(v, va)
}

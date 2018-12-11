/**
 * Provides predicates for performing nullness analyses.
 *
 * Nullness analyses are used to identify places in a program where
 * a `null` pointer exception (`NullReferenceException`) may be thrown.
 * Example:
 *
 * ```
 * void M(string s) {
 *   if (s != null) {
 *     ...
 *   }
 *   ...
 *   var i = s.IndexOf('a'); // s may be null
 *   ...
 * }
 * ```
 */

import csharp
private import ControlFlow
private import semmle.code.csharp.commons.Assertions
private import semmle.code.csharp.commons.ComparisonTest
private import semmle.code.csharp.controlflow.Guards as G
private import semmle.code.csharp.controlflow.Guards::AbstractValues
private import semmle.code.csharp.dataflow.SSA
private import semmle.code.csharp.frameworks.System
private import semmle.code.csharp.frameworks.Test

/** An expression that may be `null`. */
class MaybeNullExpr extends Expr {
  MaybeNullExpr() {
    this instanceof NullLiteral
    or
    this.(ConditionalExpr).getThen() instanceof MaybeNullExpr
    or
    this.(ConditionalExpr).getElse() instanceof MaybeNullExpr
    or
    this.(AssignExpr).getRValue() instanceof MaybeNullExpr
    or
    this.(Cast).getExpr() instanceof MaybeNullExpr
  }
}

/** An expression that is always `null`. */
class AlwaysNullExpr extends Expr {
  AlwaysNullExpr() {
    this instanceof NullLiteral
    or
    this = any(ConditionalExpr ce |
      ce.getThen() instanceof AlwaysNullExpr and
      ce.getElse() instanceof AlwaysNullExpr
    )
    or
    this.(AssignExpr).getRValue() instanceof AlwaysNullExpr
    or
    this.(Cast).getExpr() instanceof AlwaysNullExpr
  }
}

/** An expression that is never `null`. */
class NonNullExpr extends Expr {
  NonNullExpr() {
    G::Internal::nonNullValue(this)
    or
    exists(NonNullExpr mid |
      G::Internal::nonNullValueImplied(mid, this)
    )
    or
    this instanceof G::NullGuardedExpr
    or
    exists(Ssa::Definition def | nonNullDef(def) | this = def.getARead())
  }
}

/** Holds if SSA definition `def` is never `null`. */
private predicate nonNullDef(Ssa::Definition v) {
  v.(Ssa::ExplicitDefinition).getADefinition().getSource() instanceof NonNullExpr
  or
  exists(AssignableDefinition ad |
    ad = v.(Ssa::ExplicitDefinition).getADefinition() |
    ad instanceof AssignableDefinitions::IsPatternDefinition
    or
    ad instanceof AssignableDefinitions::TypeCasePatternDefinition
    or
    ad = any(AssignableDefinitions::LocalVariableDefinition d |
      d.getExpr() = any(SpecificCatchClause scc).getVariableDeclExpr()
      or
      d.getExpr() = any(ForeachStmt fs).getAVariableDeclExpr()
    )
  )
}

/**
 * Holds if the `i`th node of basic block `bb` is a dereference `d` of SSA
 * definition `def`.
 */
private predicate dereferenceAt(BasicBlock bb, int i, Ssa::Definition def, Dereference d) {
  d = def.getAReadAtNode(bb.getNode(i))
}

/**
 * Holds if `e` having abstract value `vExpr` implies that SSA definition `def`
 * has abstract value `vDef`.
 */
private predicate exprImpliesSsaDef(Expr e, G::AbstractValue vExpr, Ssa::Definition def, G::AbstractValue vDef) {
  exists(G::Internal::Guard g |
    G::Internal::impliesSteps(e, vExpr, g, vDef) |
    g = def.getARead()
    or
    g = def.(Ssa::ExplicitDefinition).getADefinition().getTargetAccess()
  )
}

/**
 * Holds if the `i`th node of basic block `bb` ensures that SSA definition
 * `def` is not `null` in any subsequent uses.
 */
private predicate ensureNotNullAt(BasicBlock bb, int i, Ssa::Definition def) {
  exists(Expr e, G::AbstractValue v, NullValue nv |
    G::Internal::asserts(bb.getNode(i).getElement(), e, v) |
    exprImpliesSsaDef(e, v, def, nv) and
    not nv.isNull()
  )
}

/**
 * Holds if the `i`th node of basic block `bb` is a dereference `d` of SSA
 * definition `def`, and `def` may potentially be `null`.
 */
private predicate potentialNullDereferenceAt(BasicBlock bb, int i, Ssa::Definition def, Dereference d) {
  dereferenceAt(bb, i, def, d) and
  not exists(int j | ensureNotNullAt(bb, j, def) | j < i)
}

/**
 * Gets an element that tests whether a given SSA definition, `def`, is
 * `null` or not.
 *
 * If the returned element takes the `s` branch, then `def` is guaranteed to be
 * `null` if `nv.isNull()` holds, and non-`null` otherwise.
 */
private ControlFlowElement getANullCheck(Ssa::Definition def, SuccessorTypes::ConditionalSuccessor s, NullValue nv) {
  exists(Expr e, G::AbstractValue v |
    v.branch(result, s, e) |
    exprImpliesSsaDef(e, v, def, nv)
  )
}

/** Holds if `def` is an SSA definition that may be `null`. */
private predicate defMaybeNull(Ssa::Definition def, string msg, Element reason) {
  // A variable compared to `null` might be `null`
  exists(G::DereferenceableExpr de |
    de = def.getARead() |
    reason = de.getANullCheck(_, true) and
    msg = "as suggested by $@ null check" and
    not def instanceof Ssa::PseudoDefinition and
    strictcount(Location l |
      l = any(Ssa::Definition def0 | de = def0.getARead()).getLocation()
    ) = 1 and
    not nonNullDef(def) and
    // Don't use a check as reason if there is a `null` assignment
    not def.(Ssa::ExplicitDefinition).getADefinition().getSource() instanceof MaybeNullExpr
  )
  or
  // A parameter might be `null` if there is a `null` argument somewhere
  exists(AssignableDefinitions::ImplicitParameterDefinition pdef, Parameter p, MaybeNullExpr arg |
    pdef = def.(Ssa::ExplicitDefinition).getADefinition() |
    p = pdef.getParameter().getSourceDeclaration() and
    p.getAnAssignedArgument() = arg and
    reason = arg and
    msg = "because of $@ null argument" and
    not arg.getEnclosingCallable().getEnclosingCallable*() instanceof TestMethod
  )
  or
  // If the source of a variable is `null` then the variable may be `null`
  exists(AssignableDefinition adef |
    adef = def.(Ssa::ExplicitDefinition).getADefinition() |
    adef.getSource() instanceof MaybeNullExpr and
    reason = adef.getExpr() and
    msg = "because of $@ assignment"
  )
  or
  // A variable of nullable type may be null
  exists(Dereference d |
    dereferenceAt(_, _, def, d) |
    d.hasNullableType() and
    not def instanceof Ssa::PseudoDefinition and
    reason = def.getSourceVariable().getAssignable() and
    msg = "because it has a nullable type"
  )
}

/**
 * Holds if `def1` being `null` in basic block `bb1` implies that `def2` might
 * be `null` in basic block `bb2`. The SSA definitions share the same source
 * variable.
 */
private predicate defNullImpliesStep(Ssa::Definition def1, BasicBlock bb1, Ssa::Definition def2, BasicBlock bb2) {
  exists(Ssa::SourceVariable v |
    defMaybeNull(v.getAnSsaDefinition(), _, _) and
    def1.getSourceVariable() = v
  |
    def2.(Ssa::PseudoDefinition).getAnInput() = def1 and
    def2.definesAt(bb2, _)
    or
    def2 = def1 and
    not exists(Ssa::PseudoDefinition def |
      def.getSourceVariable() = v and
      def.definesAt(bb2, _)
    )
  ) and
  def1.isLiveAtEndOfBlock(bb1) and
  not ensureNotNullAt(bb1, _, def1) and
  bb2 = bb1.getASuccessor() and
  not exists(SuccessorTypes::ConditionalSuccessor s, NullValue nv |
    bb1.getLastNode() = getANullCheck(def1, s, nv).getAControlFlowNode() |
    bb2 = bb1.getASuccessorByType(s) and
    not nv.isNull()
  )
}

/**
 * The transitive closure of `defNullImpliesStep()` originating from `defMaybeNull()`.
 * That is, those basic blocks for which the SSA definition is suspected of being `null`.
 */
private predicate defMaybeNullInBlock(Ssa::Definition def, Ssa::SourceVariable v, BasicBlock bb) {
  defMaybeNull(def, _, _) and
  def.definesAt(bb, _) and
  v = def.getSourceVariable()
  or
  exists(BasicBlock mid, Ssa::Definition midDef |
    defMaybeNullInBlock(midDef, v, mid) |
    defNullImpliesStep(midDef, mid, def, bb)
  )
}

/**
 * Holds if `v` is a source variable that might reach a potential `null`
 * dereference.
 */
private predicate nullDerefCandidateVariable(Ssa::SourceVariable v) {
  exists(Ssa::Definition def, BasicBlock bb |
    potentialNullDereferenceAt(bb, _, def, _) |
    defMaybeNullInBlock(def, v, bb)
  )
}

private predicate defMaybeNullInBlockOrigin(Ssa::Definition origin, Ssa::Definition def, BasicBlock bb) {
  nullDerefCandidateVariable(def.getSourceVariable()) and
  defMaybeNull(def, _, _) and
  def.definesAt(bb, _) and
  origin = def
  or
  exists(BasicBlock mid, Ssa::Definition midDef |
    defMaybeNullInBlockOrigin(origin, midDef, mid) and
    defNullImpliesStep(midDef, mid, def, bb)
  )
}

private Ssa::Definition getAPseudoInput(Ssa::Definition def) {
  result = def.(Ssa::PseudoDefinition).getAnInput()
}

// `def.getAnUltimateDefinition()` includes inputs into uncertain
// definitions, but we only want inputs into pseudo nodes
private Ssa::Definition getAnUltimateDefinition(Ssa::Definition def) {
  result = getAPseudoInput*(def) and
  not result instanceof Ssa::PseudoDefinition
}

/**
 * Holds if SSA definition `def` can reach a read `ar`, without passing
 * through an intermediate dereference that always (`always = true`) or
 * maybe (`always = false`) throws a null reference exception.
 */
private predicate defReaches(Ssa::Definition def, AssignableRead ar, boolean always) {
  ar = def.getAFirstRead() and
  (always = true or always = false)
  or
  exists(AssignableRead mid |
    defReaches(def, mid, always) |
    ar = mid.getANextRead() and
    not mid = any(Dereference d |
      if always = true then d.isAlwaysNull(def.getSourceVariable()) else d.isMaybeNull(def, _, _)
    )
  )
}

/**
 * An expression that dereferences a value. That is, an expression that may
 * result in a `NullReferenceException` if the value is `null`.
 */
class Dereference extends G::DereferenceableExpr {
  Dereference() {
    if this.hasNullableType() then (
      // Strictly speaking, these throw `InvalidOperationException`s and not
      // `NullReferenceException`s
      this = any(PropertyAccess pa | pa.getTarget().hasName("Value")).getQualifier()
      or
      exists(Type underlyingType |
        this = any(CastExpr ce | ce.getTargetType() = underlyingType).getExpr() |
        underlyingType = this.getType().(NullableType).getUnderlyingType()
        or
        underlyingType = this.getType() and
        not underlyingType instanceof NullableType
      )
    )
    else (
      this = any(QualifiableExpr qe | not qe.isConditional()).getQualifier() and
      not this instanceof ThisAccess and
      not this instanceof BaseAccess and
      not this instanceof TypeAccess
      or
      this = any(LockStmt stmt).getExpr()
      or
      this = any(ForeachStmt stmt).getIterableExpr()
      or
      exists(ExtensionMethodCall emc, Parameter p |
        this = emc.getArgumentForParameter(p) and
        p.hasExtensionMethodModifier() and
        not emc.isConditional() |
        p.fromSource() // assume all non-source extension methods perform a dereference
        implies
        exists(Ssa::ExplicitDefinition def, AssignableDefinitions::ImplicitParameterDefinition pdef |
          pdef = def.getADefinition() |
          p.getSourceDeclaration() = pdef.getParameter() and
          def.getARead() instanceof Dereference
        )
      )
    )
  }

  private predicate isAlwaysNull0(Ssa::Definition def) {
    forall(Ssa::Definition input |
      input = getAnUltimateDefinition(def) |
      input.(Ssa::ExplicitDefinition).getADefinition().getSource() instanceof AlwaysNullExpr
    ) and
    not nonNullDef(def) and
    this = def.getARead() and
    not this instanceof G::NullGuardedExpr
  }

  /**
   * Holds if this expression dereferences SSA source variable `v`, which is
   * always `null`.
   */
  predicate isAlwaysNull(Ssa::SourceVariable v) {
    this = v.getAnAccess() and
    // Exclude fields, properties, and captured variables, as they may not have an
    // accurate SSA representation
    v.getAssignable() = any(LocalScopeVariable lsv |
      strictcount(Callable c |
        c = any(AssignableDefinition ad | ad.getTarget() = lsv).getEnclosingCallable()
      ) = 1
    ) and
    (
      forex(Ssa::Definition def0 |
        this = def0.getARead() |
        this.isAlwaysNull0(def0)
      )
      or
      exists(NullValue nv |
        this.(G::GuardedExpr).mustHaveValue(nv) and
        nv.isNull()
      )
    ) and
    not this instanceof G::NullGuardedExpr
  }

  /**
   * Holds if this expression dereferences SSA source variable `v`, which is
   * always `null`, and this expression can be reached from an SSA definition
   * for `v` without passing through another such dereference.
   */
  predicate isFirstAlwaysNull(Ssa::SourceVariable v) {
    this.isAlwaysNull(v) and
    defReaches(v.getAnSsaDefinition(), this, true)
  }

  pragma[noinline]
  private predicate nullDerefCandidate(Ssa::Definition origin) {
    exists(Ssa::Definition ssa, BasicBlock bb |
      potentialNullDereferenceAt(bb, _, ssa, this) |
      defMaybeNullInBlockOrigin(origin, ssa, bb)
    )
  }

  /**
   * Holds if this expression dereferences SSA definition `def`, which may
   * be `null`.
   */
  predicate isMaybeNull(Ssa::Definition def, string msg, Element reason) {
    exists(Ssa::Definition origin, BasicBlock bb |
      this.nullDerefCandidate(origin) and
      defMaybeNull(origin, msg, reason) and
      potentialNullDereferenceAt(bb, _, def, this)
    ) and
    not this.isAlwaysNull(def.getSourceVariable())
  }

  /**
   * Holds if this expression dereferences SSA definition `def`, which may
   * be `null`, and this expression can be reached from `def` without passing
   * through another such dereference.
   */
  predicate isFirstMaybeNull(Ssa::Definition def, string msg, Element reason) {
    this.isMaybeNull(def, msg, reason) and
    defReaches(def, this, false)
  }
}

/**
 * Provides predicates for performing nullness analyses.
 *
 * Nullness analyses are used to identify places in a program where
 * a `null` pointer exception (`NullReferenceException`) may be thrown.
 * Example:
 *
 * ```csharp
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
private import internal.CallableReturns
private import semmle.code.csharp.commons.Assertions
private import semmle.code.csharp.controlflow.Guards as G
private import semmle.code.csharp.controlflow.Guards::AbstractValues
private import semmle.code.csharp.frameworks.System
private import semmle.code.csharp.frameworks.Test

/** An expression that may be `null`. */
class MaybeNullExpr extends Expr {
  MaybeNullExpr() {
    G::Internal::nullValue(this)
    or
    this instanceof AsExpr
    or
    this.(AssignExpr).getRValue() instanceof MaybeNullExpr
    or
    this.(Cast).getExpr() instanceof MaybeNullExpr
    or
    this =
      any(ConditionalExpr ce |
        ce.getThen() instanceof MaybeNullExpr
        or
        ce.getElse() instanceof MaybeNullExpr
      )
    or
    this.(NullCoalescingExpr).getRightOperand() instanceof MaybeNullExpr
  }
}

/** An expression that is always `null`. */
class AlwaysNullExpr extends Expr {
  AlwaysNullExpr() {
    G::Internal::nullValue(this)
    or
    exists(AlwaysNullExpr e | G::Internal::nullValueImpliedUnary(e, this))
    or
    exists(AlwaysNullExpr e1, AlwaysNullExpr e2 | G::Internal::nullValueImpliedBinary(e1, e2, this))
    or
    this =
      any(Ssa::Definition def |
        forex(Ssa::Definition u | u = def.getAnUltimateDefinition() | nullDef(u))
      ).getARead()
    or
    exists(Callable target |
      this.(Call).getTarget() = target and
      not target.(Virtualizable).isVirtual() and
      alwaysNullCallable(target)
    )
  }
}

/** Holds if SSA definition `def` is always `null`. */
private predicate nullDef(Ssa::ExplicitDefinition def) {
  def.getADefinition().getSource() instanceof AlwaysNullExpr
}

/** An expression that is never `null`. */
class NonNullExpr extends Expr {
  NonNullExpr() {
    G::Internal::nonNullValue(this)
    or
    exists(NonNullExpr mid | G::Internal::nonNullValueImpliedUnary(mid, this))
    or
    this instanceof G::NullGuardedExpr
    or
    this =
      any(Ssa::Definition def |
        forex(Ssa::Definition u | u = def.getAnUltimateDefinition() | nonNullDef(u))
      ).getARead()
    or
    exists(Callable target |
      this.(Call).getTarget() = target and
      not target.(Virtualizable).isVirtual() and
      alwaysNotNullCallable(target) and
      not this.(QualifiableExpr).isConditional()
    )
  }
}

/** Holds if SSA definition `def` is never `null`. */
private predicate nonNullDef(Ssa::ExplicitDefinition def) {
  def.getADefinition().getSource() instanceof NonNullExpr
  or
  exists(AssignableDefinition ad | ad = def.getADefinition() |
    ad instanceof AssignableDefinitions::PatternDefinition
    or
    ad =
      any(AssignableDefinitions::LocalVariableDefinition d |
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
private predicate exprImpliesSsaDef(
  Expr e, G::AbstractValue vExpr, Ssa::Definition def, G::AbstractValue vDef
) {
  exists(G::Guard g | G::Internal::impliesSteps(e, vExpr, g, vDef) |
    g = def.getARead()
    or
    g = def.(Ssa::ExplicitDefinition).getADefinition().getTargetAccess()
  )
}

/**
 * Gets an element that tests whether a given SSA definition, `def`, is
 * `null` or not.
 *
 * If the returned element takes the `s` branch, then `def` is guaranteed to be
 * `null` if `nv.isNull()` holds, and non-`null` otherwise.
 */
private ControlFlowElement getANullCheck(
  Ssa::Definition def, SuccessorTypes::ConditionalSuccessor s, NullValue nv
) {
  exists(Expr e, G::AbstractValue v | v.branch(result, s, e) | exprImpliesSsaDef(e, v, def, nv))
}

private predicate isMaybeNullArgument(Ssa::ExplicitDefinition def, MaybeNullExpr arg) {
  exists(AssignableDefinitions::ImplicitParameterDefinition pdef, Parameter p |
    pdef = def.getADefinition()
  |
    p = pdef.getParameter().getSourceDeclaration() and
    arg = p.getAnAssignedArgument() and
    not arg.getEnclosingCallable().getEnclosingCallable*() instanceof TestMethod
  )
}

private predicate isNullDefaultArgument(Ssa::ExplicitDefinition def, AlwaysNullExpr arg) {
  exists(AssignableDefinitions::ImplicitParameterDefinition pdef, Parameter p |
    pdef = def.getADefinition()
  |
    p = pdef.getParameter().getSourceDeclaration() and
    arg = p.getDefaultValue() and
    not arg.getEnclosingCallable().getEnclosingCallable*() instanceof TestMethod
  )
}

/** Holds if `def` is an SSA definition that may be `null`. */
private predicate defMaybeNull(Ssa::Definition def, string msg, Element reason) {
  not nonNullDef(def) and
  (
    // A variable compared to `null` might be `null`
    exists(G::DereferenceableExpr de | de = def.getARead() |
      reason = de.getANullCheck(_, true) and
      msg = "as suggested by $@ null check" and
      not de = any(Ssa::PseudoDefinition pdef).getARead() and
      strictcount(Element e | e = any(Ssa::Definition def0 | de = def0.getARead()).getElement()) = 1 and
      // Don't use a check as reason if there is a `null` assignment
      // or argument
      not def.(Ssa::ExplicitDefinition).getADefinition().getSource() instanceof MaybeNullExpr and
      not isMaybeNullArgument(def, _)
    )
    or
    // A parameter might be `null` if there is a `null` argument somewhere
    isMaybeNullArgument(def, reason) and
    (
      if reason instanceof AlwaysNullExpr
      then msg = "because of $@ null argument"
      else msg = "because of $@ potential null argument"
    )
    or
    isNullDefaultArgument(def, reason) and msg = "because the parameter has a null default value"
    or
    // If the source of a variable is `null` then the variable may be `null`
    exists(AssignableDefinition adef | adef = def.(Ssa::ExplicitDefinition).getADefinition() |
      adef.getSource() instanceof MaybeNullExpr and
      reason = adef.getExpr() and
      msg = "because of $@ assignment"
    )
    or
    // A variable of nullable type may be null
    exists(Dereference d | dereferenceAt(_, _, def, d) |
      d.hasNullableType() and
      not def instanceof Ssa::PseudoDefinition and
      reason = def.getSourceVariable().getAssignable() and
      msg = "because it has a nullable type"
    )
  )
}

pragma[noinline]
private predicate sourceVariableMaybeNull(Ssa::SourceVariable v) {
  defMaybeNull(v.getAnSsaDefinition(), _, _)
}

pragma[noinline]
private predicate defNullImpliesStep0(
  Ssa::SourceVariable v, Ssa::Definition def1, BasicBlock bb1, BasicBlock bb2
) {
  sourceVariableMaybeNull(v) and
  def1.getSourceVariable() = v and
  def1.isLiveAtEndOfBlock(bb1) and
  bb2 = bb1.getASuccessor()
}

/**
 * Holds if `def1` being `null` in basic block `bb1` implies that `def2` might
 * be `null` in basic block `bb2`. The SSA definitions share the same source
 * variable.
 */
private predicate defNullImpliesStep(
  Ssa::Definition def1, BasicBlock bb1, Ssa::Definition def2, BasicBlock bb2
) {
  exists(Ssa::SourceVariable v | defNullImpliesStep0(v, def1, bb1, bb2) |
    def2.(Ssa::PseudoDefinition).getAnInput() = def1 and
    bb2 = def2.getBasicBlock()
    or
    def2 = def1 and
    not exists(Ssa::PseudoDefinition def |
      def.getSourceVariable() = v and
      bb2 = def.getBasicBlock()
    )
  ) and
  not exists(SuccessorTypes::ConditionalSuccessor s, NullValue nv |
    bb1.getLastNode() = getANullCheck(def1, s, nv).getAControlFlowNode()
  |
    bb2 = bb1.getASuccessorByType(s) and
    nv.isNonNull()
  )
}

/**
 * The transitive closure of `defNullImpliesStep()` originating from `defMaybeNull()`.
 * That is, those basic blocks for which the SSA definition is suspected of being `null`.
 */
private predicate defMaybeNullInBlock(Ssa::Definition def, BasicBlock bb) {
  defMaybeNull(def, _, _) and
  bb = def.getBasicBlock()
  or
  exists(BasicBlock mid, Ssa::Definition midDef | defMaybeNullInBlock(midDef, mid) |
    defNullImpliesStep(midDef, mid, def, bb)
  )
}

/**
 * Holds if `v` is a source variable that might reach a potential `null`
 * dereference.
 */
private predicate nullDerefCandidateVariable(Ssa::SourceVariable v) {
  exists(Ssa::Definition def, BasicBlock bb | dereferenceAt(bb, _, def, _) |
    defMaybeNullInBlock(def, bb) and
    v = def.getSourceVariable()
  )
}

private predicate succStep(PathNode pred, Ssa::Definition def, BasicBlock bb) {
  defNullImpliesStep(pred.getSsaDefinition(), pred.getBasicBlock(), def, bb)
}

private predicate succNullArgument(SourcePathNode pred, Ssa::Definition def, BasicBlock bb) {
  pred = TSourcePathNode(def, _, _, true) and
  bb = def.getBasicBlock()
}

private predicate succSourceSink(SourcePathNode source, Ssa::Definition def, BasicBlock bb) {
  source = TSourcePathNode(def, _, _, false) and
  bb = def.getBasicBlock()
}

private newtype TPathNode =
  TSourcePathNode(Ssa::Definition def, string msg, Element reason, boolean isNullArgument) {
    nullDerefCandidateVariable(def.getSourceVariable()) and
    defMaybeNull(def, msg, reason) and
    if isMaybeNullArgument(def, reason) then isNullArgument = true else isNullArgument = false
  } or
  TInternalPathNode(Ssa::Definition def, BasicBlock bb) {
    succStep(_, def, bb)
    or
    succNullArgument(_, def, bb)
  } or
  TSinkPathNode(Ssa::Definition def, BasicBlock bb, int i, Dereference d) {
    dereferenceAt(bb, i, def, d) and
    (
      succStep(_, def, bb)
      or
      succNullArgument(_, def, bb)
      or
      succSourceSink(_, def, bb)
    )
  }

/**
 * An SSA definition, which may be `null`, augmented with at basic block which can
 * be reached without passing through a `null` check.
 */
abstract class PathNode extends TPathNode {
  /** Gets the SSA definition. */
  abstract Ssa::Definition getSsaDefinition();

  /** Gets the basic block that can be reached without passing through a `null` check. */
  abstract BasicBlock getBasicBlock();

  /** Gets another node that can be reached from this node. */
  abstract PathNode getASuccessor();

  /** Gets a textual representation of this node. */
  abstract string toString();

  /** Gets the location of this node. */
  abstract Location getLocation();
}

private class SourcePathNode extends PathNode, TSourcePathNode {
  private Ssa::Definition def;
  private string msg;
  private Element reason;
  private boolean isNullArgument;

  SourcePathNode() { this = TSourcePathNode(def, msg, reason, isNullArgument) }

  override Ssa::Definition getSsaDefinition() { result = def }

  override BasicBlock getBasicBlock() {
    isNullArgument = false and
    result = def.getBasicBlock()
  }

  string getMessage() { result = msg }

  Element getReason() { result = reason }

  override PathNode getASuccessor() {
    succStep(this, result.getSsaDefinition(), result.getBasicBlock())
    or
    succNullArgument(this, result.getSsaDefinition(), result.getBasicBlock())
    or
    result instanceof SinkPathNode and
    succSourceSink(this, result.getSsaDefinition(), result.getBasicBlock())
  }

  override string toString() {
    if isNullArgument = true then result = reason.toString() else result = def.toString()
  }

  override Location getLocation() {
    if isNullArgument = true then result = reason.getLocation() else result = def.getLocation()
  }
}

private class InternalPathNode extends PathNode, TInternalPathNode {
  private Ssa::Definition def;
  private BasicBlock bb;

  InternalPathNode() { this = TInternalPathNode(def, bb) }

  override Ssa::Definition getSsaDefinition() { result = def }

  override BasicBlock getBasicBlock() { result = bb }

  override PathNode getASuccessor() {
    succStep(this, result.getSsaDefinition(), result.getBasicBlock())
  }

  override string toString() { result = bb.getFirstNode().toString() }

  override Location getLocation() { result = bb.getFirstNode().getLocation() }
}

private class SinkPathNode extends PathNode, TSinkPathNode {
  private Ssa::Definition def;
  private BasicBlock bb;
  private int i;
  private Dereference d;

  SinkPathNode() { this = TSinkPathNode(def, bb, i, d) }

  override Ssa::Definition getSsaDefinition() { result = def }

  override BasicBlock getBasicBlock() { result = bb }

  override PathNode getASuccessor() { none() }

  Dereference getDereference() { result = d }

  override string toString() { result = d.toString() }

  override Location getLocation() { result = d.getLocation() }
}

/**
 * Provides the query predicates needed to include a graph in a path-problem query
 * for `Dereference::is[First]MaybeNull()`.
 */
module PathGraph {
  query predicate nodes(PathNode n) { n.getASuccessor*() instanceof SinkPathNode }

  query predicate edges(PathNode pred, PathNode succ) {
    nodes(pred) and
    nodes(succ) and
    succ = pred.getASuccessor()
  }
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
 * Holds if SSA definition `def` can reach a read at `cfn`, without passing
 * through an intermediate dereference that always (`always = true`) or
 * maybe (`always = false`) throws a null reference exception.
 */
private predicate defReaches(Ssa::Definition def, ControlFlow::Node cfn, boolean always) {
  exists(def.getAFirstReadAtNode(cfn)) and
  (always = true or always = false)
  or
  exists(ControlFlow::Node mid | defReaches(def, mid, always) |
    Ssa::Internal::adjacentReadPairSameVar(_, mid, cfn) and
    not mid =
      any(Dereference d |
        if always = true
        then d.isAlwaysNull(def.getSourceVariable())
        else d.isMaybeNull(def, _, _, _, _)
      ).getAControlFlowNode()
  )
}

/**
 * An expression that dereferences a value. That is, an expression that may
 * result in a `NullReferenceException` if the value is `null`.
 */
class Dereference extends G::DereferenceableExpr {
  Dereference() {
    if this.hasNullableType()
    then (
      // Strictly speaking, these throw `InvalidOperationException`s and not
      // `NullReferenceException`s
      this = any(PropertyAccess pa | pa.getTarget().hasName("Value")).getQualifier()
      or
      exists(Type underlyingType |
        this = any(CastExpr ce | ce.getTargetType() = underlyingType).getExpr()
      |
        underlyingType = this.getType().(NullableType).getUnderlyingType()
        or
        underlyingType = this.getType() and
        not underlyingType instanceof NullableType
      )
    ) else (
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
        not emc.isConditional()
      |
        p.fromSource() // assume all non-source extension methods perform a dereference
        implies
        exists(
          Ssa::ExplicitDefinition def, AssignableDefinitions::ImplicitParameterDefinition pdef
        |
          pdef = def.getADefinition()
        |
          p.getSourceDeclaration() = pdef.getParameter() and
          def.getARead() instanceof Dereference
        )
      )
    )
  }

  private predicate isAlwaysNull0(Ssa::Definition def) {
    forall(Ssa::Definition input | input = getAnUltimateDefinition(def) |
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
    v.getAssignable() =
      any(LocalScopeVariable lsv |
        strictcount(Callable c |
          c = any(AssignableDefinition ad | ad.getTarget() = lsv).getEnclosingCallable()
        ) = 1
      ) and
    (
      forex(Ssa::Definition def0 | this = def0.getARead() | this.isAlwaysNull0(def0))
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
    defReaches(v.getAnSsaDefinition(), this.getAControlFlowNode(), true)
  }

  /**
   * Holds if this expression dereferences SSA definition `def`, which may
   * be `null`.
   */
  predicate isMaybeNull(
    Ssa::Definition def, SourcePathNode source, SinkPathNode sink, string msg, Element reason
  ) {
    source.getASuccessor*() = sink and
    msg = source.getMessage() and
    reason = source.getReason() and
    def = sink.getSsaDefinition() and
    this = sink.getDereference() and
    not this.isAlwaysNull(def.getSourceVariable())
  }

  /**
   * Holds if this expression dereferences SSA definition `def`, which may
   * be `null`, and this expression can be reached from `def` without passing
   * through another such dereference.
   */
  predicate isFirstMaybeNull(
    Ssa::Definition def, SourcePathNode source, SinkPathNode sink, string msg, Element reason
  ) {
    this.isMaybeNull(def, source, sink, msg, reason) and
    defReaches(def, this.getAControlFlowNode(), false)
  }
}

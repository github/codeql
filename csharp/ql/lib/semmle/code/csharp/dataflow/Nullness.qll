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
private import semmle.code.csharp.controlflow.Guards as G
private import semmle.code.csharp.dataflow.internal.SsaImpl as SsaImpl
private import semmle.code.csharp.frameworks.System
private import semmle.code.csharp.frameworks.Test
private import semmle.code.csharp.controlflow.ControlFlowReachability

private Expr maybeNullExpr(Expr reason) {
  G::Internal::nullValue(result) and reason = result
  or
  result instanceof AsExpr and reason = result
  or
  result.(AssignExpr).getRValue() = maybeNullExpr(reason)
  or
  result.(CastExpr).getExpr() = maybeNullExpr(reason)
  or
  result =
    any(ConditionalExpr ce |
      ce.getThen() = maybeNullExpr(reason)
      or
      ce.getElse() = maybeNullExpr(reason)
    )
  or
  result.(NullCoalescingExpr).getRightOperand() = maybeNullExpr(reason)
}

/** An expression that may be `null`. */
class MaybeNullExpr extends Expr {
  MaybeNullExpr() { this = maybeNullExpr(_) }
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
 * Holds if `node` is a dereference `d` of SSA definition `def`.
 */
private predicate dereferenceAt(ControlFlow::Node node, Ssa::Definition def, Dereference d) {
  d = def.getAReadAtNode(node)
}

private predicate isMaybeNullArgument(Ssa::ImplicitParameterDefinition def, MaybeNullExpr arg) {
  exists(AssignableDefinitions::ImplicitParameterDefinition pdef, Parameter p |
    p = def.getParameter()
  |
    p = pdef.getParameter().getUnboundDeclaration() and
    arg = p.getAnAssignedArgument() and
    not arg.getEnclosingCallable().getEnclosingCallable*() instanceof TestMethod and
    (
      p.isParams()
      implies
      (
        isValidExplicitParamsType(p, arg.getType()) and
        not exists(Call c | c.getAnArgument() = arg and hasMultipleParamsArguments(c))
      )
    )
  )
}

/**
 * Holds if the type `t` is a valid argument type for passing an explicit array
 * to the `params` parameter `p`. For example, the types `object[]` and `string[]`
 * of the arguments on lines 4 and 5, respectively, are valid for the parameter
 * `args` on line 1 in
 *
 * ```csharp
 * void M(params object[] args) { ... }
 *
 * void CallM(object[] os, string[] ss, string s) {
 *   M(os);
 *   M(ss);
 *   M(s);
 * }
 * ```
 */
pragma[nomagic]
private predicate isValidExplicitParamsType(Parameter p, Type t) {
  p.isParams() and
  t.isImplicitlyConvertibleTo(p.getType())
}

/**
 * Holds if call `c` has multiple arguments for a `params` parameter
 * of the targeted callable.
 */
private predicate hasMultipleParamsArguments(Call c) {
  exists(Parameter p | p = c.getTarget().getAParameter() |
    p.isParams() and
    exists(c.getArgument(any(int i | i > p.getPosition())))
  )
}

private predicate isNullDefaultArgument(Ssa::ImplicitParameterDefinition def, AlwaysNullExpr arg) {
  exists(AssignableDefinitions::ImplicitParameterDefinition pdef, Parameter p |
    p = def.getParameter()
  |
    p = pdef.getParameter().getUnboundDeclaration() and
    arg = p.getDefaultValue() and
    not arg.getEnclosingCallable().getEnclosingCallable*() instanceof TestMethod
  )
}

/** Holds if `def` is an SSA definition that may be `null`. */
private predicate defMaybeNull(
  Ssa::Definition def, ControlFlow::Node node, string msg, Element reason
) {
  not nonNullDef(def) and
  (
    // A variable compared to `null` might be `null`
    exists(G::DereferenceableExpr de | de = def.getARead() |
      de.guardSuggestsMaybeNull(reason) and
      msg = "as suggested by $@ null check" and
      node = def.getControlFlowNode() and
      not de = any(Ssa::PhiNode phi).getARead() and
      // Don't use a check as reason if there is a `null` assignment
      // or argument
      not def.(Ssa::ExplicitDefinition).getADefinition().getSource() instanceof MaybeNullExpr and
      not isMaybeNullArgument(def, _)
    )
    or
    // A parameter might be `null` if there is a `null` argument somewhere
    isMaybeNullArgument(def, reason) and
    node = def.getControlFlowNode() and
    (
      if reason instanceof AlwaysNullExpr
      then msg = "because of $@ null argument"
      else msg = "because of $@ potential null argument"
    )
    or
    isNullDefaultArgument(def, reason) and
    node = def.getControlFlowNode() and
    msg = "because the parameter has a null default value"
    or
    // If the source of a variable is `null` then the variable may be `null`
    exists(AssignableDefinition adef | adef = def.(Ssa::ExplicitDefinition).getADefinition() |
      adef.getSource() = maybeNullExpr(node.getAstNode()) and
      reason = adef.getExpr() and
      msg = "because of $@ assignment"
    )
    or
    // A variable of nullable type may be null
    exists(Dereference d | dereferenceAt(_, def, d) |
      node = def.getControlFlowNode() and
      d.hasNullableType() and
      not def instanceof Ssa::PhiNode and
      reason = def.getSourceVariable().getAssignable() and
      msg = "because it has a nullable type"
    )
  )
}

private Ssa::Definition getAPseudoInput(Ssa::Definition def) {
  result = def.(Ssa::PhiNode).getAnInput()
}

// `def.getAnUltimateDefinition()` includes inputs into uncertain
// definitions, but we only want inputs into pseudo nodes
private Ssa::Definition getAnUltimateDefinition(Ssa::Definition def) {
  result = getAPseudoInput*(def) and
  not result instanceof Ssa::PhiNode
}

/**
 * Holds if SSA definition `def` can reach a read at `cfn`, without passing
 * through an intermediate dereference that always throws a null reference
 * exception.
 */
private predicate defReaches(Ssa::Definition def, ControlFlow::Node cfn) {
  exists(def.getAFirstReadAtNode(cfn))
  or
  exists(ControlFlow::Node mid | defReaches(def, mid) |
    SsaImpl::adjacentReadPairSameVar(_, mid, cfn) and
    not mid = any(Dereference d | d.isAlwaysNull(def.getSourceVariable())).getAControlFlowNode()
  )
}

private module NullnessConfig implements ControlFlowReachability::ConfigSig {
  predicate source(ControlFlow::Node node, Ssa::Definition def) { defMaybeNull(def, node, _, _) }

  predicate sink(ControlFlow::Node node, Ssa::Definition def) {
    exists(Dereference d |
      dereferenceAt(node, def, d) and
      not d instanceof NonNullExpr
    )
  }

  predicate barrierValue(G::GuardValue gv) { gv.isNullness(false) }

  predicate uncertainFlow() { none() }
}

private module NullnessFlow = ControlFlowReachability::Flow<NullnessConfig>;

predicate maybeNullDeref(Dereference d, Ssa::SourceVariable v, string msg, Element reason) {
  exists(
    Ssa::Definition origin, Ssa::Definition ssa, ControlFlow::Node src, ControlFlow::Node sink
  |
    defMaybeNull(origin, src, msg, reason) and
    NullnessFlow::flow(src, origin, sink, ssa) and
    ssa.getSourceVariable() = v and
    dereferenceAt(sink, ssa, d) and
    not d.isAlwaysNull(v)
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
      this =
        any(QualifiableExpr qe |
          not qe.isConditional() and
          not qe.(MethodCall).isImplicit()
        ).getQualifier() and
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
        // Assume all non-source extension methods on
        // (1) nullable types are null-safe
        // (2) non-nullable types are doing a dereference.
        p.fromLibrary() and
        not p.getAnnotatedType().isNullableRefType()
        or
        p.fromSource() and
        exists(
          Ssa::ImplicitParameterDefinition def,
          AssignableDefinitions::ImplicitParameterDefinition pdef
        |
          p = def.getParameter()
        |
          p.getUnboundDeclaration() = pdef.getParameter() and
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
    // Exclude fields and properties, as they may not have an accurate SSA representation
    v.getAssignable() instanceof LocalScopeVariable and
    (
      forex(Ssa::Definition def0 | this = def0.getARead() | this.isAlwaysNull0(def0))
      or
      exists(G::GuardValue nv |
        this.(G::GuardedExpr).mustHaveValue(nv) and
        nv.isNullValue()
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
    defReaches(v.getAnSsaDefinition(), this.getAControlFlowNode())
  }
}

/**
 * Provides classes for working with static single assignment (SSA) form.
 */

import csharp
import SsaImplCommon

/** A classification of variable reads. */
newtype TReadKind =
  /** An actual read. */
  ActualRead() or
  /**
   * A pseudo read for a `ref` or `out` variable at the end of the variable's enclosing
   * callable. A pseudo read is inserted to make assignments to `out`/`ref` variables
   * live, for example line 1 in
   *
   * ```csharp
   * void M(out int i) {
   *   i = 0;
   * }
   * ```
   */
  OutRefExitRead() or
  /**
   * A pseudo read for a captured variable at the end of the capturing
   * callable. A write to a captured variable needs to be live for the same reasons
   * as a write to a `ref` or `out` variable (see above).
   */
  CapturedVarExitRead() or
  /**
   * A pseudo read for a captured variable via a call.
   */
  CapturedVarCallRead() or
  /**
   * A pseudo read for a `ref` variable, just prior to an update of the referenced value.
   * A pseudo read is inserted to make assignments to the `ref` variable live, for example
   * line 2 in
   *
   * ```csharp
   * void M() {
   *   ref int i = ref GetRef();
   *   i = 0;
   * }
   * ```
   *
   * The pseudo read is inserted at the CFG node `i` on the left-hand side of the
   * assignment on line 3.
   */
  RefReadBeforeWrite()

/** A classification of variable reads. */
class ReadKind extends TReadKind {
  string toString() {
    this = ActualRead() and
    result = "ActualRead"
    or
    this = OutRefExitRead() and
    result = "OutRefExitRead"
    or
    this = CapturedVarExitRead() and
    result = "CapturedVarExitRead"
    or
    this = CapturedVarCallRead() and
    result = "CapturedVarCallRead"
    or
    this = RefReadBeforeWrite() and
    result = "RefReadBeforeWrite"
  }

  /** Holds if this kind represents a pseudo read. */
  predicate isPseudo() { this != ActualRead() }
}

private module SourceVariableImpl {
  private import AssignableDefinitions

  /** A field or a property. */
  class FieldOrProp extends Assignable, Modifiable {
    FieldOrProp() {
      this instanceof Field
      or
      this instanceof Property
    }

    /** Holds if this is a volatile field. */
    predicate isVolatile() { this.(Field).isVolatile() }
  }

  /** An instance field or property. */
  class InstanceFieldOrProp extends FieldOrProp {
    InstanceFieldOrProp() { not this.isStatic() }
  }

  /** An access to a field or a property. */
  class FieldOrPropAccess extends AssignableAccess, QualifiableExpr {
    FieldOrPropAccess() { this.getTarget() instanceof FieldOrProp }
  }

  /** An access to a field or a property that reads the underlying value. */
  class FieldOrPropRead extends FieldOrPropAccess, AssignableRead { }

  /**
   * Holds if `fpa` is an access inside callable `c` of `this`-qualified or
   * static field or property `fp`.
   */
  predicate isPlainFieldOrPropAccess(FieldOrPropAccess fpa, FieldOrProp fp, Callable c) {
    fieldOrPropAccessInCallable(fpa, fp, c) and
    (ownFieldOrPropAccess(fpa) or fp.isStatic())
  }

  /**
   * Holds if `fpa` is an access inside callable `c` of instance field or property
   * `fp` with qualifier `q`.
   */
  predicate isQualifiedFieldOrPropAccess(
    FieldOrPropAccess fpa, InstanceFieldOrProp fp, Callable c, Ssa::SourceVariable q
  ) {
    fieldOrPropAccessInCallable(fpa, fp, c) and
    fpa.getQualifier() = q.getAnAccess()
  }

  /** Holds if `fpa` is an access inside callable `c` of field or property `fp`. */
  private predicate fieldOrPropAccessInCallable(FieldOrPropAccess fpa, FieldOrProp fp, Callable c) {
    fp = fpa.getTarget() and
    c = fpa.getEnclosingCallable()
  }

  /** Holds if `fpa` is an access to an instance field or property of `this`. */
  predicate ownFieldOrPropAccess(FieldOrPropAccess fpa) { fpa.getQualifier() instanceof ThisAccess }

  /**
   * Holds if the `i`th node of basic block `bb` is assignable definition `ad`
   * targeting source variable `v`.
   */
  predicate variableDefinition(
    ControlFlow::BasicBlock bb, int i, Ssa::SourceVariable v, AssignableDefinition ad
  ) {
    ad = v.getADefinition() and
    ad.getAControlFlowNode() = bb.getNode(i) and
    // In cases like `(x, x) = (0, 1)`, we discard the first (dead) definition of `x`
    not exists(TupleAssignmentDefinition first, TupleAssignmentDefinition second | first = ad |
      second.getAssignment() = first.getAssignment() and
      second.getEvaluationOrder() > first.getEvaluationOrder() and
      second = v.getADefinition()
    ) and
    // In cases like `M(out x, out x)`, there is no inherent evaluation order, so we
    // collapse the two definitions of `x`, using the first access as the representative,
    // and expose both definitions in `ExplicitDefinition.getADefinition()`
    not ad = getASameOutRefDefAfter(v, _)
  }

  /**
   * Gets an `out`/`ref` definition of the same source variable as the `out`/`ref`
   * definition `def`, belonging to the same call, at a position after `def`.
   */
  OutRefDefinition getASameOutRefDefAfter(Ssa::SourceVariable v, OutRefDefinition def) {
    def = v.getADefinition() and
    result.getCall() = def.getCall() and
    result.getIndex() > def.getIndex() and
    result = v.getADefinition()
  }

  /**
   * Holds if the `i`th node of basic block `bb` is a (potential) write to source
   * variable `v`. The Boolean `certain` indicates whether the write is certain.
   *
   * This excludes implicit writes via calls.
   */
  predicate variableWriteDirect(
    ControlFlow::BasicBlock bb, int i, Ssa::SourceVariable v, boolean certain
  ) {
    exists(AssignableDefinition ad | variableDefinition(bb, i, v, ad) |
      if any(AssignableDefinition ad0 | ad0 = ad or ad0 = getASameOutRefDefAfter(v, ad)).isCertain()
      then certain = true
      else certain = false
    )
    or
    variableWriteDirect(bb, i, v.(QualifiedFieldOrPropSourceVariable).getQualifier(), certain)
    or
    implicitEntryDefinition(bb, v) and
    i = -1 and
    certain = true
  }

  /**
   * Holds if the `i`th node of basic block `bb` reads source variable `v`.
   * The read is of kind `rk`.
   *
   * This excludes implicit reads via calls.
   */
  predicate variableReadDirect(ControlFlow::BasicBlock bb, int i, Ssa::SourceVariable v, ReadKind rk) {
    v.getAnAccess().(AssignableRead) = bb.getNode(i).getElement() and
    rk = ActualRead()
    or
    outRefExitRead(bb, i, v) and
    rk = OutRefExitRead()
    or
    refReadBeforeWrite(bb, i, v) and
    rk = RefReadBeforeWrite()
  }

  private predicate outRefExitRead(ControlFlow::BasicBlock bb, int i, LocalScopeSourceVariable v) {
    exists(ControlFlow::Nodes::AnnotatedExitNode exit |
      exit.isNormal() and
      exists(LocalScopeVariable lsv |
        lsv = v.getAssignable() and
        bb.getNode(i) = exit and
        exit.getCallable() = lsv.getCallable()
      |
        lsv.(Parameter).isOutOrRef()
        or
        lsv.isRef() and
        strictcount(v.getAnAccess()) > 1
      )
    )
  }

  private predicate refReadBeforeWrite(ControlFlow::BasicBlock bb, int i, LocalScopeSourceVariable v) {
    exists(AssignableDefinitions::AssignmentDefinition def, LocalVariable lv |
      def.getTarget() = lv and
      lv.isRef() and
      lv = v.getAssignable() and
      bb.getNode(i) = def.getAControlFlowNode()
    )
  }

  /**
   * Holds if `fp` is a field or a property that is interesting as a basis for SSA.
   *
   * - A volatile field is never interesting, since all reads must reread from
   *   memory and we are forced to assume that the value can change at any point.
   * - A property is only interesting if it is "field-like", that is, it is a
   *   non-overridable trivial property.
   */
  predicate trackFieldOrProp(FieldOrProp fp) {
    not fp.isVolatile() and
    (
      fp instanceof Field
      or
      fp = any(TrivialProperty p | not p.isOverridableOrImplementable())
    )
  }
}

private import SourceVariableImpl
private import Ssa::SourceVariables

private module CallGraph {
  private import semmle.code.csharp.dispatch.Dispatch

  /**
   * Gets a potential run-time target for the call `c`.
   *
   * This predicate differs from `Call.getARuntimeTarget()` in three ways:
   *
   * (1) The returned callable is always a source declaration,
   *
   * (2) a simpler analysis is applied for delegate calls (needed to avoid making
   *     the SSA library and `Call.getARuntimeTarget()` mutually recursive), and
   *
   * (3) indirect calls to delegates via calls to library callables are included.
   *
   * The Boolean `libraryDelegateCall` indicates whether `c` is a call to a library
   * method and the result is a delegate passed to `c`. For example, in
   *
   * ```csharp
   * Lazy<int> M1()
   * {
   *     return new Lazy<int>(M2);
   * }
   * ```
   *
   * the constructor call `new Lazy<int>(M2)` includes `M2` as a target.
   */
  Callable getARuntimeTarget(Call c, boolean libraryDelegateCall) {
    // Non-delegate call: use dispatch library
    exists(DispatchCall dc | dc.getCall() = c |
      result = dc.getADynamicTarget().getUnboundDeclaration() and
      libraryDelegateCall = false
    )
    or
    // Delegate call: use simple analysis
    result = SimpleDelegateAnalysis::getARuntimeDelegateTarget(c, libraryDelegateCall)
  }

  private module SimpleDelegateAnalysis {
    private import semmle.code.csharp.dataflow.internal.DelegateDataFlow
    private import semmle.code.csharp.dataflow.internal.Steps
    private import semmle.code.csharp.frameworks.system.linq.Expressions

    /**
     * Holds if `c` is a call that (potentially) calls the delegate expression `e`.
     * Either `c` is a delegate call and `e` is the qualifier, or `c` is a call to
     * a library callable and `e` is a delegate argument.
     */
    private predicate delegateCall(Call c, Expr e, boolean libraryDelegateCall) {
      c = any(DelegateCall dc | e = dc.getDelegateExpr()) and
      libraryDelegateCall = false
      or
      c.getTarget().fromLibrary() and
      e = c.getAnArgument() and
      e.getType() instanceof SystemLinqExpressions::DelegateExtType and
      libraryDelegateCall = true
    }

    /** Holds if expression `e` is a delegate creation for callable `c` of type `t`. */
    private predicate delegateCreation(Expr e, Callable c, SystemLinqExpressions::DelegateExtType dt) {
      e =
        any(AnonymousFunctionExpr afe |
          dt = afe.getType() and
          c = afe
        )
      or
      e =
        any(CallableAccess ca |
          c = ca.getTarget().getUnboundDeclaration() and
          dt = ca.getType()
        )
    }

    private predicate delegateFlowStep(Expr pred, Expr succ) {
      Steps::stepClosed(pred, succ)
      or
      exists(Call call, Callable callable |
        callable.getUnboundDeclaration().canReturn(pred) and
        call = succ
      |
        callable = call.getTarget() or
        callable = call.getTarget().(Method).getAnOverrider+() or
        callable = call.getTarget().(Method).getAnUltimateImplementor() or
        callable = getARuntimeDelegateTarget(call, false)
      )
      or
      pred = succ.(DelegateCreation).getArgument()
      or
      exists(AssignableDefinition def, Assignable a |
        a instanceof Field or
        a instanceof Property
      |
        a = def.getTarget() and
        succ.(AssignableRead) = a.getAnAccess() and
        pred = def.getSource()
      )
      or
      exists(AddEventExpr ae | succ.(EventAccess).getTarget() = ae.getTarget() |
        pred = ae.getRValue()
      )
    }

    private predicate reachesDelegateCall(Expr e) {
      delegateCall(_, e, _)
      or
      exists(Expr mid | reachesDelegateCall(mid) | delegateFlowStep(e, mid))
    }

    pragma[nomagic]
    private predicate delegateFlowStepReaches(Expr pred, Expr succ) {
      delegateFlowStep(pred, succ) and
      reachesDelegateCall(succ)
    }

    private Expr delegateCallSource(Callable c) {
      delegateCreation(result, c, _)
      or
      delegateFlowStepReaches(delegateCallSource(c), result)
    }

    /** Gets a run-time target for the delegate call `c`. */
    Callable getARuntimeDelegateTarget(Call c, boolean libraryDelegateCall) {
      delegateCall(c, delegateCallSource(result), libraryDelegateCall)
    }
  }

  /** Holds if `(c1,c2)` is an edge in the call graph. */
  predicate callEdge(Callable c1, Callable c2) {
    exists(Call c | c.getEnclosingCallable() = c1 and c2 = getARuntimeTarget(c, _))
  }
}

private import CallGraph

/**
 * The SSA construction for a field or a property `fp` relies on implicit
 * update nodes at every call site that conceivably could reach an update
 * of the field or property. For example, there is an implicit update of
 * `this.Field` on line 7 in
 *
 * ```csharp
 * int Field;
 *
 * void SetField(int i) { Field = i; }
 *
 * int M() {
 *   Field = 0;
 *   SetField(1); // implicit update of `this.Field`
 *   return Field;
 * }
 * ```
 *
 * At a first approximation, we need to find update paths of the form:
 *
 * ```
 *   Call --(callEdge)-->* Callable(setter of fp)
 * ```
 *
 * This can be improved by excluding paths ending in:
 *
 * ```
 *   Constructor --(intraInstanceCallEdge)-->+ Callable(setter of this.fp)
 * ```
 *
 * as these updates are guaranteed not to alias with the `fp` under
 * consideration.
 *
 * This set of paths can be expressed positively by noting that those
 * that set `this.fp`, end in zero or more `intraInstanceCallEdge`s between
 * callables, and before those is either the originating `Call`:
 *
 * ```
 *   Call --(intraInstanceCallEdge)-->* Callable(setter of this.fp)
 * ```
 *
 * or a `crossInstanceCallEdge`:
 *
 * ```
 *   Call --crossInstanceCallEdge--> Callable
 *        --(intraInstanceCallEdge)-->* Callable(setter of this.fp)
 * ```
 */
private module FieldOrPropsImpl {
  /**
   * A callable that is neither static nor a constructor.
   */
  private class InstanceCallable extends Callable {
    InstanceCallable() {
      not this.(Modifiable).isStatic() and
      not this instanceof Constructor
    }
  }

  private class FieldOrPropDefinition extends AssignableDefinition {
    FieldOrPropDefinition() { this.getTarget() instanceof FieldOrProp }
  }

  /**
   * Holds if `fpdef` is a definition that is not relevant as an implicit
   * SSA update, since it is an initialization and therefore cannot alias.
   */
  private predicate init(FieldOrPropDefinition fpdef) {
    exists(FieldOrPropAccess access | access = fpdef.getTargetAccess() |
      fpdef.getEnclosingCallable() instanceof Constructor and
      ownFieldOrPropAccess(access)
      or
      exists(LocalVariable v |
        v.getAnAccess() = access.getQualifier() and
        not v.isCaptured() and
        forex(AssignableDefinition def | def.getTarget() = v and exists(def.getSource()) |
          def.getSource() instanceof ObjectCreation
        )
      )
    )
    or
    fpdef.(AssignableDefinitions::AssignmentDefinition).getAssignment() instanceof MemberInitializer
  }

  /**
   * Holds if `fpdef` is an update of `fp` in `c` that is relevant for SSA construction.
   */
  private predicate relevantDefinition(Callable c, FieldOrProp fp, FieldOrPropDefinition fpdef) {
    fpdef.getTarget() = fp and
    not init(fpdef) and
    fpdef.getEnclosingCallable() = c and
    exists(FieldOrPropSourceVariable tf | tf.getAssignable() = fp)
  }

  /**
   * Holds if callable `c` can change the value of `this.fp` and is relevant
   * for SSA construction.
   */
  private predicate setsOwnFieldOrProp(InstanceCallable c, FieldOrProp fp) {
    exists(FieldOrPropDefinition fpdef | relevantDefinition(c, fp, fpdef) |
      ownFieldOrPropAccess(fpdef.getTargetAccess())
    )
  }

  /**
   * Holds if callable `c` can change the value of `fp` and is relevant for SSA
   * construction excluding those cases covered by `setsOwnFieldOrProp`.
   */
  private predicate setsOtherFieldOrProp(Callable c, FieldOrProp fp) {
    exists(FieldOrPropDefinition fpdef | relevantDefinition(c, fp, fpdef) |
      not ownFieldOrPropAccess(fpdef.getTargetAccess())
    )
  }

  /**
   * Holds if `(c1,c2)` is a call edge to a callable that does not change the
   * value of `this`.
   *
   * Constructor-to-constructor calls can also be intra-instance, but are not
   * included, as this does not affect whether a call chain ends in
   *
   * ```
   *   Constructor --(intraInstanceCallEdge)-->+ Callable(setter of this.f)
   * ```
   */
  private predicate intraInstanceCallEdge(Callable c1, InstanceCallable c2) {
    exists(Call c |
      c.getEnclosingCallable() = c1 and
      c2 = getARuntimeTarget(c, _) and
      c.(QualifiableExpr).targetIsLocalInstance()
    )
  }

  /**
   * Holds if `(c1,c2)` is an edge in the call graph excluding
   * `intraInstanceCallEdge`.
   */
  private predicate crossInstanceCallEdge(Callable c1, Callable c2) {
    callEdge(c1, c2) and
    not intraInstanceCallEdge(c1, c2)
  }

  pragma[noinline]
  predicate callAt(ControlFlow::BasicBlock bb, int i, Call call) {
    bb.getNode(i) = call.getAControlFlowNode() and
    getARuntimeTarget(call, _).hasBody()
  }

  /**
   * Holds if `call` occurs in basic block `bb` at index `i`, `fp` has
   * an update somewhere, and `fp` is likely to be live in `bb` at index
   * `i`.
   */
  predicate updateCandidate(
    ControlFlow::BasicBlock bb, int i, FieldOrPropSourceVariable fp, Call call
  ) {
    callAt(bb, i, call) and
    call.getEnclosingCallable() = fp.getEnclosingCallable() and
    relevantDefinition(_, fp.getAssignable(), _) and
    not variableWriteDirect(bb, i, fp, _)
  }

  private predicate source(
    Call call, FieldOrPropSourceVariable fps, FieldOrProp fp, Callable c, boolean fresh
  ) {
    updateCandidate(_, _, fps, call) and
    c = getARuntimeTarget(call, _) and
    fp = fps.getAssignable() and
    if c instanceof Constructor then fresh = true else fresh = false
  }

  /**
   * A callable in a potential call-chain between a source that cares about the
   * value of some field `f` and a sink that may overwrite `f`. The Boolean
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
  private predicate source(Call call, FieldOrPropSourceVariable fps, FieldOrProp fp, TCallableNode n) {
    exists(Callable c, boolean fresh |
      source(call, fps, fp, c, fresh) and
      n = MkCallableNode(c, fresh)
    )
  }

  private predicate sink(Callable c, FieldOrProp fp, TCallableNode n) {
    relevantDefinition(c, fp, _) and
    (
      setsOwnFieldOrProp(c, fp) and n = MkCallableNode(c, false)
      or
      setsOtherFieldOrProp(c, fp) and n = MkCallableNode(c, _)
    )
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

  pragma[noopt]
  predicate updatesNamedFieldOrProp(FieldOrPropSourceVariable fps, Call call, Callable setter) {
    exists(TCallableNode src, TCallableNode sink, FieldOrProp fp |
      source(call, fps, fp, src) and
      sink(setter, fp, sink) and
      (src = sink or edgePlus(src, sink))
    )
  }
}

/**
 * As in the SSA construction for fields and properties, SSA construction
 * for captured variables relies on implicit update nodes at every call
 * site that conceivably could reach an update of the captured variable.
 * For example, there is an implicit update of `v` on line 4 in
 *
 * ```csharp
 * int M() {
 *   int i = 0;
 *   Action a = () => { i = 1; };
 *   a(); // implicit update of `v`
 *   return i;
 * }
 * ```
 *
 * We find update paths of the form:
 *
 * ```
 *   Call --(callEdge)-->* Callable(update of v)
 * ```
 *
 * For simplicity, and for performance reasons, we ignore cases where a path
 * goes through the callable that introduces `v`; such a path does not
 * represent an actual update, as a new copy of `v` is updated.
 */
private module CapturedVariableImpl {
  /**
   * A local scope variable that is captured, and updated by at least one capturer.
   */
  private class CapturedWrittenLocalScopeVariable extends LocalScopeVariable {
    CapturedWrittenLocalScopeVariable() {
      exists(AssignableDefinition def | def.getTarget() = this |
        def.getEnclosingCallable() != this.getCallable()
      )
    }
  }

  private class CapturedWrittenLocalScopeSourceVariable extends LocalScopeSourceVariable {
    CapturedWrittenLocalScopeSourceVariable() {
      this.getAssignable() instanceof CapturedWrittenLocalScopeVariable
    }
  }

  private class CapturedWrittenLocalScopeVariableDefinition extends AssignableDefinition {
    CapturedWrittenLocalScopeVariableDefinition() {
      this.getTarget() instanceof CapturedWrittenLocalScopeVariable
    }
  }

  /**
   * Holds if `vdef` is an update of captured variable `v` in callable `c`
   * that is relevant for SSA construction.
   */
  predicate relevantDefinition(
    Callable c, CapturedWrittenLocalScopeVariable v,
    CapturedWrittenLocalScopeVariableDefinition vdef
  ) {
    exists(ControlFlow::BasicBlock bb, int i, CapturedWrittenLocalScopeSourceVariable sv |
      vdef.getTarget() = v and
      vdef.getEnclosingCallable() = c and
      sv.getAssignable() = v and
      bb.getNode(i) = vdef.getAControlFlowNode() and
      c != v.getCallable()
    )
  }

  /**
   * Holds if `call` occurs in basic block `bb` at index `i`, captured variable
   * `v` has an update somewhere, and `v` is likely to be live in `bb` at index
   * `i`.
   */
  predicate updateCandidate(
    ControlFlow::BasicBlock bb, int i, CapturedWrittenLocalScopeSourceVariable v, Call call
  ) {
    FieldOrPropsImpl::callAt(bb, i, call) and
    call.getEnclosingCallable() = v.getEnclosingCallable() and
    exists(Assignable a |
      a = v.getAssignable() and
      relevantDefinition(_, a, _) and
      not exists(AssignableDefinitions::OutRefDefinition def |
        def.getCall() = call and
        def.getTarget() = a
      )
    )
  }

  private predicate source(
    Call call, CapturedWrittenLocalScopeSourceVariable v,
    CapturedWrittenLocalScopeVariable captured, Callable c, boolean libraryDelegateCall
  ) {
    updateCandidate(_, _, v, call) and
    c = getARuntimeTarget(call, libraryDelegateCall) and
    captured = v.getAssignable() and
    relevantDefinition(_, captured, _)
  }

  /**
   * Holds if `c` is a relevant part of the call graph for
   * `updatesCapturedVariable` based on following edges in forward direction.
   */
  private predicate reachbleFromSource(Callable c) {
    source(_, _, _, c, _)
    or
    exists(Callable mid | reachbleFromSource(mid) | callEdge(mid, c))
  }

  private predicate sink(Callable c, CapturedWrittenLocalScopeVariable captured) {
    reachbleFromSource(c) and
    relevantDefinition(c, captured, _)
  }

  private predicate prunedCallable(Callable c) {
    sink(c, _)
    or
    exists(Callable mid | callEdge(c, mid) and prunedCallable(mid))
  }

  private predicate prunedEdge(Callable c1, Callable c2) {
    prunedCallable(c1) and
    prunedCallable(c2) and
    callEdge(c1, c2)
  }

  private predicate edgePlus(Callable c1, Callable c2) = fastTC(prunedEdge/2)(c1, c2)

  /**
   * Holds if `call` may change the value of captured variable `v`. The actual
   * update occurs in `writer`. That is, `writer` can be reached from `call`
   * using zero or more additional calls (as indicated by `additionalCalls`).
   * One of the intermediate callables may be the callable that introduces `v`,
   * in which case `call` is not an actual update.
   */
  pragma[noopt]
  predicate updatesCapturedVariableWriter(
    Call call, CapturedWrittenLocalScopeSourceVariable v, Callable writer, boolean additionalCalls
  ) {
    exists(Callable src, CapturedWrittenLocalScopeVariable captured, boolean libraryDelegateCall |
      source(call, v, captured, src, libraryDelegateCall) and
      sink(writer, captured) and
      (
        src = writer and additionalCalls = libraryDelegateCall
        or
        edgePlus(src, writer) and additionalCalls = true
      )
    )
  }
}

/**
 * Holds if the `i`th node of basic block `bb` is a (potential) write to source
 * variable `v`. The Boolean `certain` indicates whether the write is certain.
 *
 * This includes implicit writes via calls.
 */
predicate variableWrite(ControlFlow::BasicBlock bb, int i, Ssa::SourceVariable v, boolean certain) {
  variableWriteDirect(bb, i, v, certain)
  or
  variableWriteQualifier(bb, i, v, certain)
  or
  updatesNamedFieldOrProp(bb, i, _, v, _) and
  certain = false
  or
  updatesCapturedVariable(bb, i, _, v, _, _) and
  certain = false
}

/**
 * Liveness analysis to restrict the size of the SSA representation for
 * captured variables.
 *
 * Example:
 *
 * ```csharp
 * void M() {
 *   int i = 0;
 *   void M2() {
 *     System.Console.WriteLine(i);
 *   }
 *   M2();
 * }
 * ```
 *
 * The definition of `i` on line 2 is live, because of the call to `M2` on
 * line 6. However, that call is not a direct read of `i`, so we account
 * for that by inserting an implicit read of `i` on line 6.
 *
 * The predicates in this module follow the same structure as those in
 * `CapturedVariableImpl`.
 */
private module CapturedVariableLivenessImpl {
  /**
   * Holds if `c` is a callable that captures local scope variable `v`, and
   * `c` may read the value of the captured variable.
   */
  private predicate capturerReads(Callable c, LocalScopeVariable v) {
    exists(LocalScopeSourceVariable sv |
      variableReadDirect(_, _, sv, _) and
      c = sv.getEnclosingCallable() and
      v = sv.getAssignable() and
      v.getCallable() != c
    )
  }

  /**
   * A local scope variable that is captured, and read by at least one capturer.
   */
  private class CapturedReadLocalScopeVariable extends LocalScopeVariable {
    CapturedReadLocalScopeVariable() { capturerReads(_, this) }
  }

  private class CapturedReadLocalScopeSourceVariable extends LocalScopeSourceVariable {
    CapturedReadLocalScopeSourceVariable() {
      this.getAssignable() instanceof CapturedReadLocalScopeVariable
    }
  }

  /**
   * Holds if a write to captured source variable `v` may be read by a
   * callable reachable from the call `c`.
   */
  private predicate implicitReadCandidate(
    CapturedReadLocalScopeSourceVariable v, ControlFlow::Nodes::ElementNode c
  ) {
    exists(ControlFlow::BasicBlock bb, int i | variableWriteDirect(bb, i, v, _) |
      c = bb.getNode(any(int j | j > i))
      or
      c = bb.getASuccessor+().getANode()
    )
  }

  private predicate source(
    ControlFlow::Nodes::ElementNode call, CapturedReadLocalScopeSourceVariable v,
    CapturedReadLocalScopeVariable captured, Callable c, boolean libraryDelegateCall
  ) {
    implicitReadCandidate(v, call) and
    c = getARuntimeTarget(call.getElement(), libraryDelegateCall) and
    captured = v.getAssignable() and
    capturerReads(_, captured)
  }

  /**
   * Holds if `c` is a relevant part of the call graph for
   * `readsCapturedVariable` based on following edges in forward direction.
   */
  private predicate reachbleFromSource(Callable c) {
    source(_, _, _, c, _)
    or
    exists(Callable mid | reachbleFromSource(mid) | callEdge(mid, c))
  }

  private predicate sink(Callable c, CapturedReadLocalScopeVariable captured) {
    reachbleFromSource(c) and
    capturerReads(c, captured)
  }

  private predicate prunedCallable(Callable c) {
    sink(c, _)
    or
    exists(Callable mid | callEdge(c, mid) and prunedCallable(mid))
  }

  private predicate prunedEdge(Callable c1, Callable c2) {
    prunedCallable(c1) and
    prunedCallable(c2) and
    callEdge(c1, c2)
  }

  private predicate edgePlus(Callable c1, Callable c2) = fastTC(prunedEdge/2)(c1, c2)

  /**
   * Holds if `call` may read the value of captured variable `v`. The actual
   * read occurs in `reader`. That is, `reader` can be reached from `call`
   * using zero or more additional calls (as indicated by `additionalCalls`).
   * One of the intermediate callables may be a callable that writes to `v`,
   * in which case `call` is not an actual read.
   */
  pragma[noopt]
  private predicate readsCapturedVariable(
    ControlFlow::Nodes::ElementNode call, CapturedReadLocalScopeSourceVariable v, Callable reader,
    boolean additionalCalls
  ) {
    exists(Callable src, CapturedReadLocalScopeVariable captured, boolean libraryDelegateCall |
      source(call, v, captured, src, libraryDelegateCall) and
      sink(reader, captured) and
      (
        src = reader and additionalCalls = libraryDelegateCall
        or
        edgePlus(src, reader) and additionalCalls = true
      )
    )
  }

  /**
   * Holds if captured local scope variable `v` is written inside the callable
   * to which `bb` belongs, and the value may be read via `call` using zero or
   * more additional calls (as indicated by `additionalCalls`).
   *
   * In this case a pseudo-read is inserted at the exit node at index `i` in `bb`,
   * in order to make the write live.
   *
   * Example:
   *
   * ```csharp
   * class C {
   *   void M1() {
   *     int i = 0;
   *     void M2() { i = 2; };
   *     M2();
   *     System.Console.WriteLine(i);
   *   }
   * }
   * ```
   *
   * The write to `i` inside `M2` on line 4 is live because of the implicit call
   * definition on line 5.
   */
  predicate capturedReadOut(
    ControlFlow::BasicBlock bb, int i, LocalScopeSourceVariable v, LocalScopeSourceVariable outer,
    Call call, boolean additionalCalls
  ) {
    exists(
      ControlFlow::Nodes::AnnotatedExitNode exit, ControlFlow::BasicBlock pred,
      AssignableDefinition adef
    |
      exit.isNormal() and
      variableDefinition(pred, _, v, adef) and
      updatesCapturedVariable(_, _, call, outer, adef, additionalCalls) and
      pred.getASuccessor*() = bb and
      exit = bb.getNode(i)
    )
  }

  /**
   * Holds if a value written to captured local scope variable `outer` may be
   * read as `inner` via `call`, at index `i` in basic block `bb`, using one or
   * more calls (as indicated by `additionalCalls`).
   *
   * Example:
   *
   * ```csharp
   * class C {
   *   void M1() {
   *     int i = 0;
   *     void M2() => System.Console.WriteLine(i);
   *     i = 1;
   *     M2();
   *   }
   * }
   * ```
   *
   * The write to `i` on line 5 is live because of the call to `M2` on line 6, which
   * reaches the entry definition for `i` in `M2` on line 4.
   */
  predicate capturedReadIn(
    ControlFlow::BasicBlock bb, int i, LocalScopeSourceVariable outer,
    LocalScopeSourceVariable inner, ControlFlow::Nodes::ElementNode call, boolean additionalCalls
  ) {
    exists(Callable reader |
      implicitReadCandidate(outer, call) and
      readsCapturedVariable(call, outer, reader, additionalCalls) and
      reader = inner.getEnclosingCallable() and
      outer.getAssignable() = inner.getAssignable() and
      call = bb.getNode(i)
    )
  }
}

private import CapturedVariableLivenessImpl

/**
 * Holds if the `i`th of basic block `bb` reads source variable `v`.
 * The read is of kind `rk`.
 *
 * This includes implicit reads via calls.
 */
predicate variableRead(ControlFlow::BasicBlock bb, int i, Ssa::SourceVariable v, ReadKind rk) {
  variableReadDirect(bb, i, v, rk)
  or
  capturedReadOut(bb, i, v, _, _, _) and
  rk = CapturedVarExitRead()
  or
  capturedReadIn(bb, i, v, _, _, _) and
  rk = CapturedVarCallRead()
}

cached
private module Cached {
  cached
  newtype TSourceVariable =
    TLocalVar(Callable c, LocalScopeVariable v) {
      c = v.getCallable()
      or
      // Local scope variables can be captured
      c = v.getAnAccess().getEnclosingCallable()
    } or
    TPlainFieldOrProp(Callable c, FieldOrProp f) {
      exists(FieldOrPropRead fr | isPlainFieldOrPropAccess(fr, f, c)) and
      trackFieldOrProp(f)
    } or
    TQualifiedFieldOrProp(Callable c, Ssa::SourceVariable q, InstanceFieldOrProp f) {
      exists(FieldOrPropRead fr | isQualifiedFieldOrPropAccess(fr, f, c, q)) and
      trackFieldOrProp(f)
    }

  /** Gets an access to source variable `v`. */
  cached
  AssignableAccess getAnAccess(Ssa::SourceVariable v) {
    exists(Callable c |
      exists(LocalScopeVariable lsv | v = TLocalVar(c, lsv) |
        result = lsv.getAnAccess() and
        result.getEnclosingCallable() = c
      )
      or
      exists(FieldOrProp fp | v = TPlainFieldOrProp(c, fp) |
        isPlainFieldOrPropAccess(result, fp, c)
      )
      or
      exists(FieldOrProp fp, Ssa::SourceVariable q | v = TQualifiedFieldOrProp(c, q, fp) |
        isQualifiedFieldOrPropAccess(result, fp, c, q)
      )
    )
  }

  cached
  predicate implicitEntryDefinition(
    ControlFlow::ControlFlow::BasicBlocks::EntryBlock bb, Ssa::SourceVariable v
  ) {
    exists(Callable c |
      c = bb.getCallable() and
      c = v.getEnclosingCallable()
    |
      // Captured variable
      exists(LocalScopeVariable lsv |
        v = any(LocalScopeSourceVariable lv | lsv = lv.getAssignable())
      |
        lsv.getCallable() != c
      )
      or
      // Each tracked field and property has an implicit entry definition
      v instanceof PlainFieldOrPropSourceVariable
    )
  }

  cached
  AssignableDefinition getADefinition(Ssa::ExplicitDefinition def) {
    exists(Ssa::SourceVariable v, AssignableDefinition ad | explicitDefinition(def, v, ad) |
      result = ad or
      result = getASameOutRefDefAfter(v, ad)
    )
  }

  /**
   * Holds if `call` may change the value of field or property `fp`. The actual
   * update occurs in `setter`.
   */
  cached
  predicate updatesNamedFieldOrProp(
    ControlFlow::BasicBlock bb, int i, Call c, FieldOrPropSourceVariable fp, Callable setter
  ) {
    FieldOrPropsImpl::updateCandidate(bb, i, fp, c) and
    FieldOrPropsImpl::updatesNamedFieldOrProp(fp, c, setter)
  }

  /**
   * Holds if `call` may change the value of captured variable `v`. The actual
   * update occurs in `def`.
   */
  cached
  predicate updatesCapturedVariable(
    ControlFlow::BasicBlock bb, int i, Call call, LocalScopeSourceVariable v,
    AssignableDefinition def, boolean additionalCalls
  ) {
    CapturedVariableImpl::updateCandidate(bb, i, v, call) and
    exists(Callable writer |
      CapturedVariableImpl::relevantDefinition(writer, v.getAssignable(), def)
    |
      CapturedVariableImpl::updatesCapturedVariableWriter(call, v, writer, additionalCalls)
    )
  }

  cached
  predicate variableWriteQualifier(
    ControlFlow::BasicBlock bb, int i, QualifiedFieldOrPropSourceVariable v, boolean certain
  ) {
    variableWrite(bb, i, v.getQualifier(), certain) and
    // Eliminate corner case where a call definition can overlap with a
    // qualifier definition: if method `M` updates field `F`, then a call
    // to `M` is both an update of `x.M` and `x.M.M`, so the former call
    // definition should not give rise to an implicit qualifier definition
    // for `x.M.M`.
    not updatesNamedFieldOrProp(bb, i, _, v, _)
  }

  cached
  predicate isCapturedVariableDefinitionFlowIn(
    Ssa::ExplicitDefinition def, Ssa::ImplicitEntryDefinition edef,
    ControlFlow::Nodes::ElementNode c, boolean additionalCalls
  ) {
    exists(Definition def0, ControlFlow::BasicBlock bb, int i |
      capturedReadIn(_, _, def.getSourceVariable(), edef.getSourceVariable(), c, additionalCalls) and
      def = def0.getAnUltimateDefinition() and
      ssaDefReachesRead(_, def0, bb, i, CapturedVarCallRead()) and
      c = bb.getNode(i)
    )
  }

  cached
  predicate isCapturedVariableDefinitionFlowOut(
    Ssa::ExplicitDefinition def, Ssa::ImplicitCallDefinition cdef, boolean additionalCalls
  ) {
    exists(Ssa::Definition def0, ControlFlow::BasicBlock bb, int i |
      def = def0.getAnUltimateDefinition() and
      lastRef(def0, bb, i) and
      capturedReadOut(bb, i, def0.getSourceVariable(), cdef.getSourceVariable(), cdef.getCall(),
        additionalCalls)
    )
  }

  cached
  predicate explicitDefinition(WriteDefinition def, Ssa::SourceVariable v, AssignableDefinition ad) {
    exists(ControlFlow::BasicBlock bb, int i |
      def.definesAt(v, bb, i) and
      variableDefinition(bb, i, v, ad)
    )
  }

  private predicate adjacentDefReaches(
    Definition def, ControlFlow::BasicBlock bb1, int i1, ControlFlow::BasicBlock bb2, int i2
  ) {
    adjacentDefRead(def, bb1, i1, bb2, i2)
    or
    exists(ControlFlow::BasicBlock bb3, int i3 |
      adjacentDefReaches(def, bb1, i1, bb3, i3) and
      variableRead(bb3, i3, _, any(ReadKind rk | rk.isPseudo())) and
      adjacentDefRead(def, bb3, i3, bb2, i2)
    )
  }

  pragma[noinline]
  private predicate adjacentDefActualRead(
    Definition def, ControlFlow::BasicBlock bb1, int i1, ControlFlow::BasicBlock bb2, int i2
  ) {
    adjacentDefReaches(def, bb1, i1, bb2, i2) and
    variableRead(bb2, i2, _, ActualRead())
  }

  /**
   * Holds if the value defined at SSA definition `def` can reach a read at `cfn`,
   * without passing through any other read.
   */
  cached
  predicate firstReadSameVar(Definition def, ControlFlow::Node cfn) {
    exists(ControlFlow::BasicBlock bb1, int i1, ControlFlow::BasicBlock bb2, int i2 |
      def.definesAt(_, bb1, i1) and
      adjacentDefActualRead(def, bb1, i1, bb2, i2) and
      cfn = bb2.getNode(i2)
    )
  }

  /**
   * Holds if the read at `cfn2` is a read of the same SSA definition `def`
   * as the read at `cfn1`, and `cfn2` can be reached from `cfn1` without
   * passing through another read.
   */
  cached
  predicate adjacentReadPairSameVar(Definition def, ControlFlow::Node cfn1, ControlFlow::Node cfn2) {
    exists(ControlFlow::BasicBlock bb1, int i1, ControlFlow::BasicBlock bb2, int i2 |
      cfn1 = bb1.getNode(i1) and
      variableRead(bb1, i1, _, ActualRead()) and
      adjacentDefActualRead(def, bb1, i1, bb2, i2) and
      cfn2 = bb2.getNode(i2)
    )
  }

  private predicate adjacentDefPseudoRead(
    Definition def, ControlFlow::BasicBlock bb1, int i1, ControlFlow::BasicBlock bb2, int i2
  ) {
    adjacentDefReaches(def, bb1, i1, bb2, i2) and
    variableRead(bb2, i2, _, any(ReadKind rk | rk.isPseudo()))
  }

  private predicate reachesLastRef(Definition def, ControlFlow::BasicBlock bb, int i) {
    lastRef(def, bb, i)
    or
    exists(ControlFlow::BasicBlock bb0, int i0 |
      reachesLastRef(def, bb0, i0) and
      variableRead(bb0, i0, _, any(ReadKind rk | rk.isPseudo())) and
      adjacentDefPseudoRead(def, bb, i, bb0, i0)
    )
  }

  cached
  predicate lastReadSameVar(Definition def, ControlFlow::Node cfn) {
    exists(ControlFlow::BasicBlock bb, int i |
      reachesLastRef(def, bb, i) and
      variableRead(bb, i, _, ActualRead()) and
      cfn = bb.getNode(i)
    )
  }

  cached
  predicate isLiveOutRefParameterDefinition(Ssa::Definition def, Parameter p) {
    p.isOutOrRef() and
    exists(Ssa::Definition def0, ControlFlow::BasicBlock bb, int i |
      def = def0.getAnUltimateDefinition() and
      reachesLastRef(def0, bb, i) and
      variableRead(bb, i, def0.getSourceVariable(), OutRefExitRead()) and
      p = def0.getSourceVariable().getAssignable()
    )
  }
}

import Cached

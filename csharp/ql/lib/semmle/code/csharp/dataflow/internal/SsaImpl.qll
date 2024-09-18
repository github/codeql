/**
 * Provides classes for working with static single assignment (SSA) form.
 */

import csharp
private import codeql.ssa.Ssa as SsaImplCommon
private import AssignableDefinitions
private import semmle.code.csharp.controlflow.internal.PreSsa
private import semmle.code.csharp.controlflow.Guards as Guards

private module SsaInput implements SsaImplCommon::InputSig<Location> {
  class BasicBlock = ControlFlow::BasicBlock;

  class ControlFlowNode = ControlFlow::Node;

  BasicBlock getImmediateBasicBlockDominator(BasicBlock bb) { result = bb.getImmediateDominator() }

  BasicBlock getABasicBlockSuccessor(BasicBlock bb) { result = bb.getASuccessor() }

  class ExitBasicBlock extends BasicBlock, ControlFlow::BasicBlocks::ExitBlock { }

  class SourceVariable = Ssa::SourceVariable;

  /**
   * Holds if the `i`th node of basic block `bb` is a (potential) write to source
   * variable `v`. The Boolean `certain` indicates whether the write is certain.
   *
   * This includes implicit writes via calls.
   */
  predicate variableWrite(BasicBlock bb, int i, Ssa::SourceVariable v, boolean certain) {
    variableWriteDirect(bb, i, v, certain)
    or
    variableWriteQualifier(bb, i, v, certain)
    or
    updatesNamedFieldOrProp(bb, i, _, v, _) and
    certain = false
  }

  /**
   * Holds if the `i`th of basic block `bb` reads source variable `v`.
   *
   * This includes implicit reads via calls.
   */
  predicate variableRead(BasicBlock bb, int i, Ssa::SourceVariable v, boolean certain) {
    variableReadActual(bb, i, v) and
    certain = true
    or
    variableReadPseudo(bb, i, v) and
    certain = false
  }
}

import SsaImplCommon::Make<Location, SsaInput> as Impl

class Definition = Impl::Definition;

class WriteDefinition = Impl::WriteDefinition;

class UncertainWriteDefinition = Impl::UncertainWriteDefinition;

class PhiNode = Impl::PhiNode;

module Consistency = Impl::Consistency;

module ExposedForTestingOnly {
  predicate ssaDefReachesReadExt = Impl::ssaDefReachesReadExt/4;

  predicate phiHasInputFromBlockExt = Impl::phiHasInputFromBlockExt/3;
}

/**
 * Holds if the `i`th node of basic block `bb` reads source variable `v`.
 */
private predicate variableReadActual(ControlFlow::BasicBlock bb, int i, Ssa::SourceVariable v) {
  v.getAnAccess().(AssignableRead) = bb.getNode(i).getAstNode()
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
    (
      ownFieldOrPropAccess(fpa)
      or
      fp.isStatic() and not fp instanceof EnumConstant
    )
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
    ad.getExpr().getAControlFlowNode() = bb.getNode(i) and
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
   * Holds if a pseudo read for `ref` or `out` variable `v` happens at index `i`
   * in basic block `bb`. A pseudo read is inserted to make assignments to
   * `out`/`ref` variables live, for example line 1 in
   *
   * ```csharp
   * void M(out int i) {
   *   i = 0;
   * }
   * ```
   */
  predicate outRefExitRead(ControlFlow::BasicBlock bb, int i, LocalScopeSourceVariable v) {
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

  /**
   * Holds if a pseudo read for `ref` variable `v` happens at index `i` in basic
   * block `bb`, just prior to an update of the referenced value. A pseudo read
   * is inserted to make assignments to the `ref` variable live, for example
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
  predicate refReadBeforeWrite(ControlFlow::BasicBlock bb, int i, LocalScopeSourceVariable v) {
    exists(AssignableDefinitions::AssignmentDefinition def, LocalVariable lv |
      def.getTarget() = lv and
      lv.isRef() and
      lv = v.getAssignable() and
      bb.getNode(i) = def.getExpr().getAControlFlowNode() and
      not def.getAssignment() instanceof LocalVariableDeclAndInitExpr
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
    private import semmle.code.csharp.dataflow.internal.Steps
    private import semmle.code.csharp.frameworks.system.linq.Expressions

    /**
     * Holds if `c` is a call that (potentially) calls the delegate expression `e`.
     * Either `c` is a delegate call and `e` is the qualifier, or `c` is a call to
     * a library callable and `e` is a delegate argument.
     */
    private predicate delegateCall(Call c, Expr e, boolean libraryDelegateCall) {
      c = any(DelegateCall dc | e = dc.getExpr()) and
      libraryDelegateCall = false
      or
      exists(Callable target |
        target = c.getTarget() and
        not target.hasBody()
      |
        if target instanceof Accessor then not target.fromSource() else any()
      ) and
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

    /**
     * A simple flow step that does not take flow through fields or flow out
     * of callables into account.
     */
    pragma[nomagic]
    private predicate delegateFlowStep(Expr pred, Expr succ) {
      Steps::stepClosed(pred, succ)
      or
      pred = succ.(DelegateCreation).getArgument()
      or
      exists(AddEventExpr ae | succ.(EventAccess).getTarget() = ae.getTarget() |
        pred = ae.getRValue()
      )
    }

    private predicate delegateCreationReaches(Callable c, Expr e) {
      delegateCreation(e, c, _)
      or
      exists(Expr mid |
        delegateCreationReaches(c, mid) and
        delegateFlowStep(mid, e)
      )
    }

    private predicate reachesDelegateCall(Expr e, Call c, boolean libraryDelegateCall) {
      delegateCall(c, e, libraryDelegateCall)
      or
      exists(Expr mid |
        reachesDelegateCall(mid, c, libraryDelegateCall) and
        delegateFlowStep(e, mid)
      )
    }

    /**
     * A "busy" flow element, that is, a node in the data-flow graph that typically
     * has a large fan-in or a large fan-out (or both).
     *
     * For such busy elements, we do not track flow directly from all delegate
     * creations, but instead we first perform a flow analysis between busy elements,
     * and then only in the end join up with delegate creations and delegate calls.
     */
    abstract private class BusyFlowElement extends Element {
      pragma[nomagic]
      abstract Expr getAnInput();

      pragma[nomagic]
      abstract Expr getAnOutput();

      /** Holds if this element can be reached from expression `e`. */
      pragma[nomagic]
      private predicate exprReaches(Expr e) {
        this.reachesCall(_) and
        e = this.getAnInput()
        or
        exists(Expr mid |
          this.exprReaches(mid) and
          delegateFlowStep(e, mid)
        )
      }

      /**
       * Holds if this element can reach a delegate call `c` directly without
       * passing through another busy element.
       */
      pragma[nomagic]
      predicate delegateCall(Call c, boolean libraryDelegateCall) {
        reachesDelegateCall(this.getAnOutput(), c, libraryDelegateCall)
      }

      pragma[nomagic]
      private BusyFlowElement getASuccessor() { result.exprReaches(this.getAnOutput()) }

      /**
       * Holds if this element reaches another busy element `other`,
       * which can reach a delegate call directly without passing
       * through another busy element.
       */
      pragma[nomagic]
      private predicate reachesCall(BusyFlowElement other) {
        this = other and
        other.delegateCall(_, _)
        or
        this.getASuccessor().reachesCall(other)
      }

      /** Holds if this element is reached by a delegate creation for `c`. */
      pragma[nomagic]
      predicate isReachedBy(Callable c) {
        exists(BusyFlowElement pred |
          pred.reachesCall(this) and
          delegateCreationReaches(c, pred.getAnInput())
        )
      }
    }

    private class TFieldOrProperty = @field or @property;

    private class FieldOrPropertyFlow extends BusyFlowElement, Assignable, TFieldOrProperty {
      final override Expr getAnInput() {
        exists(Assignable target |
          target = this.getUnboundDeclaration() and
          result = target.getAnAssignedValue()
        )
      }

      final override AssignableRead getAnOutput() {
        exists(Assignable target |
          target = this.getUnboundDeclaration() and
          result = target.getAnAccess()
        )
      }
    }

    private class CallOutputFlow extends BusyFlowElement, Callable {
      final override Expr getAnInput() { this.canReturn(result) }

      final override Call getAnOutput() {
        exists(Callable target | this = target.getUnboundDeclaration() |
          target = result.getTarget() or
          target = result.getTarget().(Method).getAnOverrider+() or
          target = result.getTarget().(Method).getAnUltimateImplementor() or
          target = getARuntimeDelegateTarget(result, false)
        )
      }
    }

    /** Gets a run-time target for the delegate call `c`. */
    pragma[nomagic]
    Callable getARuntimeDelegateTarget(Call c, boolean libraryDelegateCall) {
      // directly resolvable without going through a "busy" element
      exists(Expr e |
        delegateCreationReaches(result, e) and
        delegateCall(c, e, libraryDelegateCall)
      )
      or
      // resolvable by going through one or more "busy" elements
      exists(BusyFlowElement busy |
        busy.isReachedBy(result) and
        busy.delegateCall(c, libraryDelegateCall)
      )
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

private predicate variableReadPseudo(ControlFlow::BasicBlock bb, int i, Ssa::SourceVariable v) {
  outRefExitRead(bb, i, v)
  or
  refReadBeforeWrite(bb, i, v)
}

pragma[noinline]
private predicate adjacentDefRead(
  Definition def, SsaInput::BasicBlock bb1, int i1, SsaInput::BasicBlock bb2, int i2,
  SsaInput::SourceVariable v
) {
  Impl::adjacentDefRead(def, bb1, i1, bb2, i2) and
  v = def.getSourceVariable()
}

private predicate adjacentDefReachesRead(
  Definition def, SsaInput::SourceVariable v, SsaInput::BasicBlock bb1, int i1,
  SsaInput::BasicBlock bb2, int i2
) {
  adjacentDefRead(def, bb1, i1, bb2, i2, v) and
  (
    def.definesAt(v, bb1, i1)
    or
    SsaInput::variableRead(bb1, i1, v, true)
  )
  or
  exists(SsaInput::BasicBlock bb3, int i3 |
    adjacentDefReachesRead(def, v, bb1, i1, bb3, i3) and
    SsaInput::variableRead(bb3, i3, _, false) and
    Impl::adjacentDefRead(def, bb3, i3, bb2, i2)
  )
}

/** Same as `adjacentDefRead`, but skips uncertain reads. */
pragma[nomagic]
private predicate adjacentDefSkipUncertainReads(
  Definition def, SsaInput::BasicBlock bb1, int i1, SsaInput::BasicBlock bb2, int i2
) {
  exists(SsaInput::SourceVariable v |
    adjacentDefReachesRead(def, v, bb1, i1, bb2, i2) and
    SsaInput::variableRead(bb2, i2, v, true)
  )
}

private predicate adjacentDefReachesUncertainRead(
  Definition def, SsaInput::BasicBlock bb1, int i1, SsaInput::BasicBlock bb2, int i2
) {
  exists(SsaInput::SourceVariable v |
    adjacentDefReachesRead(def, v, bb1, i1, bb2, i2) and
    SsaInput::variableRead(bb2, i2, v, false)
  )
}

/** Same as `lastRefRedef`, but skips uncertain reads. */
pragma[nomagic]
private predicate lastRefSkipUncertainReads(Definition def, SsaInput::BasicBlock bb, int i) {
  Impl::lastRef(def, bb, i) and
  not SsaInput::variableRead(bb, i, def.getSourceVariable(), false)
  or
  exists(SsaInput::BasicBlock bb0, int i0 |
    Impl::lastRef(def, bb0, i0) and
    adjacentDefReachesUncertainRead(def, bb, i, bb0, i0)
  )
}

cached
private module Cached {
  cached
  newtype TSourceVariable =
    TLocalVar(Callable c, PreSsa::SimpleLocalScopeVariable v) {
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
  predicate implicitEntryDefinition(ControlFlow::ControlFlow::BasicBlock bb, Ssa::SourceVariable v) {
    exists(ControlFlow::ControlFlow::BasicBlocks::EntryBlock entry, Callable c |
      c = entry.getCallable() and
      // In case `c` has multiple bodies, we want each body to get its own implicit
      // entry definition. In case `c` doesn't have multiple bodies, the line below
      // is simply the same as `bb = entry`, because `entry.getFirstNode().getASuccessor()`
      // will be in the entry block.
      bb = entry.getFirstNode().getASuccessor().getBasicBlock() and
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
      or
      v.getAssignable() instanceof Parameter
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

  cached
  predicate variableWriteQualifier(
    ControlFlow::BasicBlock bb, int i, QualifiedFieldOrPropSourceVariable v, boolean certain
  ) {
    SsaInput::variableWrite(bb, i, v.getQualifier(), certain) and
    // Eliminate corner case where a call definition can overlap with a
    // qualifier definition: if method `M` updates field `F`, then a call
    // to `M` is both an update of `x.M` and `x.M.M`, so the former call
    // definition should not give rise to an implicit qualifier definition
    // for `x.M.M`.
    not updatesNamedFieldOrProp(bb, i, _, v, _)
  }

  cached
  predicate explicitDefinition(WriteDefinition def, Ssa::SourceVariable v, AssignableDefinition ad) {
    exists(ControlFlow::BasicBlock bb, int i |
      def.definesAt(v, bb, i) and
      variableDefinition(bb, i, v, ad)
    )
  }

  cached
  predicate isLiveAtEndOfBlock(Definition def, ControlFlow::BasicBlock bb) {
    Impl::ssaDefReachesEndOfBlock(bb, def, _)
  }

  cached
  Definition phiHasInputFromBlock(Ssa::PhiNode phi, ControlFlow::BasicBlock bb) {
    Impl::phiHasInputFromBlock(phi, result, bb)
  }

  cached
  AssignableRead getAReadAtNode(Definition def, ControlFlow::Node cfn) {
    exists(Ssa::SourceVariable v, ControlFlow::BasicBlock bb, int i |
      Impl::ssaDefReachesRead(v, def, bb, i) and
      variableReadActual(bb, i, v) and
      cfn = bb.getNode(i) and
      result.getAControlFlowNode() = cfn
    )
  }

  /**
   * Holds if the value defined at SSA definition `def` can reach a read at `cfn`,
   * without passing through any other read.
   */
  cached
  predicate firstReadSameVar(Definition def, ControlFlow::Node cfn) {
    exists(ControlFlow::BasicBlock bb1, int i1, ControlFlow::BasicBlock bb2, int i2 |
      def.definesAt(_, bb1, i1) and
      adjacentDefSkipUncertainReads(def, bb1, i1, bb2, i2) and
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
      variableReadActual(bb1, i1, _) and
      adjacentDefSkipUncertainReads(def, bb1, i1, bb2, i2) and
      cfn2 = bb2.getNode(i2)
    )
  }

  cached
  predicate lastRefBeforeRedef(Definition def, ControlFlow::BasicBlock bb, int i, Definition next) {
    Impl::lastRefRedef(def, bb, i, next) and
    not SsaInput::variableRead(bb, i, def.getSourceVariable(), false)
    or
    exists(SsaInput::BasicBlock bb0, int i0 |
      Impl::lastRefRedef(def, bb0, i0, next) and
      adjacentDefReachesUncertainRead(def, bb, i, bb0, i0)
    )
  }

  cached
  predicate lastReadSameVar(Definition def, ControlFlow::Node cfn) {
    exists(ControlFlow::BasicBlock bb, int i |
      lastRefSkipUncertainReads(def, bb, i) and
      variableReadActual(bb, i, _) and
      cfn = bb.getNode(i)
    )
  }

  cached
  Definition uncertainWriteDefinitionInput(UncertainWriteDefinition def) {
    Impl::uncertainWriteDefinitionInput(def, result)
  }

  cached
  predicate isLiveOutRefParameterDefinition(Ssa::Definition def, Parameter p) {
    p.isOutOrRef() and
    exists(Ssa::SourceVariable v, Ssa::Definition def0, ControlFlow::BasicBlock bb, int i |
      v = def.getSourceVariable() and
      p = v.getAssignable() and
      def = def0.getAnUltimateDefinition() and
      Impl::ssaDefReachesRead(_, def0, bb, i) and
      outRefExitRead(bb, i, v)
    )
  }

  cached
  module DataFlowIntegration {
    import DataFlowIntegrationImpl

    cached
    predicate localFlowStep(DefinitionExt def, Node nodeFrom, Node nodeTo, boolean isUseStep) {
      DataFlowIntegrationImpl::localFlowStep(def, nodeFrom, nodeTo, isUseStep)
    }

    cached
    predicate localMustFlowStep(DefinitionExt def, Node nodeFrom, Node nodeTo) {
      DataFlowIntegrationImpl::localMustFlowStep(def, nodeFrom, nodeTo)
    }

    signature predicate guardChecksSig(Guards::Guard g, Expr e, Guards::AbstractValue v);

    cached // nothing is actually cached
    module BarrierGuard<guardChecksSig/3 guardChecks> {
      private predicate guardChecksAdjTypes(
        DataFlowIntegrationInput::Guard g, DataFlowIntegrationInput::Expr e, boolean branch
      ) {
        exists(Guards::AbstractValues::BooleanValue v |
          guardChecks(g, e.getAstNode(), v) and
          branch = v.getValue()
        )
      }

      private Node getABarrierNodeImpl() {
        result = DataFlowIntegrationImpl::BarrierGuard<guardChecksAdjTypes/3>::getABarrierNode()
      }

      predicate getABarrierNode = getABarrierNodeImpl/0;
    }
  }
}

import Cached

private string getSplitString(DefinitionExt def) {
  exists(ControlFlow::BasicBlock bb, int i, ControlFlow::Node cfn |
    def.definesAt(_, bb, i, _) and
    result = cfn.(ControlFlow::Nodes::ElementNode).getSplitsString()
  |
    cfn = bb.getNode(i)
    or
    not exists(bb.getNode(i)) and
    cfn = bb.getFirstNode()
  )
}

string getToStringPrefix(DefinitionExt def) {
  result = "[" + getSplitString(def) + "] "
  or
  not exists(getSplitString(def)) and
  result = ""
}

/**
 * An extended static single assignment (SSA) definition.
 *
 * This is either a normal SSA definition (`Definition`) or a
 * phi-read node (`PhiReadNode`).
 *
 * Only intended for internal use.
 */
class DefinitionExt extends Impl::DefinitionExt {
  override string toString() { result = this.(Ssa::Definition).toString() }

  /** Gets the location of this definition. */
  override Location getLocation() { result = this.(Ssa::Definition).getLocation() }

  /** Gets the enclosing callable of this definition. */
  Callable getEnclosingCallable() { result = this.(Ssa::Definition).getEnclosingCallable() }
}

/**
 * A phi-read node.
 *
 * Only intended for internal use.
 */
class PhiReadNode extends DefinitionExt, Impl::PhiReadNode {
  override string toString() {
    result = getToStringPrefix(this) + "SSA phi read(" + this.getSourceVariable() + ")"
  }

  override Location getLocation() { result = this.getBasicBlock().getLocation() }

  override Callable getEnclosingCallable() {
    result = this.getSourceVariable().getEnclosingCallable()
  }
}

private module DataFlowIntegrationInput implements Impl::DataFlowIntegrationInputSig {
  private import csharp as Cs
  private import semmle.code.csharp.controlflow.BasicBlocks

  class Expr extends ControlFlow::Node {
    predicate hasCfgNode(ControlFlow::BasicBlock bb, int i) { this = bb.getNode(i) }
  }

  Expr getARead(Definition def) { exists(getAReadAtNode(def, result)) }

  predicate ssaDefAssigns(WriteDefinition def, Expr value) {
    // exclude flow directly from RHS to SSA definition, as we instead want to
    // go from RHS to matching assingnable definition, and from there to SSA definition
    none()
  }

  class Parameter = Ssa::ImplicitParameterDefinition;

  predicate ssaDefInitializesParam(WriteDefinition def, Parameter p) { def = p }

  /**
   * Allows for flow into uncertain defintions that are not call definitions,
   * as we, conservatively, consider such definitions to be certain.
   */
  predicate allowFlowIntoUncertainDef(UncertainWriteDefinition def) {
    def instanceof Ssa::ExplicitDefinition
    or
    def =
      any(Ssa::ImplicitQualifierDefinition qdef |
        allowFlowIntoUncertainDef(qdef.getQualifierDefinition())
      )
  }

  class Guard extends Guards::Guard {
    predicate hasCfgNode(ControlFlow::BasicBlock bb, int i) {
      this.getAControlFlowNode() = bb.getNode(i)
    }
  }

  /** Holds if the guard `guard` controls block `bb` upon evaluating to `branch`. */
  predicate guardControlsBlock(Guard guard, ControlFlow::BasicBlock bb, boolean branch) {
    exists(ConditionBlock conditionBlock, ControlFlow::SuccessorTypes::ConditionalSuccessor s |
      guard.getAControlFlowNode() = conditionBlock.getLastNode() and
      s.getValue() = branch and
      conditionBlock.controls(bb, s)
    )
  }

  /** Gets an immediate conditional successor of basic block `bb`, if any. */
  ControlFlow::BasicBlock getAConditionalBasicBlockSuccessor(
    ControlFlow::BasicBlock bb, boolean branch
  ) {
    exists(ControlFlow::SuccessorTypes::ConditionalSuccessor s |
      result = bb.getASuccessorByType(s) and
      s.getValue() = branch
    )
  }
}

private module DataFlowIntegrationImpl = Impl::DataFlowIntegration<DataFlowIntegrationInput>;

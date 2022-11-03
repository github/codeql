/**
 * Provides classes and predicates for tracking global state across the control flow and call graphs.
 *
 * NOTE: State tracking tracks both whether a state may apply to a given node in a given context *and*
 * whether it may not apply.
 * That `state.appliesTo(f, ctx)` holds implies nothing about whether `state.mayNotApplyTo(f, ctx)` holds.
 * Neither may hold which merely means that `f` with context `ctx` is not reached during the analysis.
 * Conversely, both may hold, which means that `state` may or may not apply depending on how `f` was reached.
 */

import python
private import semmle.python.pointsto.Base
private import semmle.python.pointsto.PointsTo
private import semmle.python.pointsto.PointsToContext
private import semmle.python.objects.ObjectInternal

/** A state that should be tracked. */
abstract class TrackableState extends string {
  bindingset[this]
  TrackableState() { this = this }

  /** Holds if this state may apply to the control flow node `f`, regardless of the context. */
  final predicate appliesTo(ControlFlowNode f) { this.appliesTo(f, _) }

  /** Holds if this state may not apply to the control flow node `f`, given the context `ctx`. */
  final predicate appliesTo(ControlFlowNode f, Context ctx) {
    StateTracking::appliesToNode(this, f, ctx, true)
  }

  /** Holds if this state may apply to the control flow node `f`, given the context `ctx`. */
  final predicate mayNotApplyTo(ControlFlowNode f, Context ctx) {
    StateTracking::appliesToNode(this, f, ctx, false)
  }

  /** Holds if this state may apply to the control flow node `f`, regardless of the context. */
  final predicate mayNotApplyTo(ControlFlowNode f) { this.mayNotApplyTo(f, _) }

  /** Holds if `test` shows value to be untainted with `taint`, given the context `ctx`. */
  predicate testsFor(PyEdgeRefinement test, Context ctx, boolean sense) {
    ctx.appliesToScope(test.getScope()) and this.testsFor(test, sense)
  }

  /** Holds if `test` shows value to be untainted with `taint` */
  predicate testsFor(PyEdgeRefinement test, boolean sense) { none() }

  /**
   * Holds if state starts at `f`.
   * Either this predicate or `startsAt(ControlFlowNode f, Context ctx)`
   * should be overriden by sub-classes.
   */
  predicate startsAt(ControlFlowNode f) { none() }

  /**
   * Holds if state starts at `f` given context `ctx`.
   * Either this predicate or `startsAt(ControlFlowNode f)`
   * should be overriden by sub-classes.
   */
  pragma[noinline]
  predicate startsAt(ControlFlowNode f, Context ctx) { ctx.appliesTo(f) and this.startsAt(f) }

  /**
   * Holds if state ends at `f`.
   * Either this predicate or `endsAt(ControlFlowNode f, Context ctx)`
   * may be overriden by sub-classes.
   */
  predicate endsAt(ControlFlowNode f) { none() }

  /**
   * Holds if state ends at `f` given context `ctx`.
   * Either this predicate or `endsAt(ControlFlowNode f)`
   * may be overriden by sub-classes.
   */
  pragma[noinline]
  predicate endsAt(ControlFlowNode f, Context ctx) { ctx.appliesTo(f) and this.endsAt(f) }
}

module StateTracking {
  private predicate not_allowed(TrackableState state, ControlFlowNode f, Context ctx, boolean sense) {
    state.endsAt(f, ctx) and sense = true
    or
    state.startsAt(f, ctx) and sense = false
  }

  /**
   * Holds if `state` may apply (with `sense` = true) or may not apply (with `sense` = false) to
   * control flow node `f` given the context `ctx`.
   */
  predicate appliesToNode(TrackableState state, ControlFlowNode f, Context ctx, boolean sense) {
    state.endsAt(f, ctx) and sense = false
    or
    state.startsAt(f, ctx) and sense = true
    or
    not not_allowed(state, f, ctx, sense) and
    (
      exists(BasicBlock b |
        /* First node in a block */
        f = b.getNode(0) and appliesAtBlockStart(state, b, ctx, sense)
        or
        /* Other nodes in block, except trackable calls */
        exists(int n |
          f = b.getNode(n) and
          appliesToNode(state, b.getNode(n - 1), ctx, sense) and
          not exists(PythonFunctionObjectInternal func, Context callee |
            callee.fromCall(f, func, ctx)
          )
        )
      )
      or
      /* Function entry via call */
      exists(PythonFunctionObjectInternal func, CallNode call, Context caller |
        ctx.fromCall(call, func, caller) and
        func.getScope().getEntryNode() = f and
        appliesToNode(state, call.getAPredecessor(), caller, sense)
      )
      or
      /* Function return */
      exists(PythonFunctionObjectInternal func, Context callee |
        callee.fromCall(f, func, ctx) and
        appliesToNode(state, func.getScope().getANormalExit(), callee, sense)
      )
      or
      /* Other scope entries */
      exists(Scope s |
        s.getEntryNode() = f and
        ctx.appliesToScope(s)
      |
        not exists(Scope pred | pred.precedes(s)) and
        (ctx.isImport() or ctx.isRuntime()) and
        sense = false
        or
        exists(Scope pred, Context pred_ctx |
          appliesToNode(state, pred.getANormalExit(), pred_ctx, sense) and
          pred.precedes(s) and
          ctx.isRuntime()
        |
          pred_ctx.isRuntime() or pred_ctx.isImport()
        )
      )
    )
  }

  /**
   * Holds  if `state` may apply (with `sense` = true) or may not apply (with `sense` = false) at the
   * start of basic block `block` given the context `ctx`.
   */
  private predicate appliesAtBlockStart(
    TrackableState state, BasicBlock block, Context ctx, boolean sense
  ) {
    exists(PyEdgeRefinement test |
      test.getSuccessor() = block and
      state.testsFor(test, ctx, sense)
    )
    or
    exists(BasicBlock pred |
      pred.getASuccessor() = block and
      appliesAtBlockEnd(state, pred, ctx, sense) and
      not exists(PyEdgeRefinement test |
        test.getPredecessor() = pred and
        test.getSuccessor() = block and
        state.testsFor(test, sense.booleanNot())
      )
    )
  }

  /**
   * Holds  if `state` may apply (with `sense` = true) or may not apply (with `sense` = false) at the
   * end of basic block `block` given the context `ctx`.
   */
  private predicate appliesAtBlockEnd(
    TrackableState state, BasicBlock block, Context ctx, boolean sense
  ) {
    appliesToNode(state, block.getLastNode(), ctx, sense)
  }
}

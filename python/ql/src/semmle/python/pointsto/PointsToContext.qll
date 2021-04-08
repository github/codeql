import python
private import semmle.python.pointsto.PointsTo
private import semmle.python.objects.ObjectInternal

/*
 * A note on 'cost'. Cost doesn't represent the cost to compute,
 * but (a vague estimate of) the cost to compute per value gained.
 * This is constantly evolving, so see the various cost functions below for more details.
 */

private int given_cost() {
  exists(string depth |
    py_flags_versioned("context.cost", depth, _) and
    result = depth.toInt()
  )
}

pragma[noinline]
private int max_context_cost() {
  not py_flags_versioned("context.cost", _, _) and result = 7
  or
  result = max(int cost | cost = given_cost() | cost)
}

private int syntactic_call_count(Scope s) {
  exists(Function f | f = s and f.getName() != "__init__" |
    result =
      count(CallNode call |
        call.getFunction().(NameNode).getId() = f.getName()
        or
        call.getFunction().(AttrNode).getName() = f.getName()
      )
  )
  or
  s.getName() = "__init__" and result = 1
  or
  not s instanceof Function and result = 0
}

private int incoming_call_cost(Scope s) {
  /*
   * Syntactic call count will often be a considerable overestimate
   * of the actual number of calls, so we use the square root.
   * Cost = log(sqrt(call-count))
   */

  result = ((syntactic_call_count(s) + 1).log(2) * 0.5).floor()
}

private int context_cost(TPointsToContext ctx) {
  ctx = TMainContext() and result = 0
  or
  ctx = TRuntimeContext() and result = 0
  or
  ctx = TImportContext() and result = 0
  or
  ctx = TCallContext(_, _, result)
}

private int call_cost(CallNode call) {
  if call.getScope().inSource() then result = 2 else result = 3
}

private int outgoing_calls(Scope s) { result = strictcount(CallNode call | call.getScope() = s) }

predicate super_method_call(CallNode call) {
  call.getFunction().(AttrNode).getObject().(CallNode).getFunction().(NameNode).getId() = "super"
}

private int outgoing_call_cost(CallNode c) {
  /* Cost = log(outgoing-call-count) */
  result = outgoing_calls(c.getScope()).log(2).floor()
}

/**
 * Cost of contexts for a call, the more callers the
 * callee of call has the more expensive it is to add contexts for it.
 * This seems to be an effective heuristics for preventing an explosion
 * in the number of contexts while retaining good results.
 */
private int splay_cost(CallNode c) {
  if super_method_call(c)
  then result = 0
  else result = outgoing_call_cost(c) + incoming_call_cost(c.getScope())
}

private predicate call_to_init_or_del(CallNode call) {
  exists(string mname | mname = "__init__" or mname = "__del__" |
    mname = call.getFunction().(AttrNode).getName()
  )
}

/** Total cost estimate */
private int total_call_cost(CallNode call) {
  /*
   * We want to always follow __init__ and __del__ calls as they tell us about object construction,
   * but we need to be aware of cycles, so they must have a non-zero cost.
   */

  if call_to_init_or_del(call) then result = 1 else result = call_cost(call) + splay_cost(call)
}

pragma[noinline]
private int total_cost(CallNode call, PointsToContext ctx) {
  ctx.appliesTo(call) and
  result = total_call_cost(call) + context_cost(ctx)
}

cached
private newtype TPointsToContext =
  TMainContext() or
  TRuntimeContext() or
  TImportContext() or
  TCallContext(ControlFlowNode call, PointsToContext outerContext, int cost) {
    total_cost(call, outerContext) = cost and
    cost <= max_context_cost()
  } or
  TObjectContext(SelfInstanceInternal object)

module Context {
  PointsToContext forObject(ObjectInternal object) { result = TObjectContext(object) }
}

/**
 * Points-to context. Context can be one of:
 *    * "main": Used for scripts.
 *    * "import": Use for non-script modules.
 *    * "default": Use for functions and methods without caller context.
 *    * All other contexts are call contexts and consist of a pair of call-site and caller context.
 */
class PointsToContext extends TPointsToContext {
  /** Gets a textual representation of this element. */
  cached
  string toString() {
    this = TMainContext() and result = "main"
    or
    this = TRuntimeContext() and result = "runtime"
    or
    this = TImportContext() and result = "import"
    or
    exists(CallNode callsite, PointsToContext outerContext |
      this = TCallContext(callsite, outerContext, _) and
      result = callsite.getLocation() + " from " + outerContext.toString()
    )
  }

  /** Holds if `call` is the call-site from which this context was entered and `outer` is the caller's context. */
  predicate fromCall(CallNode call, PointsToContext caller) {
    caller.appliesTo(call) and
    this = TCallContext(call, caller, _)
  }

  /** Holds if `call` is the call-site from which this context was entered and `caller` is the caller's context. */
  predicate fromCall(CallNode call, PythonFunctionObjectInternal callee, PointsToContext caller) {
    call = callee.getACall(caller) and
    this = TCallContext(call, caller, _)
  }

  /** Gets the caller context for this callee context. */
  PointsToContext getOuter() { this = TCallContext(_, result, _) }

  /** Holds if this context is relevant to the given scope. */
  predicate appliesToScope(Scope s) {
    /* Scripts */
    this = TMainContext() and maybe_main(s)
    or
    /* Modules and classes evaluated at import */
    s instanceof ImportTimeScope and this = TImportContext()
    or
    this = TRuntimeContext() and executes_in_runtime_context(s)
    or
    /* Called functions, regardless of their name */
    exists(
      PythonFunctionObjectInternal callable, ControlFlowNode call, TPointsToContext outerContext
    |
      call = callable.getACall(outerContext) and
      this = TCallContext(call, outerContext, _)
    |
      s = callable.getScope()
    )
    or
    InterProceduralPointsTo::callsite_calls_function(_, _, s, this, _)
  }

  /** Holds if this context can apply to the CFG node `n`. */
  pragma[inline]
  predicate appliesTo(ControlFlowNode n) { this.appliesToScope(n.getScope()) }

  /** Holds if this context is a call context. */
  predicate isCall() { this = TCallContext(_, _, _) }

  /** Holds if this is the "main" context. */
  predicate isMain() { this = TMainContext() }

  /** Holds if this is the "import" context. */
  predicate isImport() { this = TImportContext() }

  /** Holds if this is the "default" context. */
  predicate isRuntime() { this = TRuntimeContext() }

  /** Holds if this context or one of its caller contexts is the default context. */
  predicate fromRuntime() {
    this.isRuntime()
    or
    this.getOuter().fromRuntime()
  }

  /** Gets the depth (number of calls) for this context. */
  int getDepth() {
    not exists(this.getOuter()) and result = 0
    or
    result = this.getOuter().getDepth() + 1
  }

  int getCost() { result = context_cost(this) }

  CallNode getCall() { this = TCallContext(result, _, _) }

  /** Holds if a call would be too expensive to create a new context for */
  pragma[nomagic]
  predicate untrackableCall(CallNode call) { total_cost(call, this) > max_context_cost() }

  CallNode getRootCall() {
    this = TCallContext(result, TImportContext(), _)
    or
    result = this.getOuter().getRootCall()
  }

  /** Gets a version of Python that this context includes */
  pragma[inline]
  Version getAVersion() {
    /* Currently contexts do not include any version information, but may do in the future */
    result = major_version()
  }
}

private predicate in_source(Scope s) { exists(s.getEnclosingModule().getFile().getRelativePath()) }

/**
 * Holds if this scope can be executed in the default context.
 * All modules and classes executed at import time and
 * all "public" functions and methods, including those invoked by the VM.
 */
predicate executes_in_runtime_context(Function f) {
  /* "Public" scope, i.e. functions whose name starts not with an underscore, or special methods */
  (f.getName().charAt(0) != "_" or f.isSpecialMethod() or f.isInitMethod()) and
  in_source(f)
}

private predicate maybe_main(Module m) {
  exists(If i, Compare cmp, Name name, StrConst main | m.getAStmt() = i and i.getTest() = cmp |
    cmp.compares(name, any(Eq eq), main) and
    name.getId() = "__name__" and
    main.getText() = "__main__"
  )
}

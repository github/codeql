private import codeql.ruby.AST
private import codeql.ruby.CFG
private import DataFlowPrivate
private import codeql.ruby.typetracking.internal.TypeTrackingImpl
private import codeql.ruby.ast.internal.Module as Module
private import FlowSummaryImpl as FlowSummaryImpl
private import codeql.ruby.dataflow.FlowSummary
private import codeql.ruby.dataflow.SSA
private import codeql.util.Boolean
private import codeql.util.Unit

/**
 * A `LocalSourceNode` for a `self` variable. This is the implicit `self`
 * parameter, when it exists, otherwise the implicit SSA entry definition.
 */
private class SelfLocalSourceNode extends DataFlow::LocalSourceNode {
  private SelfVariable self;

  SelfLocalSourceNode() {
    self = this.(SelfParameterNodeImpl).getSelfVariable()
    or
    self = this.(SsaSelfDefinitionNode).getVariable()
  }

  /** Gets the `self` variable. */
  SelfVariable getVariable() { result = self }
}

newtype TReturnKind =
  TNormalReturnKind() or
  TBreakReturnKind() or
  TNewReturnKind()

/**
 * Gets a node that can read the value returned from `call` with return kind
 * `kind`.
 */
OutNode getAnOutNode(DataFlowCall call, ReturnKind kind) { call = result.getCall(kind) }

/**
 * A return kind. A return kind describes how a value can be returned
 * from a callable.
 */
abstract class ReturnKind extends TReturnKind {
  /** Gets a textual representation of this position. */
  abstract string toString();
}

/**
 * A value returned from a callable using a `return` statement or an expression
 * body, that is, a "normal" return.
 */
class NormalReturnKind extends ReturnKind, TNormalReturnKind {
  override string toString() { result = "return" }
}

/**
 * A value returned from a callable using a `break` statement.
 */
class BreakReturnKind extends ReturnKind, TBreakReturnKind {
  override string toString() { result = "break" }
}

/**
 * A special return kind that is used to represent the value returned
 * from user-defined `new` methods as well as the effect on `self` in
 * `initialize` methods.
 */
class NewReturnKind extends ReturnKind, TNewReturnKind {
  override string toString() { result = "new" }
}

/** A callable defined in library code, identified by a unique string. */
abstract class LibraryCallable extends string {
  bindingset[this]
  LibraryCallable() { any() }

  /** Gets a call to this library callable. */
  Call getACall() { none() }

  /** Same as `getACall()` except this does not depend on the call graph or API graph. */
  Call getACallSimple() { none() }
}

/** A callable defined in library code, which should be taken into account in type tracking. */
abstract class LibraryCallableToIncludeInTypeTracking extends LibraryCallable {
  bindingset[this]
  LibraryCallableToIncludeInTypeTracking() { exists(this) }
}

/**
 * A callable. This includes callables from source code, as well as callables
 * defined in library code.
 */
class DataFlowCallable extends TDataFlowCallable {
  /**
   * Gets the underlying CFG scope, if any.
   *
   * This is usually a `Callable`, but can also be a `Toplevel` file.
   */
  CfgScope asCfgScope() { this = TCfgScope(result) }

  /** Gets the underlying library callable, if any. */
  LibraryCallable asLibraryCallable() { this = TLibraryCallable(result) }

  /** Gets a textual representation of this callable. */
  string toString() { result = [this.asCfgScope().toString(), this.asLibraryCallable()] }

  /** Gets the location of this callable. */
  Location getLocation() {
    result = this.asCfgScope().getLocation()
    or
    this instanceof TLibraryCallable and
    result instanceof EmptyLocation
  }
}

/**
 * A call. This includes calls from source code, as well as call(back)s
 * inside library callables with a flow summary.
 */
abstract class DataFlowCall extends TDataFlowCall {
  /** Gets the enclosing callable. */
  abstract DataFlowCallable getEnclosingCallable();

  /** Gets the underlying source code call, if any. */
  abstract CfgNodes::ExprNodes::CallCfgNode asCall();

  /** Gets a textual representation of this call. */
  abstract string toString();

  /** Gets the location of this call. */
  abstract Location getLocation();

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

/**
 * A synthesized call inside a callable with a flow summary.
 *
 * For example, in
 * ```rb
 * ints.each do |i|
 *   puts i
 * end
 * ```
 *
 * there is a call to the block argument inside `each`.
 */
class SummaryCall extends DataFlowCall, TSummaryCall {
  private FlowSummaryImpl::Public::SummarizedCallable c;
  private FlowSummaryImpl::Private::SummaryNode receiver;

  SummaryCall() { this = TSummaryCall(c, receiver) }

  /** Gets the data flow node that this call targets. */
  FlowSummaryImpl::Private::SummaryNode getReceiver() { result = receiver }

  override DataFlowCallable getEnclosingCallable() { result.asLibraryCallable() = c }

  override CfgNodes::ExprNodes::CallCfgNode asCall() { none() }

  override string toString() { result = "[summary] call to " + receiver + " in " + c }

  override EmptyLocation getLocation() { any() }
}

class NormalCall extends DataFlowCall, TNormalCall {
  private CfgNodes::ExprNodes::CallCfgNode c;

  NormalCall() { this = TNormalCall(c) }

  override CfgNodes::ExprNodes::CallCfgNode asCall() { result = c }

  override DataFlowCallable getEnclosingCallable() { result = TCfgScope(c.getScope()) }

  override string toString() { result = c.toString() }

  override Location getLocation() { result = c.getLocation() }
}

/**
 * Provides modeling of flow through the `render` method of view components.
 *
 * ```rb
 * # view.rb
 * class View < ViewComponent::Base
 *     def initialize(x)
 *         @x = x
 *     end
 *
 *     def foo
 *         sink(@x)
 *     end
 * end
 * ```
 *
 * ```erb
 * # view.html.erb
 * <%= foo() %>                     # 1
 * ```
 *
 * ```rb
 * # app.rb
 * class App
 *     def run
 *         view = View.new(taint)   # 2
 *         render(view)             # 3
 *     end
 * end
 * ```
 *
 * The `render` call (3) is modeled using a flow summary. The summary specifies
 * that the first argument (`view`) will have a special method invoked on it (we
 * call the method `__invoke__toplevel__erb__`), which targets the top-level of the
 * matching ERB file (`view.html.erb`). The `view` argument will flow into the receiver
 * of the synthesized method call, from there into the implicit `self` parameter of
 * the ERB file, and from there to the implicit `self` receiver of the call to `foo` (1).
 *
 * Since it is not actually possible to specify such flow summaries, we instead
 * specify a call-back summary, and adjust the generated call to target the special
 * `__invoke__toplevel__erb__` method.
 *
 * In order to resolve the target of the adjusted method call, we need to take
 * the `render` summary into account when constructing the call graph. That is, we
 * need to track the `View` instance (2) into the receiver of the adjusted method
 * call, in order to figure out that the call target is in fact `view.html.erb`.
 */
module ViewComponentRenderModeling {
  private import codeql.ruby.frameworks.ViewComponent

  private class RenderMethod extends SummarizedCallable, LibraryCallableToIncludeInTypeTracking {
    RenderMethod() { this = "render view component" }

    override MethodCall getACallSimple() { result.getMethodName() = "render" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[0]" and
      // use a call-back summary, and adjust it to a method call below
      output = "Argument[0].Parameter[self]" and
      preservesValue = true
    }
  }

  private string invokeToplevelName() { result = "__invoke__toplevel__erb__" }

  /** Holds if `call` should be adjusted to be a method call to `name` on `receiver`. */
  predicate adjustedMethodCall(DataFlowCall call, FlowSummaryNode receiver, string name) {
    exists(RenderMethod render |
      call = TSummaryCall(render, receiver.getSummaryNode()) and
      name = invokeToplevelName()
    )
  }

  /** Holds if `self` belongs to the top-level of an ERB file with matching view class `view`. */
  pragma[nomagic]
  predicate selfInErbToplevel(SelfVariable self, ViewComponent::ComponentClass view) {
    self.getDeclaringScope().(Toplevel).getFile() = view.getTemplate()
  }

  Toplevel lookupMethod(ViewComponent::ComponentClass m, string name) {
    result.getFile() = m.getTemplate() and
    name = invokeToplevelName()
  }
}

/** A call for which we want to compute call targets. */
private class RelevantCall extends CfgNodes::ExprNodes::CallCfgNode {
  pragma[nomagic]
  RelevantCall() {
    // Temporarily disable operation resolution (due to bad performance)
    not this.getExpr() instanceof Operation
  }
}

pragma[nomagic]
private predicate methodCall(DataFlowCall call, DataFlow::Node receiver, string method) {
  call.asCall() =
    any(RelevantCall rc |
      method = rc.getExpr().(MethodCall).getMethodName() and
      receiver.asExpr() = rc.getReceiver()
    )
  or
  ViewComponentRenderModeling::adjustedMethodCall(call, receiver, method)
}

pragma[nomagic]
private predicate flowsToMethodCallReceiver(
  DataFlowCall call, DataFlow::LocalSourceNode sourceNode, string method
) {
  exists(DataFlow::Node receiver |
    methodCall(call, receiver, method) and
    sourceNode.flowsTo(receiver)
  )
}

pragma[nomagic]
private predicate moduleFlowsToMethodCallReceiver(DataFlowCall call, Module m, string method) {
  flowsToMethodCallReceiver(call, trackModuleAccess(m), method)
}

private Block blockCall(RelevantCall call) {
  lambdaSourceCall(call, _, trackBlock(result).(DataFlow::LocalSourceNode).getALocalUse())
}

pragma[nomagic]
private predicate superCall(RelevantCall call, Module cls, string method) {
  call.getExpr() instanceof SuperCall and
  cls = call.getExpr().getEnclosingModule().getModule() and
  method = call.getExpr().getEnclosingMethod().getName()
}

/** Holds if `self` belongs to module `m`. */
pragma[nomagic]
private predicate selfInModule(SelfVariable self, Module m) {
  exists(Scope scope |
    scope = self.getDeclaringScope() and
    m = scope.(ModuleBase).getModule() and
    not scope instanceof Toplevel
  )
}

/** Holds if `self` belongs to method `method` inside module `m`. */
pragma[nomagic]
predicate selfInMethod(SelfVariable self, MethodBase method, Module m) {
  exists(ModuleBase encl |
    method = self.getDeclaringScope() and
    encl = method.getEnclosingModule() and
    if encl instanceof SingletonClass
    then m = encl.getEnclosingModule().getModule()
    else m = encl.getModule()
  )
}

/** Holds if `new` is a user-defined `self.new` method. */
predicate isUserDefinedNew(SingletonMethod new) {
  exists(Expr object | singletonMethod(new, "new", object) |
    selfInModule(object.(SelfVariableReadAccess).getVariable(), _)
    or
    exists(Module::resolveConstantReadAccess(object))
  )
}

private DataFlowCallable viableSourceCallableNonInit(DataFlowCall call) {
  result.asCfgScope() = getTargetInstance(call, _)
  or
  result.asCfgScope() = getTargetSingleton(call, _)
  or
  exists(Module cls, string method |
    superCall(call.asCall(), cls, method) and
    result.asCfgScope() = lookupMethod(cls.getAnImmediateAncestor(), method)
  )
}

private Callable viableSourceCallableInit(RelevantCall call) { result = getInitializeTarget(call) }

/** Holds if `call` may resolve to the returned source-code method. */
private DataFlowCallable viableSourceCallable(DataFlowCall call) {
  result = viableSourceCallableNonInit(call) or
  result.asCfgScope() = viableSourceCallableInit(call.asCall()) or
  result = any(AdditionalCallTarget t).viableTarget(call.asCall())
}

/**
 * A unit class for adding additional call steps.
 *
 * Extend this class to add additional call steps to the data flow graph.
 */
class AdditionalCallTarget extends Unit {
  /**
   * Gets a viable target for `call`.
   */
  abstract DataFlowCallable viableTarget(CfgNodes::ExprNodes::CallCfgNode call);
}

/** Holds if `call` may resolve to the returned summarized library method. */
DataFlowCallable viableLibraryCallable(DataFlowCall call) {
  exists(LibraryCallable callable |
    result = TLibraryCallable(callable) and
    call.asCall().getExpr() = [callable.getACall(), callable.getACallSimple()]
  )
}

/** Holds if there is a call like `receiver.extend(M)`. */
pragma[nomagic]
private predicate extendCall(DataFlow::ExprNode receiver, Module m) {
  exists(DataFlow::CallNode extendCall |
    extendCall.getMethodName() = "extend" and
    exists(DataFlow::LocalSourceNode sourceNode | sourceNode.flowsTo(extendCall.getArgument(_)) |
      selfInModule(sourceNode.(SelfLocalSourceNode).getVariable(), m) or
      m = Module::resolveConstantReadAccess(sourceNode.asExpr().getExpr())
    ) and
    receiver = extendCall.getReceiver()
  )
}

/** Holds if there is a call like `M.extend(N)` */
pragma[nomagic]
private predicate extendCallModule(Module m, Module n) {
  exists(DataFlow::LocalSourceNode receiver, DataFlow::ExprNode e |
    receiver.flowsTo(e) and extendCall(e, n)
  |
    selfInModule(receiver.(SelfLocalSourceNode).getVariable(), m) or
    m = Module::resolveConstantReadAccess(receiver.asExpr().getExpr())
  )
}

private CfgScope lookupMethod(Module m, string name) {
  result = Module::lookupMethod(m, name)
  or
  result = ViewComponentRenderModeling::lookupMethod(m, name)
}

/**
 * Gets a method available in module `m`, or in one of `m`'s transitive
 * sub classes when `exact = false`.
 */
pragma[nomagic]
private CfgScope lookupMethod(Module m, string name, boolean exact) {
  result = lookupMethod(m, name) and
  exact in [false, true]
  or
  result = Module::lookupMethodInSubClasses(m, name) and
  exact = false
}

cached
private module Cached {
  cached
  newtype TDataFlowCallable =
    TCfgScope(CfgScope scope) or
    TLibraryCallable(LibraryCallable callable)

  cached
  newtype TDataFlowCall =
    TNormalCall(CfgNodes::ExprNodes::CallCfgNode c) or
    TSummaryCall(
      FlowSummaryImpl::Public::SummarizedCallable c, FlowSummaryImpl::Private::SummaryNode receiver
    ) {
      FlowSummaryImpl::Private::summaryCallbackRange(c, receiver)
    }

  /**
   * Gets the relevant `initialize` method for the `new` call, if any.
   */
  cached
  Method getInitializeTarget(RelevantCall new) {
    exists(Module m, boolean exact |
      isStandardNewCall(new, m, exact) and
      result = lookupMethod(m, "initialize", exact) and
      // In the case where `exact = false`, we need to check that there is
      // no user-defined `new` method in between `m` and the enclosing module
      // of the `initialize` method (`isStandardNewCall` already checks that
      // there is no user-defined `new` method in `m` or any of `m`'s ancestors)
      not hasUserDefinedNew(result.getEnclosingModule().getModule())
    )
  }

  cached
  CfgScope getTarget(DataFlowCall call) {
    result = viableSourceCallableNonInit(call).asCfgScope()
    or
    result = blockCall(call.asCall())
  }

  /** Gets a viable run-time target for the call `call`. */
  cached
  DataFlowCallable viableCallable(DataFlowCall call) {
    result = viableSourceCallable(call)
    or
    result = viableLibraryCallable(call)
  }

  cached
  newtype TArgumentPosition =
    TSelfArgumentPosition() or
    TLambdaSelfArgumentPosition() or
    TBlockArgumentPosition() or
    TPositionalArgumentPosition(int pos) {
      exists(Call c | exists(c.getArgument(pos)))
      or
      FlowSummaryImpl::ParsePositions::isParsedParameterPosition(_, pos)
    } or
    TKeywordArgumentPosition(string name) {
      name = any(KeywordParameter kp).getName()
      or
      exists(any(Call c).getKeywordArgument(name))
      or
      FlowSummaryImpl::ParsePositions::isParsedKeywordParameterPosition(_, name)
    } or
    THashSplatArgumentPosition() or
    TSynthHashSplatArgumentPosition() or
    TSplatArgumentPosition(int pos) { exists(Call c | c.getArgument(pos) instanceof SplatExpr) } or
    TSynthSplatArgumentPosition(int actualSplatPos) {
      actualSplatPos = -1 // represents no actual splat
      or
      exists(Call c | c.getArgument(actualSplatPos) instanceof SplatExpr)
    } or
    TAnyArgumentPosition() or
    TAnyKeywordArgumentPosition()

  cached
  newtype TParameterPosition =
    TSelfParameterPosition() or
    TLambdaSelfParameterPosition() or
    TBlockParameterPosition() or
    TPositionalParameterPosition(int pos) {
      pos = any(Parameter p).getPosition()
      or
      FlowSummaryImpl::ParsePositions::isParsedArgumentPosition(_, pos)
    } or
    TPositionalParameterLowerBoundPosition(int pos) {
      FlowSummaryImpl::ParsePositions::isParsedArgumentLowerBoundPosition(_, pos)
    } or
    TKeywordParameterPosition(string name) {
      name = any(KeywordParameter kp).getName()
      or
      exists(any(Call c).getKeywordArgument(name))
      or
      FlowSummaryImpl::ParsePositions::isParsedKeywordArgumentPosition(_, name)
    } or
    THashSplatParameterPosition() or
    TSynthHashSplatParameterPosition() or
    TSplatParameterPosition(int pos) {
      pos = 0 // needed for flow summaries
      or
      exists(Parameter p | p.getPosition() = pos and p instanceof SplatParameter)
    } or
    TSynthSplatParameterPosition(int actualSplatPos) {
      actualSplatPos = -1 // represents no actual splat
      or
      exists(Callable c | c.getParameter(actualSplatPos) instanceof SplatParameter)
    } or
    TAnyParameterPosition() or
    TAnyKeywordParameterPosition()
}

import Cached

private module TrackModuleInput implements CallGraphConstruction::Simple::InputSig {
  class State = Module;

  predicate start(DataFlow::Node start, Module m) {
    m = Module::resolveConstantReadAccess(start.asExpr().getExpr())
  }

  // We exclude steps into `self` parameters, and instead rely on the type of the
  // enclosing module
  predicate filter(DataFlow::Node n) { n instanceof SelfParameterNodeImpl }
}

predicate trackModuleAccess = CallGraphConstruction::Simple::Make<TrackModuleInput>::track/1;

pragma[nomagic]
private predicate hasUserDefinedNew(Module m) {
  exists(DataFlow::MethodNode method |
    // not `getAnAncestor` because singleton methods cannot be included
    singletonMethodOnModule(method.asCallableAstNode(), "new", m.getSuperClass*()) and
    not method.getSelfParameter().getAMethodCall("allocate").flowsTo(method.getAReturnNode())
  )
}

/**
 * Holds if `new` is a call to `new`, targeting a class of type `m` (or a
 * sub class, when `exact = false`), where there is no user-defined
 * `self.new` on `m`.
 */
pragma[nomagic]
predicate isStandardNewCall(RelevantCall new, Module m, boolean exact) {
  exists(DataFlow::LocalSourceNode sourceNode |
    flowsToMethodCallReceiver(TNormalCall(new), sourceNode, "new") and
    // `m` should not have a user-defined `self.new` method
    not hasUserDefinedNew(m)
  |
    // `C.new`
    sourceNode = trackModuleAccess(m) and
    exact = true
    or
    // `self.new` inside a module
    selfInModule(sourceNode.(SelfLocalSourceNode).getVariable(), m) and
    exact = true
    or
    // `self.new` inside a singleton method
    exists(MethodBase caller |
      selfInMethod(sourceNode.(SelfLocalSourceNode).getVariable(), caller, m) and
      singletonMethod(caller, _, _) and
      exact = false
    )
  )
}

private predicate localFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo, StepSummary summary) {
  localFlowStepTypeTracker(nodeFrom, nodeTo) and
  summary.toString() = "level"
}

private module TrackInstanceInput implements CallGraphConstruction::InputSig {
  newtype State = additional MkState(Module m, Boolean exact)

  predicate start(DataFlow::Node start, State state) {
    exists(Module tp, boolean exact | state = MkState(tp, exact) |
      TypeInference::hasType(start, tp, exact)
      or
      exists(Module m |
        (if m.isClass() then tp = Module::TResolved("Class") else tp = Module::TResolved("Module")) and
        exact = true
      |
        // needed for e.g. `C.new`
        m = Module::resolveConstantReadAccess(start.asExpr().getExpr())
        or
        // needed for e.g. `self.include`
        selfInModule(start.(SelfLocalSourceNode).getVariable(), m)
        or
        // needed for e.g. `self.puts`
        selfInMethod(start.(SelfLocalSourceNode).getVariable(), any(SingletonMethod sm), m)
      )
    )
  }

  pragma[nomagic]
  private predicate hasAdjacentTypeCheckedRead(DataFlow::Node node) {
    TypeInference::hasAdjacentTypeCheckedRead(node.asExpr(), _)
  }

  pragma[nomagic]
  predicate stepNoCall(DataFlow::Node nodeFrom, DataFlow::Node nodeTo, StepSummary summary) {
    smallStepNoCall(nodeFrom, nodeTo, summary)
    or
    // We exclude steps into type checked variables. For those, we instead rely on the
    // type being checked against
    localFlowStep(nodeFrom, nodeTo, summary) and
    not hasAdjacentTypeCheckedRead(nodeTo) and
    not TypeInference::asModulePattern(nodeTo.(SsaDefinitionExtNode).getDefinitionExt(), _)
  }

  predicate stepCall(DataFlow::Node nodeFrom, DataFlow::Node nodeTo, StepSummary summary) {
    smallStepCall(nodeFrom, nodeTo, summary)
  }

  class StateProj = Unit;

  Unit stateProj(State state) { exists(state) and exists(result) }

  // We exclude steps into `self` parameters, and instead rely on the type of the
  // enclosing module
  predicate filter(DataFlow::Node n, Unit u) {
    n instanceof SelfParameterNodeImpl and
    exists(u)
  }
}

pragma[nomagic]
private DataFlow::Node trackInstance(Module tp, boolean exact) {
  result =
    CallGraphConstruction::Make<TrackInstanceInput>::track(TrackInstanceInput::MkState(tp, exact))
}

pragma[nomagic]
private CfgScope lookupInstanceMethodCall(DataFlowCall call, string method, boolean exact) {
  exists(Module tp, DataFlow::Node receiver |
    methodCall(call, pragma[only_bind_into](receiver), pragma[only_bind_into](method)) and
    receiver = trackInstance(tp, exact) and
    result = lookupMethod(tp, pragma[only_bind_into](method), exact)
  )
}

pragma[nomagic]
private predicate isToplevelMethodInFile(Method m, File f) {
  m.getEnclosingModule() instanceof Toplevel and
  f = m.getFile()
}

pragma[nomagic]
private CfgScope getTargetInstance(DataFlowCall call, string method) {
  exists(boolean exact |
    result = lookupInstanceMethodCall(call, method, exact) and
    (
      if result.(Method).isPrivate()
      then
        call.asCall().getReceiver().getExpr() instanceof SelfVariableAccess and
        // For now, we restrict the scope of top-level declarations to their file.
        // This may remove some plausible targets, but also removes a lot of
        // implausible targets
        (
          isToplevelMethodInFile(result, call.asCall().getFile()) or
          not isToplevelMethodInFile(result, _)
        )
      else any()
    ) and
    if result.(Method).isProtected()
    then
      result = lookupMethod(call.asCall().getExpr().getEnclosingModule().getModule(), method, exact)
    else any()
  )
}

private module TrackBlockInput implements CallGraphConstruction::Simple::InputSig {
  class State = Block;

  predicate start(DataFlow::Node start, Block block) { start.asExpr().getExpr() = block }

  // We exclude steps into `self` parameters, and instead rely on the type of the
  // enclosing module
  predicate filter(DataFlow::Node n) { n instanceof SelfParameterNodeImpl }
}

private predicate trackBlock = CallGraphConstruction::Simple::Make<TrackBlockInput>::track/1;

/** Holds if `m` is a singleton method named `name`, defined on `object. */
private predicate singletonMethod(MethodBase m, string name, Expr object) {
  name = m.getName() and
  (
    object = m.(SingletonMethod).getObject()
    or
    m = any(SingletonClass cls | object = cls.getValue()).getAMethod().(Method)
  )
}

pragma[nomagic]
private predicate flowsToSingletonMethodObject(
  DataFlow::LocalSourceNode nodeFrom, MethodBase m, string name
) {
  exists(DataFlow::Node nodeTo |
    nodeFrom.flowsTo(nodeTo) and
    singletonMethod(m, name, nodeTo.asExpr().getExpr())
  )
}

/**
 * Holds if `method` is a singleton method named `name`, defined on module
 * `m`:
 *
 * ```rb
 * class C
 *   def self.m1; end # included
 *
 *   class << self
 *     def m2; end # included
 *   end
 * end
 *
 * def C.m3; end # included
 *
 * c_alias = C
 * def c_alias.m4; end # included
 *
 * c = C.new
 * def c.m5; end # not included
 *
 * class << c
 *   def m6; end # not included
 * end
 *
 * module M
 *   def instance; end # included in `N` via `extend` call below
 * end
 * N.extend(M)
 * N.instance
 * ```
 */
pragma[nomagic]
private predicate singletonMethodOnModule(MethodBase method, string name, Module m) {
  exists(Expr object |
    singletonMethod(method, name, object) and
    selfInModule(object.(SelfVariableReadAccess).getVariable(), m)
  )
  or
  exists(DataFlow::LocalSourceNode sourceNode |
    m = Module::resolveConstantReadAccess(sourceNode.asExpr().getExpr()) and
    flowsToSingletonMethodObject(sourceNode, method, name)
  )
  or
  exists(Module other |
    extendCallModule(m, other) and
    method = lookupMethod(other, name)
  )
}

pragma[nomagic]
private MethodBase lookupSingletonMethodDirect(Module m, string name) {
  singletonMethodOnModule(result, name, m)
  or
  exists(DataFlow::LocalSourceNode sourceNode |
    sourceNode = trackModuleAccess(m) and
    not m = Module::resolveConstantReadAccess(sourceNode.asExpr().getExpr()) and
    flowsToSingletonMethodObject(sourceNode, result, name)
  )
}

/**
 * Holds if `method` is a singleton method named `name`, defined on module
 * `m`, or any transitive base class of `m`.
 */
pragma[nomagic]
private MethodBase lookupSingletonMethod(Module m, string name) {
  result = lookupSingletonMethodDirect(m, name)
  or
  // cannot use `lookupSingletonMethodDirect` because it would introduce
  // negative recursion
  not singletonMethodOnModule(_, name, m) and
  result = lookupSingletonMethod(m.getSuperClass(), name) // not `getAnImmediateAncestor` because singleton methods cannot be included
}

pragma[nomagic]
private MethodBase lookupSingletonMethodInSubClasses(Module m, string name) {
  // Singleton methods declared in a block in the top-level may spuriously end up being seen as singleton
  // methods on Object, if the block is actually evaluated in the context of another class.
  // The 'self' inside such a singleton method could then be any class, leading to self-calls
  // being resolved to arbitrary singleton methods.
  // To remedy this, we do not allow following super-classes all the way to Object.
  not m = Module::TResolved("Object") and
  exists(Module sub |
    sub.getSuperClass() = m // not `getAnImmediateAncestor` because singleton methods cannot be included
  |
    result = lookupSingletonMethodDirect(sub, name) or
    result = lookupSingletonMethodInSubClasses(sub, name)
  )
}

pragma[nomagic]
private MethodBase lookupSingletonMethod(Module m, string name, boolean exact) {
  result = lookupSingletonMethod(m, name) and
  exact in [false, true]
  or
  result = lookupSingletonMethodInSubClasses(m, name) and
  exact = false
}

/**
 * Holds if `method` is a singleton method named `name`, defined on expression
 * `object`, where `object` is not likely to resolve to a module:
 *
 * ```rb
 * class C
 *   def self.m1; end # not included
 *
 *   class << self
 *     def m2; end # not included
 *   end
 * end
 *
 * def C.m3; end # not included
 *
 * c_alias = C
 * def c_alias.m4; end # included (due to negative recursion limitation)
 *
 * c = C.new
 * def c.m5; end # included
 *
 * class << c
 *   def m6; end # included
 * end
 *
 * module M
 *   def instance; end # included in `c` via `extend` call below
 * end
 * c.extend(M)
 * ```
 */
pragma[nomagic]
predicate singletonMethodOnInstance(MethodBase method, string name, Expr object) {
  singletonMethod(method, name, object) and
  not selfInModule(object.(SelfVariableReadAccess).getVariable(), _) and
  // cannot use `trackModuleAccess` because of negative recursion
  not exists(Module::resolveConstantReadAccess(object))
  or
  exists(DataFlow::ExprNode receiver, Module other |
    extendCall(receiver, other) and
    object = receiver.getExprNode().getExpr() and
    method = lookupMethod(other, name)
  )
}

private module TrackSingletonMethodOnInstanceInput implements CallGraphConstruction::InputSig {
  /**
   * Holds if there is reverse flow from `nodeFrom` to `nodeTo` via a parameter.
   *
   * This is only used for tracking singleton methods, where we want to be able
   * to handle cases like
   *
   * ```rb
   * def add_singleton x
   *   def x.foo; end
   * end
   *
   * y = add_singleton C.new
   * y.foo
   * ```
   *
   * and
   *
   * ```rb
   * class C
   *   def add_singleton_to_self
   *     def self.foo; end
   *   end
   * end
   *
   * y = C.new
   * y.add_singleton_to_self
   * y.foo
   * ```
   */
  pragma[nomagic]
  private predicate paramReturnFlow(
    DataFlow::Node nodeFrom, DataFlow::PostUpdateNode nodeTo, StepSummary summary
  ) {
    exists(
      RelevantCall call, DataFlow::Node arg, DataFlow::ParameterNode p,
      CfgNodes::ExprCfgNode nodeFromPreExpr
    |
      sourceCallStep(call, arg, p) and
      nodeTo.getPreUpdateNode() = arg and
      summary.toString() = "return" and
      (
        nodeFromPreExpr = nodeFrom.(DataFlow::PostUpdateNode).getPreUpdateNode().asExpr()
        or
        nodeFromPreExpr = nodeFrom.asExpr() and
        singletonMethodOnInstance(_, _, nodeFromPreExpr.getExpr())
      )
    |
      nodeFromPreExpr = getParameterDef(p.getParameter()).getARead()
      or
      nodeFromPreExpr = p.(SelfParameterNodeImpl).getSelfDefinition().getARead()
    )
  }

  class State = MethodBase;

  predicate start(DataFlow::Node start, MethodBase method) {
    singletonMethodOnInstance(method, _, start.asExpr().getExpr())
  }

  predicate stepNoCall(DataFlow::Node nodeFrom, DataFlow::Node nodeTo, StepSummary summary) {
    smallStepNoCall(nodeFrom, nodeTo, summary)
    or
    localFlowStep(nodeFrom, nodeTo, summary)
  }

  predicate stepCall(DataFlow::Node nodeFrom, DataFlow::Node nodeTo, StepSummary summary) {
    smallStepCall(nodeFrom, nodeTo, summary)
    or
    paramReturnFlow(nodeFrom, nodeTo, summary)
  }

  class StateProj extends string {
    StateProj() { singletonMethodOnInstance(_, this, _) }
  }

  StateProj stateProj(MethodBase method) { singletonMethodOnInstance(method, result, _) }

  // Stop flow at redefinitions.
  //
  // Example:
  // ```rb
  // def x.foo; end
  // def x.foo; end
  // x.foo # <- we want to resolve this call to the second definition only
  // ```
  predicate filter(DataFlow::Node n, StateProj name) {
    singletonMethodOnInstance(_, name, n.asExpr().getExpr())
  }
}

pragma[nomagic]
private DataFlow::Node trackSingletonMethodOnInstance(MethodBase method, string name) {
  result = CallGraphConstruction::Make<TrackSingletonMethodOnInstanceInput>::track(method) and
  singletonMethodOnInstance(method, name, _)
}

/** Holds if a `self` access may be the receiver of `call` directly inside module `m`. */
pragma[nomagic]
private predicate selfInModuleFlowsToMethodCallReceiver(DataFlowCall call, Module m, string method) {
  exists(SelfLocalSourceNode self |
    flowsToMethodCallReceiver(call, self, method) and
    selfInModule(self.getVariable(), m)
  )
}

/**
 * Holds if a `self` access may be the receiver of `call` inside some singleton method, where
 * that method belongs to `m` or one of `m`'s transitive super classes.
 */
pragma[nomagic]
private predicate selfInSingletonMethodFlowsToMethodCallReceiver(
  DataFlowCall call, Module m, string method
) {
  exists(SelfLocalSourceNode self, MethodBase caller |
    flowsToMethodCallReceiver(call, self, method) and
    selfInMethod(self.getVariable(), caller, m) and
    singletonMethod(caller, _, _)
  )
}

pragma[nomagic]
private CfgScope getTargetSingleton(DataFlowCall call, string method) {
  // singleton method defined on an instance, e.g.
  // ```rb
  // c = C.new
  // def c.singleton; end # <- result
  // c.singleton          # <- call
  // ```
  // or an `extend`ed instance, e.g.
  // ```rb
  // c = C.new
  // module M
  //   def instance; end  # <- result
  // end
  // c.extend M
  // c.instance # <- call
  // ```
  exists(DataFlow::Node receiver |
    methodCall(call, receiver, method) and
    receiver = trackSingletonMethodOnInstance(result, method)
  )
  or
  // singleton method defined on a module
  // or an `extend`ed module, e.g.
  // ```rb
  // module M
  //   def instance; end  # <- result
  // end
  // M.extend(M)
  // M.instance           # <- call
  // ```
  exists(Module m, boolean exact | result = lookupSingletonMethod(m, method, exact) |
    // ```rb
    // def C.singleton; end # <- result
    // C.singleton          # <- call
    // ```
    moduleFlowsToMethodCallReceiver(call, m, method) and
    exact = true
    or
    // ```rb
    // class C
    //   def self.singleton; end # <- result
    //   self.singleton          # <- call
    // end
    // ```
    selfInModuleFlowsToMethodCallReceiver(call, m, method) and
    exact = true
    or
    // ```rb
    // class C
    //   def self.singleton; end # <- result
    //   def self.other
    //     self.singleton        # <- call
    //   end
    // end
    // ```
    selfInSingletonMethodFlowsToMethodCallReceiver(call, m, method) and
    exact = false
  )
}

/**
 * Holds if the parameter at position `pos` inside `encl` must flow to the receiver
 * of `call`, which targets a method named `name`.
 */
pragma[nomagic]
private predicate paramMustFlowToReceiver(
  ParameterPosition pos, DataFlowCall call, DataFlowCallable encl, string name
) {
  exists(ParameterNodeImpl p |
    // `p` is a parameter of `encl`,
    p.isParameterOf(encl, pos) and
    // the receiver of `call` references `p`
    exists(DataFlow::Node receiver |
      methodCall(pragma[only_bind_into](call), pragma[only_bind_into](receiver), name) and
      LocalFlow::localMustFlowStep*(p, receiver)
    )
  )
}

pragma[nomagic]
private predicate mayBenefitFromCallContext(
  DataFlowCall call, ParameterPosition pos, DataFlowCall ctx
) {
  paramMustFlowToReceiver(pos, call, viableCallable(ctx), _)
}

/**
 * Holds if the set of viable implementations that can be called by `call`
 * might be improved by knowing the call context.
 */
predicate mayBenefitFromCallContext(DataFlowCall call) { mayBenefitFromCallContext(call, _, _) }

/**
 * Holds if `ctx` targets the enclosing callable of `call`, the receiver of `call` is a
 * parameter access (at position `ppos`), where the corresponding argument of `ctx`
 * is `arg`.
 *
 * `name` is the name of the method being called by `call` and `source` is a
 * `LocalSourceNode` that flows to `arg`.
 */
pragma[nomagic]
private predicate argMustFlowToReceiver(
  RelevantCall ctx, DataFlow::LocalSourceNode source, DataFlow::Node arg, ParameterPosition ppos,
  DataFlowCall call, string name
) {
  exists(ArgumentPosition apos, DataFlowCallable encl |
    paramMustFlowToReceiver(ppos, call, encl, name) and
    parameterMatch(ppos, apos) and
    source.flowsTo(arg)
  |
    encl = viableSourceCallableNonInit(TNormalCall(ctx)) and
    arg.(ArgumentNode).sourceArgumentOf(ctx, apos)
    or
    encl.asCfgScope() = viableSourceCallableInit(ctx) and
    if apos.isSelf()
    then
      // when we are targeting an initializer, the type of `self` inside the
      // initializer will be the type of the `new` call itself, not the receiver
      // of the `new` call
      arg.asExpr() = ctx
    else arg.(ArgumentNode).sourceArgumentOf(ctx, apos)
    or
    ctx.getAstNode() = encl.asLibraryCallable().getACallSimple() and
    arg.(ArgumentNode).sourceArgumentOf(ctx, apos)
  )
}

pragma[nomagic]
private CfgScope viableImplInCallContextInitialize(RelevantCall call, RelevantCall ctx) {
  exists(Module m, DataFlow::LocalSourceNode source |
    argMustFlowToReceiver(ctx, pragma[only_bind_into](source), _, _, TNormalCall(call), "new") and
    source = trackModuleAccess(m) and
    result = getInitializeTarget(call) and
    result = lookupMethod(m, "initialize")
  )
}

pragma[nomagic]
private CfgScope viableImplInCallContextInstance(DataFlowCall call, RelevantCall ctx) {
  exists(Module m, DataFlow::LocalSourceNode source, string name, boolean exact |
    argMustFlowToReceiver(ctx, pragma[only_bind_into](source), _, _, pragma[only_bind_into](call),
      pragma[only_bind_into](name)) and
    source = trackInstance(m, exact) and
    result = getTargetInstance(call, pragma[only_bind_into](name)) and
    result = lookupMethod(m, pragma[only_bind_into](name), exact)
  )
}

pragma[nomagic]
private CfgScope viableImplInCallContextSingleton(DataFlowCall call, RelevantCall ctx) {
  exists(
    Module m, DataFlow::LocalSourceNode source, DataFlow::Node arg, string name, boolean exact
  |
    argMustFlowToReceiver(ctx, pragma[only_bind_into](source), arg, _, pragma[only_bind_into](call),
      pragma[only_bind_into](name)) and
    result = getTargetSingleton(call, pragma[only_bind_into](name)) and
    result = lookupSingletonMethod(m, pragma[only_bind_into](name), exact)
  |
    source = trackModuleAccess(m) and
    exact = true
    or
    exists(SelfVariable self | arg.asExpr().getExpr() = self.getAnAccess() |
      selfInModule(self, m) and
      exact = true
      or
      exists(MethodBase caller |
        selfInMethod(self, caller, m) and
        singletonMethod(caller, _, _) and
        exact = false
      )
    )
  )
}

/**
 * Gets a viable dispatch target of `call` in the context `ctx`. This is
 * restricted to those `call`s for which a context might make a difference.
 */
pragma[nomagic]
DataFlowCallable viableImplInCallContext(DataFlowCall call, DataFlowCall ctx) {
  // `ctx` can provide a potentially better type bound
  exists(CfgScope res | res = result.asCfgScope() |
    res = viableImplInCallContextInitialize(call.asCall(), ctx.asCall())
    or
    res = viableImplInCallContextInstance(call, ctx.asCall())
    or
    res = viableImplInCallContextSingleton(call, ctx.asCall())
  )
  or
  exists(ParameterPosition pos | mayBenefitFromCallContext(call, pos, ctx) |
    // `ctx` cannot provide a type bound, and the receiver of the call is `self`;
    // in this case, still apply an open-world assumption
    pos.isSelf() and
    result = viableSourceCallable(call) and
    not exists(RelevantCall ctx0 | ctx0 = ctx.asCall() |
      exists(viableImplInCallContextInitialize(call.asCall(), ctx0)) or
      exists(viableImplInCallContextInstance(call, ctx0)) or
      exists(viableImplInCallContextSingleton(call, ctx0))
    )
    or
    // library calls should always be able to resolve
    result = viableLibraryCallable(call)
  )
}

predicate exprNodeReturnedFrom = exprNodeReturnedFromCached/2;

/** A parameter position. */
class ParameterPosition extends TParameterPosition {
  /** Holds if this position represents a `self` parameter. */
  predicate isSelf() { this = TSelfParameterPosition() }

  /** Holds if this position represents a reference to a lambda itself. Only used for tracking flow through captured variables. */
  predicate isLambdaSelf() { this = TLambdaSelfParameterPosition() }

  /** Holds if this position represents a block parameter. */
  predicate isBlock() { this = TBlockParameterPosition() }

  /** Holds if this position represents a positional parameter at position `pos`. */
  predicate isPositional(int pos) { this = TPositionalParameterPosition(pos) }

  /** Holds if this position represents any positional parameter starting from position `pos`. */
  predicate isPositionalLowerBound(int pos) { this = TPositionalParameterLowerBoundPosition(pos) }

  /** Holds if this position represents a keyword parameter named `name`. */
  predicate isKeyword(string name) { this = TKeywordParameterPosition(name) }

  /** Holds if this position represents a hash-splat parameter. */
  predicate isHashSplat() { this = THashSplatParameterPosition() }

  /** Holds if this position represents a synthetic hash-splat parameter. */
  predicate isSynthHashSplat() { this = TSynthHashSplatParameterPosition() }

  /** Holds if this position represents a splat parameter at position `n`. */
  predicate isSplat(int n) { this = TSplatParameterPosition(n) }

  /**
   * Holds if this position represents a synthetic splat parameter.
   *
   * `actualSplatPos` indicates the position of the (unique) actual splat
   * parameter belonging to the same method, with `-1` representing no actual
   * splat parameter.
   */
  predicate isSynthSplat(int actualSplatPos) { this = TSynthSplatParameterPosition(actualSplatPos) }

  /**
   * Holds if this position represents any parameter, except `self` parameters. This
   * includes both positional, named, and block parameters.
   */
  predicate isAny() { this = TAnyParameterPosition() }

  /** Holds if this position represents any positional parameter. */
  predicate isAnyNamed() { this = TAnyKeywordParameterPosition() }

  /** Gets a textual representation of this position. */
  string toString() {
    this.isSelf() and result = "self"
    or
    this.isLambdaSelf() and result = "lambda self"
    or
    this.isBlock() and result = "block"
    or
    exists(int pos | this.isPositional(pos) and result = "position " + pos)
    or
    exists(int pos | this.isPositionalLowerBound(pos) and result = "position " + pos + "..")
    or
    exists(string name | this.isKeyword(name) and result = "keyword " + name)
    or
    this.isHashSplat() and result = "**"
    or
    this.isSynthHashSplat() and result = "synthetic **"
    or
    this.isAny() and result = "any"
    or
    this.isAnyNamed() and result = "any-named"
    or
    exists(int pos | this.isSplat(pos) and result = "* (position " + pos + ")")
    or
    exists(int actualSplatPos, string suffix |
      this.isSynthSplat(actualSplatPos) and
      result = "synthetic *" + suffix and
      if actualSplatPos = -1 then suffix = "" else suffix = " (actual at " + actualSplatPos + ")"
    )
  }
}

/** An argument position. */
class ArgumentPosition extends TArgumentPosition {
  /** Holds if this position represents a `self` argument. */
  predicate isSelf() { this = TSelfArgumentPosition() }

  /** Holds if this position represents a lambda `self` argument. Only used for tracking flow through captured variables. */
  predicate isLambdaSelf() { this = TLambdaSelfArgumentPosition() }

  /** Holds if this position represents a block argument. */
  predicate isBlock() { this = TBlockArgumentPosition() }

  /** Holds if this position represents a positional argument at position `pos`. */
  predicate isPositional(int pos) { this = TPositionalArgumentPosition(pos) }

  /** Holds if this position represents a keyword argument named `name`. */
  predicate isKeyword(string name) { this = TKeywordArgumentPosition(name) }

  /**
   * Holds if this position represents any argument, except `self` arguments. This
   * includes both positional, named, and block arguments.
   */
  predicate isAny() { this = TAnyArgumentPosition() }

  /** Holds if this position represents any positional parameter. */
  predicate isAnyNamed() { this = TAnyKeywordArgumentPosition() }

  /** Holds if this position represents a hash-splat argument. */
  predicate isHashSplat() { this = THashSplatArgumentPosition() }

  /** Holds if this position represents a synthetic hash-splat argument. */
  predicate isSynthHashSplat() { this = TSynthHashSplatArgumentPosition() }

  /** Holds if this position represents a splat argument at position `n`. */
  predicate isSplat(int n) { this = TSplatArgumentPosition(n) }

  /**
   * Holds if this position represents a synthetic splat argument.
   *
   * `actualSplatPos` indicates the position of the (unique) actual splat
   * argument belonging to the same call, with `-1` representing no actual
   * splat argument.
   */
  predicate isSynthSplat(int actualSplatPos) { this = TSynthSplatArgumentPosition(actualSplatPos) }

  /** Gets a textual representation of this position. */
  string toString() {
    this.isSelf() and result = "self"
    or
    this.isLambdaSelf() and result = "lambda self"
    or
    this.isBlock() and result = "block"
    or
    exists(int pos | this.isPositional(pos) and result = "position " + pos)
    or
    exists(string name | this.isKeyword(name) and result = "keyword " + name)
    or
    this.isAny() and result = "any"
    or
    this.isAnyNamed() and result = "any-named"
    or
    this.isHashSplat() and result = "**"
    or
    this.isSynthHashSplat() and result = "synthetic **"
    or
    exists(int pos | this.isSplat(pos) and result = "* (position " + pos + ")")
    or
    exists(int actualSplatPos, string suffix |
      this.isSynthSplat(actualSplatPos) and
      result = "synthetic *" + suffix and
      if actualSplatPos = -1 then suffix = "" else suffix = " (actual at " + actualSplatPos + ")"
    )
  }
}

pragma[nomagic]
private predicate parameterPositionIsNotSelf(ParameterPosition ppos) {
  not ppos.isSelf() and
  not ppos.isLambdaSelf()
}

pragma[nomagic]
private predicate argumentPositionIsNotSelf(ArgumentPosition apos) {
  not apos.isSelf() and
  not apos.isLambdaSelf()
}

/** Holds if arguments at position `apos` match parameters at position `ppos`. */
pragma[nomagic]
predicate parameterMatch(ParameterPosition ppos, ArgumentPosition apos) {
  ppos.isSelf() and apos.isSelf()
  or
  ppos.isLambdaSelf() and apos.isLambdaSelf()
  or
  ppos.isBlock() and apos.isBlock()
  or
  exists(int pos | ppos.isPositional(pos) and apos.isPositional(pos))
  or
  exists(int pos1, int pos2 |
    ppos.isPositionalLowerBound(pos1) and apos.isPositional(pos2) and pos2 >= pos1
  )
  or
  exists(string name | ppos.isKeyword(name) and apos.isKeyword(name))
  or
  (ppos.isHashSplat() or ppos.isSynthHashSplat()) and
  (apos.isHashSplat() or apos.isSynthHashSplat()) and
  // prevent synthetic hash-splat parameters from matching synthetic hash-splat
  // arguments when direct keyword matching is possible
  not (ppos.isSynthHashSplat() and apos.isSynthHashSplat())
  or
  exists(int pos |
    (
      ppos.isSplat(pos)
      or
      ppos.isSynthSplat(_) and
      pos = 0
    ) and
    (
      apos.isSplat(pos)
      or
      apos.isSynthSplat(_) and pos = 0
    )
  ) and
  // prevent synthetic splat parameters from matching synthetic splat arguments
  // when direct positional matching is possible
  not exists(int actualSplatPos |
    ppos.isSynthSplat(actualSplatPos) and
    apos.isSynthSplat(actualSplatPos)
  )
  or
  ppos.isAny() and argumentPositionIsNotSelf(apos)
  or
  apos.isAny() and parameterPositionIsNotSelf(ppos)
  or
  ppos.isAnyNamed() and apos.isKeyword(_)
  or
  apos.isAnyNamed() and ppos.isKeyword(_)
}

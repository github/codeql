private import ruby
private import codeql_ruby.CFG
private import DataFlowPrivate
private import codeql_ruby.typetracking.TypeTracker
private import codeql_ruby.dataflow.internal.DataFlowPublic as DataFlow
private import codeql_ruby.ast.internal.Module

newtype TReturnKind =
  TNormalReturnKind() or
  TBreakReturnKind()

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

class DataFlowCallable = CfgScope;

class DataFlowCall extends CfgNodes::ExprNodes::CallCfgNode {
  DataFlowCallable getEnclosingCallable() { result = this.getScope() }

  pragma[nomagic]
  private predicate methodCall(DataFlow::LocalSourceNode sourceNode, string method) {
    exists(DataFlow::Node nodeTo |
      method = this.getExpr().(MethodCall).getMethodName() and
      nodeTo.asExpr() = this.getReceiver() and
      sourceNode.flowsTo(nodeTo)
    )
  }

  private Block yieldCall() {
    this.getExpr() instanceof YieldCall and
    exists(BlockParameterNode node |
      node = trackBlock(result) and
      node.getMethod() = this.getExpr().getEnclosingMethod()
    )
  }

  pragma[nomagic]
  private predicate superCall(Module superClass, string method) {
    this.getExpr() instanceof SuperCall and
    exists(Module tp |
      tp = this.getExpr().getEnclosingModule().getModule() and
      superClass = tp.getSuperClass() and
      method = this.getExpr().getEnclosingMethod().getName()
    )
  }

  pragma[nomagic]
  private predicate instanceMethodCall(Module tp, string method) {
    exists(DataFlow::LocalSourceNode sourceNode |
      this.methodCall(sourceNode, method) and
      sourceNode = trackInstance(tp)
    )
  }

  cached
  DataFlowCallable getTarget() {
    exists(string method |
      exists(Module tp |
        this.instanceMethodCall(tp, method) and
        result = lookupMethod(tp, method) and
        if result.(Method).isPrivate()
        then
          exists(Self self |
            self = this.getReceiver().getExpr() and
            pragma[only_bind_out](self.getEnclosingModule().getModule().getSuperClass*()) =
              pragma[only_bind_out](result.getEnclosingModule().getModule())
          )
        else any()
      )
      or
      exists(DataFlow::LocalSourceNode sourceNode |
        this.methodCall(sourceNode, method) and
        sourceNode = trackSingletonMethod(result, method)
      )
    )
    or
    exists(Module superClass, string method |
      this.superCall(superClass, method) and
      result = lookupMethod(superClass, method)
    )
    or
    result = this.yieldCall()
  }
}

private DataFlow::LocalSourceNode trackInstance(Module tp, TypeTracker t) {
  t.start() and
  (
    result.asExpr().getExpr() instanceof NilLiteral and tp = TResolved("NilClass")
    or
    result.asExpr().getExpr().(BooleanLiteral).isFalse() and tp = TResolved("FalseClass")
    or
    result.asExpr().getExpr().(BooleanLiteral).isTrue() and tp = TResolved("TrueClass")
    or
    result.asExpr().getExpr() instanceof IntegerLiteral and tp = TResolved("Integer")
    or
    result.asExpr().getExpr() instanceof FloatLiteral and tp = TResolved("Float")
    or
    result.asExpr().getExpr() instanceof RationalLiteral and tp = TResolved("Rational")
    or
    result.asExpr().getExpr() instanceof ComplexLiteral and tp = TResolved("Complex")
    or
    result.asExpr().getExpr() instanceof StringlikeLiteral and tp = TResolved("String")
    or
    result.asExpr().getExpr() instanceof ArrayLiteral and tp = TResolved("Array")
    or
    result.asExpr().getExpr() instanceof HashLiteral and tp = TResolved("Hash")
    or
    result.asExpr().getExpr() instanceof MethodBase and tp = TResolved("Symbol")
    or
    result.asParameter() instanceof BlockParameter and tp = TResolved("Proc")
    or
    result.asExpr().getExpr() instanceof Lambda and tp = TResolved("Proc")
    or
    exists(CfgNodes::ExprNodes::CallCfgNode call, DataFlow::Node nodeTo |
      call.getExpr().(MethodCall).getMethodName() = "new" and
      nodeTo.asExpr() = call.getReceiver() and
      trackModule(tp).flowsTo(nodeTo) and
      result.asExpr() = call
    )
    or
    // `self` in method
    exists(Self self, Method enclosing |
      self = result.asExpr().getExpr() and
      enclosing = self.getEnclosingMethod() and
      tp = enclosing.getEnclosingModule().getModule() and
      not self.getEnclosingModule().getEnclosingMethod() = enclosing
    )
    or
    // `self` in singleton method
    exists(Self self, MethodBase enclosing |
      self = result.asExpr().getExpr() and
      flowsToSingletonMethodObject(trackInstance(tp), enclosing) and
      enclosing = self.getEnclosingMethod() and
      not self.getEnclosingModule().getEnclosingMethod() = enclosing
    )
    or
    // `self` in top-level
    exists(Self self, Toplevel enclosing |
      self = result.asExpr().getExpr() and
      enclosing = self.getEnclosingModule() and
      tp = TMain(enclosing) and
      not self.getEnclosingMethod().getEnclosingModule() = enclosing
    )
    or
    // a module or class
    exists(Module m |
      result = trackModule(m) and
      if m.isClass() then tp = TResolved("Class") else tp = TResolved("Module")
    )
  )
  or
  exists(TypeTracker t2, StepSummary summary |
    result = trackInstanceRec(tp, t2, summary) and t = t2.append(summary)
  )
}

pragma[nomagic]
private DataFlow::LocalSourceNode trackInstanceRec(Module tp, TypeTracker t, StepSummary summary) {
  StepSummary::step(trackInstance(tp, t), result, summary)
}

private DataFlow::LocalSourceNode trackInstance(Module tp) {
  result = trackInstance(tp, TypeTracker::end())
}

private DataFlow::LocalSourceNode trackBlock(Block block, TypeTracker t) {
  t.start() and result.asExpr().getExpr() = block
  or
  exists(TypeTracker t2, StepSummary summary |
    result = trackBlockRec(block, t2, summary) and t = t2.append(summary)
  )
}

pragma[nomagic]
private DataFlow::LocalSourceNode trackBlockRec(Block block, TypeTracker t, StepSummary summary) {
  StepSummary::step(trackBlock(block, t), result, summary)
}

private DataFlow::LocalSourceNode trackBlock(Block block) {
  result = trackBlock(block, TypeTracker::end())
}

private predicate singletonMethod(MethodBase method, Expr object) {
  object = method.(SingletonMethod).getObject()
  or
  exists(SingletonClass cls |
    object = cls.getValue() and method instanceof Method and method = cls.getAMethod()
  )
}

pragma[nomagic]
private predicate flowsToSingletonMethodObject(DataFlow::LocalSourceNode nodeFrom, MethodBase method) {
  exists(DataFlow::LocalSourceNode nodeTo |
    nodeFrom.flowsTo(nodeTo) and
    singletonMethod(method, nodeTo.asExpr().getExpr())
  )
}

pragma[nomagic]
private predicate moduleFlowsToSingletonMethodObject(Module m, MethodBase method) {
  flowsToSingletonMethodObject(trackModule(m), method)
}

pragma[nomagic]
private DataFlow::LocalSourceNode trackSingletonMethod0(MethodBase method, TypeTracker t) {
  t.start() and
  (
    flowsToSingletonMethodObject(result, method)
    or
    exists(Module m | result = trackModule(m) and moduleFlowsToSingletonMethodObject(m, method))
  )
  or
  exists(TypeTracker t2, StepSummary summary |
    result = trackSingletonMethod0Rec(method, t2, summary) and t = t2.append(summary)
  )
}

pragma[nomagic]
private DataFlow::LocalSourceNode trackSingletonMethod0Rec(
  MethodBase method, TypeTracker t, StepSummary summary
) {
  StepSummary::step(trackSingletonMethod0(method, t), result, summary)
}

pragma[nomagic]
private DataFlow::LocalSourceNode trackSingletonMethod(MethodBase m, string name) {
  result = trackSingletonMethod0(m, TypeTracker::end()) and
  name = m.getName()
}

private DataFlow::Node selfInModule(Module tp) {
  exists(Self self, ModuleBase enclosing |
    self = result.asExpr().getExpr() and
    enclosing = self.getEnclosingModule() and
    tp = enclosing.getModule() and
    not self.getEnclosingMethod().getEnclosingModule() = enclosing
  )
}

private DataFlow::LocalSourceNode trackModule(Module tp, TypeTracker t) {
  t.start() and
  (
    // ConstantReadAccess to Module
    resolveScopeExpr(result.asExpr().getExpr()) = tp
    or
    // `self` reference to Module
    result = selfInModule(tp)
  )
  or
  exists(TypeTracker t2, StepSummary summary |
    result = trackModuleRec(tp, t2, summary) and t = t2.append(summary)
  )
}

pragma[nomagic]
private DataFlow::LocalSourceNode trackModuleRec(Module tp, TypeTracker t, StepSummary summary) {
  StepSummary::step(trackModule(tp, t), result, summary)
}

private DataFlow::LocalSourceNode trackModule(Module tp) {
  result = trackModule(tp, TypeTracker::end())
}

/** Gets a viable run-time target for the call `call`. */
DataFlowCallable viableCallable(DataFlowCall call) {
  result = call.getTarget() and
  not call.getExpr() instanceof YieldCall // handled by `lambdaCreation`/`lambdaCall`
}

/**
 * Holds if the set of viable implementations that can be called by `call`
 * might be improved by knowing the call context. This is the case if the
 * qualifier accesses a parameter of the enclosing callable `c` (including
 * the implicit `self` parameter).
 */
predicate mayBenefitFromCallContext(DataFlowCall call, Callable c) { none() }

/**
 * Gets a viable dispatch target of `call` in the context `ctx`. This is
 * restricted to those `call`s for which a context might make a difference.
 */
DataFlowCallable viableImplInCallContext(DataFlowCall call, DataFlowCall ctx) { none() }

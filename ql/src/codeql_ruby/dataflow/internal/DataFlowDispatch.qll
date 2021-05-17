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
        result = lookupMethod(tp, method)
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
    exists(Self self, MethodBase enclosing, DataFlow::Node objectNode |
      self = result.asExpr().getExpr() and
      singletonMethod(enclosing, objectNode.asExpr().getExpr()) and
      enclosing = self.getEnclosingMethod() and
      trackInstance(tp).flowsTo(objectNode) and
      not self.getEnclosingModule().getEnclosingMethod() = enclosing
    )
    or
    // `self` in top-level
    exists(Self self, Toplevel enclosing |
      self = result.asExpr().getExpr() and
      enclosing = self.getEnclosingModule() and
      tp = TResolved("Object") and
      not self.getEnclosingMethod().getEnclosingModule() = enclosing
    )
    or
    // a module or class
    exists(Module m |
      result = trackModule(m) and
      if m.getADeclaration() instanceof ClassDeclaration
      then tp = TResolved("Class")
      else tp = TResolved("Module")
    )
  )
  or
  exists(TypeTracker t2 | result = trackInstance(tp, t2).track(t2, t))
}

private DataFlow::LocalSourceNode trackInstance(Module tp) {
  result = trackInstance(tp, TypeTracker::end())
}

private DataFlow::LocalSourceNode trackBlock(Block block, TypeTracker t) {
  t.start() and result.asExpr().getExpr() = block
  or
  exists(TypeTracker t2 | result = trackBlock(block, t2).track(t2, t))
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
private DataFlow::LocalSourceNode trackSingletonMethod0(MethodBase method, TypeTracker t) {
  t.start() and
  exists(DataFlow::Node nodeTo | singletonMethod(method, nodeTo.asExpr().getExpr()) |
    result.flowsTo(nodeTo)
    or
    exists(Module m | result = trackModule(m) and trackModule(m).flowsTo(nodeTo))
  )
  or
  exists(TypeTracker t2 | result = trackSingletonMethod0(method, t2).track(t2, t))
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
  exists(TypeTracker t2 | result = trackModule(tp, t2).track(t2, t))
}

private DataFlow::LocalSourceNode trackModule(Module tp) {
  result = trackModule(tp, TypeTracker::end())
}

/** Gets a viable run-time target for the call `call`. */
DataFlowCallable viableCallable(DataFlowCall call) { result = call.getTarget() }

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

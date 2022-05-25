private import go
private import DataFlowUtil
private import DataFlowImplCommon
private import ContainerFlow
private import FlowSummaryImpl as FlowSummaryImpl
import DataFlowNodes::Private

private newtype TReturnKind =
  MkReturnKind(int i) { exists(SignatureType st | exists(st.getResultType(i))) }

ReturnKind getReturnKind(int i) { result = MkReturnKind(i) }

/**
 * A return kind. A return kind describes how a value can be returned
 * from a callable. For Go, this is either a return of a single value
 * or of one of multiple values.
 */
class ReturnKind extends TReturnKind {
  int i;

  ReturnKind() { this = MkReturnKind(i) }

  /** Gets the index of this return value. */
  int getIndex() { result = i }

  /** Gets a textual representation of this return kind. */
  string toString() { result = "return[" + i + "]" }
}

/**
 * Gets a node that can read the value returned from `call` with return kind
 * `kind`.
 */
OutNode getAnOutNode(DataFlowCall call, ReturnKind kind) {
  exists(DataFlow::CallNode c, int i | c.asExpr() = call and kind = MkReturnKind(i) |
    result = c.getResult(i)
  )
}

/**
 * Holds if data flows from `nodeFrom` to `nodeTo` in exactly one local
 * (intra-procedural) step, not taking function models into account.
 */
predicate basicLocalFlowStep(Node nodeFrom, Node nodeTo) {
  // Instruction -> Instruction
  exists(Expr pred, Expr succ |
    succ.(LogicalBinaryExpr).getAnOperand() = pred or
    succ.(ConversionExpr).getOperand() = pred
  |
    nodeFrom = exprNode(pred) and
    nodeTo = exprNode(succ)
  )
  or
  // Type assertion: if in the context `checked, ok := e.(*Type)` (in which
  // case tuple-extraction instructions exist), flow from `e` to `e.(*Type)[0]`;
  // otherwise flow from `e` to `e.(*Type)`.
  exists(IR::Instruction evalAssert, TypeAssertExpr assert |
    nodeFrom.asExpr() = assert.getExpr() and
    evalAssert = IR::evalExprInstruction(assert) and
    if exists(IR::extractTupleElement(evalAssert, _))
    then nodeTo.asInstruction() = IR::extractTupleElement(evalAssert, 0)
    else nodeTo.asInstruction() = evalAssert
  )
  or
  // Instruction -> SSA
  exists(IR::Instruction pred, SsaExplicitDefinition succ |
    succ.getRhs() = pred and
    nodeFrom = instructionNode(pred) and
    nodeTo = ssaNode(succ)
  )
  or
  // SSA -> SSA
  exists(SsaDefinition pred, SsaDefinition succ |
    succ.(SsaVariableCapture).getSourceVariable() = pred.(SsaExplicitDefinition).getSourceVariable() or
    succ.(SsaPseudoDefinition).getAnInput() = pred
  |
    nodeFrom = ssaNode(pred) and
    nodeTo = ssaNode(succ)
  )
  or
  // SSA -> Instruction
  exists(SsaDefinition pred, IR::Instruction succ |
    succ = pred.getVariable().getAUse() and
    nodeFrom = ssaNode(pred) and
    nodeTo = instructionNode(succ)
  )
  or
  // GlobalFunctionNode -> use
  nodeFrom =
    any(GlobalFunctionNode fn | fn.getFunction() = nodeTo.asExpr().(FunctionName).getTarget())
}

/**
 * Holds if data can flow from `node1` to `node2` in a way that loses the
 * calling context. For example, this would happen with flow through a
 * global or static variable.
 */
predicate jumpStep(Node n1, Node n2) {
  exists(ValueEntity v, Write w |
    not v instanceof SsaSourceVariable and
    not v instanceof Field and
    w.writes(v, n1) and
    n2 = v.getARead()
  )
}

/**
 * Holds if data can flow from `node1` to `node2` via an assignment to `c`.
 * Thus, `node2` references an object with a content `x` that contains the
 * value of `node1`.
 */
predicate storeStep(Node node1, Content c, Node node2) {
  // a write `(*p).f = rhs` is modelled as two store steps: `rhs` is flows into field `f` of `(*p)`,
  // which in turn flows into the pointer content of `p`
  exists(Write w, Field f, DataFlow::Node base, DataFlow::Node rhs | w.writesField(base, f, rhs) |
    node1 = rhs and
    node2.(PostUpdateNode).getPreUpdateNode() = base and
    c = any(DataFlow::FieldContent fc | fc.getField() = f)
    or
    node1 = base and
    node2.(PostUpdateNode).getPreUpdateNode() = node1.(PointerDereferenceNode).getOperand() and
    c = any(DataFlow::PointerContent pc | pc.getPointerType() = node2.getType())
  )
  or
  node1 = node2.(AddressOperationNode).getOperand() and
  c = any(DataFlow::PointerContent pc | pc.getPointerType() = node2.getType())
  or
  FlowSummaryImpl::Private::Steps::summaryStoreStep(node1, c, node2)
  or
  containerStoreStep(node1, node2, c)
}

/**
 * Holds if data can flow from `node1` to `node2` via a read of `c`.
 * Thus, `node1` references an object with a content `c` whose value ends up in
 * `node2`.
 */
predicate readStep(Node node1, Content c, Node node2) {
  node1 = node2.(PointerDereferenceNode).getOperand() and
  c = any(DataFlow::PointerContent pc | pc.getPointerType() = node1.getType())
  or
  exists(FieldReadNode read |
    node2 = read and
    node1 = read.getBase() and
    c = any(DataFlow::FieldContent fc | fc.getField() = read.getField())
  )
  or
  FlowSummaryImpl::Private::Steps::summaryReadStep(node1, c, node2)
  or
  containerReadStep(node1, node2, c)
}

/**
 * Holds if values stored inside content `c` are cleared at node `n`.
 */
predicate clearsContent(Node n, Content c) {
  // Because our post-update nodes are shared between multiple pre-update
  // nodes, attempting to clear content causes summary stores into arg in
  // particular to malfunction.
  none()
  // c instanceof FieldContent and
  // FlowSummaryImpl::Private::Steps::summaryStoresIntoArg(c, n)
  // or
  // FlowSummaryImpl::Private::Steps::summaryClearsContent(n, c)
}

/** Gets the type of `n` used for type pruning. */
DataFlowType getNodeType(Node n) {
  result = n.getType()
  or
  result = FlowSummaryImpl::Private::summaryNodeType(n)
}

/** Gets a string representation of a type returned by `getNodeType()`. */
string ppReprType(Type t) { result = t.toString() }

/**
 * Holds if `t1` and `t2` are compatible, that is, whether data can flow from
 * a node of type `t1` to a node of type `t2`.
 */
pragma[inline]
predicate compatibleTypes(Type t1, Type t2) {
  any() // stub implementation
}

//////////////////////////////////////////////////////////////////////////////
// Java QL library compatibility wrappers
//////////////////////////////////////////////////////////////////////////////
/** A node that performs a type cast. */
class CastNode extends ExprNode {
  override ConversionExpr expr;
}

class DataFlowExpr = Expr;

class DataFlowType = Type;

class DataFlowLocation = Location;

private newtype TDataFlowCallable =
  TCallable(Callable c) or
  TFileScope(File f)

class DataFlowCallable extends TDataFlowCallable {
  Callable asCallable() { this = TCallable(result) }

  File asFileScope() { this = TFileScope(result) }

  FuncDef getFuncDef() { result = this.asCallable().getFuncDef() }

  Function asFunction() { result = this.asCallable().asFunction() }

  FuncLit asFuncLit() { result = this.asCallable().asFuncLit() }

  SignatureType getType() { result = this.asCallable().getType() }

  string toString() {
    result = this.asCallable().toString() or
    result = "File scope: " + this.asFileScope().toString()
  }

  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.asCallable().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn) or
    this.asFileScope().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

/** A function call relevant for data flow. */
class DataFlowCall extends Expr {
  DataFlow::CallNode call;

  DataFlowCall() { this = call.asExpr() }

  /**
   * Gets the nth argument for this call.
   */
  Node getArgument(int n) { result = call.getArgument(n) }

  /** Gets the data flow node corresponding to this call. */
  ExprNode getNode() { result = call }

  /** Gets the enclosing callable of this call. */
  DataFlowCallable getEnclosingCallable() {
    result.asCallable().getFuncDef() = this.getEnclosingFunction()
    or
    not exists(this.getEnclosingFunction()) and result.asFileScope() = this.getFile()
  }
}

/** Holds if `e` is an expression that always has the same Boolean value `val`. */
private predicate constantBooleanExpr(Expr e, boolean val) {
  e.getBoolValue() = val
  or
  exists(SsaExplicitDefinition v, Expr src |
    IR::evalExprInstruction(e) = v.getVariable().getAUse() and
    IR::evalExprInstruction(src) = v.getRhs() and
    constantBooleanExpr(src, val)
  )
}

/** An argument that always has the same Boolean value. */
private class ConstantBooleanArgumentNode extends ArgumentNode, ExprNode {
  ConstantBooleanArgumentNode() { constantBooleanExpr(this.getExpr(), _) }

  /** Gets the Boolean value of this expression. */
  boolean getBooleanValue() { constantBooleanExpr(this.getExpr(), result) }
}

/**
 * Returns a guard that will certainly not hold in calling context `call`.
 *
 * In particular it does not hold because it checks that `param` has value `b`, but
 * in context `call` it is known to have value `!b`. Note this is `noinline`d in order
 * to avoid a bad join order in `isUnreachableInCall`.
 */
pragma[noinline]
private ControlFlow::ConditionGuardNode getAFalsifiedGuard(DataFlowCall call) {
  exists(SsaParameterNode param, ConstantBooleanArgumentNode arg |
    // get constant bool argument and parameter for this call
    viableParamArg(call, pragma[only_bind_into](param), pragma[only_bind_into](arg)) and
    // which is used in a guard controlling `n` with the opposite value of `arg`
    result.ensures(param.getAUse(), arg.getBooleanValue().booleanNot())
  )
}

/**
 * Holds if the node `n` is unreachable when the call context is `call`.
 */
predicate isUnreachableInCall(Node n, DataFlowCall call) {
  getAFalsifiedGuard(call).dominates(n.getBasicBlock())
}

int accessPathLimit() { result = 5 }

/**
 * Holds if access paths with `c` at their head always should be tracked at high
 * precision. This disables adaptive access path precision for such access paths.
 */
predicate forceHighPrecision(Content c) {
  c instanceof ArrayContent or c instanceof CollectionContent
}

/** The unit type. */
private newtype TUnit = TMkUnit()

/** The trivial type with a single element. */
class Unit extends TUnit {
  /** Gets a textual representation of this element. */
  string toString() { result = "unit" }
}

/**
 * Gets the `i`th argument of call `c`, where the receiver of a method call
 * counts as argument -1.
 */
Node getArgument(CallNode c, int i) {
  result = c.getArgument(i)
  or
  result = c.(MethodCallNode).getReceiver() and
  i = -1
}

/** Holds if `n` should be hidden from path explanations. */
predicate nodeIsHidden(Node n) { none() }

class LambdaCallKind = Unit;

/** Holds if `creation` is an expression that creates a lambda of kind `kind` for `c`. */
predicate lambdaCreation(Node creation, LambdaCallKind kind, DataFlowCallable c) { none() }

/** Holds if `call` is a lambda call of kind `kind` where `receiver` is the lambda expression. */
predicate lambdaCall(DataFlowCall call, LambdaCallKind kind, Node receiver) { none() }

/** Extra data-flow steps needed for lambda flow analysis. */
predicate additionalLambdaFlowStep(Node nodeFrom, Node nodeTo, boolean preservesValue) { none() }

/**
 * Holds if flow is allowed to pass from parameter `p` and back to itself as a
 * side-effect, resulting in a summary from `p` to itself.
 *
 * One example would be to allow flow like `p.foo = p.bar;`, which is disallowed
 * by default as a heuristic.
 */
predicate allowParameterReturnInSelf(ParameterNode p) {
  FlowSummaryImpl::Private::summaryAllowParameterReturnInSelf(p)
}

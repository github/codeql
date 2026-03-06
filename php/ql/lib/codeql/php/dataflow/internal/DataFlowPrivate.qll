/**
 * Provides PHP-specific data flow implementation details.
 */

private import codeql.php.AST
private import DataFlowPublic
private import DataFlowDispatch
private import SsaImpl as Ssa
private import codeql.php.controlflow.ControlFlowGraph as Cfg
private import codeql.php.controlflow.BasicBlocks as BasicBlocks
private import codeql.php.controlflow.internal.ControlFlowGraphImpl as CfgImpl

/** Gets the callable in which this node occurs. */
DataFlowCallable nodeGetEnclosingCallable(Node n) {
  result = TCallable(n.asExpr().getParent*().(Callable))
  or
  result = TCallable(n.asParameter().getParent*().(Callable))
  or
  // File-level code: node is inside a Program but not inside any Callable
  not n.asExpr().getParent*() instanceof Callable and
  result = TProgram(n.asExpr().getParent*().(Program))
  or
  // SSA definition node: use the scope of the SSA variable
  exists(Ssa::Definition def, Ssa::SsaSourceVariable v |
    n = TSsaDefinitionNode(def) and
    def.definesAt(v, _, _)
  |
    result = TCallable(v.getScope().(Callable))
    or
    not v.getScope() instanceof Callable and
    result = TProgram(v.getScope().(Program))
  )
}

/** Holds if `p` is a `ParameterNode` of `c` with position `pos`. */
predicate isParameterNode(ParameterNode p, DataFlowCallable c, ParameterPosition pos) {
  exists(Callable callable, int i |
    callable = c.asCallable() and
    callable.getParameter(i) = p.getParameter() and
    pos = TPositionalParameterPosition(i)
  )
}

/** Holds if `arg` is an `ArgumentNode` of `c` with position `pos`. */
predicate isArgumentNode(ArgumentNode arg, DataFlowCall c, ArgumentPosition pos) {
  exists(Call call, int i |
    call = c.asCall() and
    call.getArgument(i) = arg.asExpr() and
    pos = TPositionalArgumentPosition(i)
  )
}

newtype TNode =
  TExprNode(Expr e) or
  TParameterNode(Parameter p) or
  TSsaDefinitionNode(Ssa::Definition def) or
  TPostUpdateNode(Expr e) { isPostUpdateExpr(e) }

private predicate isPostUpdateExpr(Expr e) {
  // Arguments of calls that may be modified
  exists(Call c | c.getAnArgument() = e)
  or
  // Receiver of method calls
  e = any(MethodCallExpr mc).getObject()
  or
  e = any(NullsafeMethodCallExpr mc).getObject()
  or
  e = any(MemberAccessExpr ma).getObject()
}

/** The data flow type. */
class DataFlowType extends string {
  DataFlowType() { this = "" }

  string toString() { result = this }
}

predicate compatibleTypes(DataFlowType t1, DataFlowType t2) { any() }

predicate typeStrongerThan(DataFlowType t1, DataFlowType t2) { none() }

DataFlowType getNodeType(Node node) { exists(node) and result = "" }

predicate nodeIsHidden(Node node) { node instanceof SsaDefinitionNode }

/**
 * Holds if data flows from `nodeFrom` to `nodeTo` in exactly one local step.
 */
predicate simpleLocalFlowStep(Node nodeFrom, Node nodeTo, string model) {
  model = "" and
  (
    // Assignment: value flows from RHS to LHS
    exists(AssignExpr assign |
      nodeFrom.asExpr() = assign.getRightOperand() and
      nodeTo.asExpr() = assign.getLeftOperand()
    )
    or
    // SSA flow: from a variable write to the SSA definition
    exists(Ssa::WriteDefinition def, BasicBlocks::BasicBlock bb, int i, VariableName vn |
      def.definesAt(_, bb, i) and
      bb.getNode(i).getAstNode() = vn and
      nodeFrom.asExpr() = vn and
      nodeTo = TSsaDefinitionNode(def) and
      exists(AssignExpr assign | assign.getLeftOperand() = vn)
    )
    or
    // SSA flow: from an SSA definition to each read of the same variable
    exists(Ssa::Definition def, BasicBlocks::BasicBlock bb, int i, VariableName vn |
      ssaDefReachesRead(def, bb, i) and
      bb.getNode(i).getAstNode() = vn and
      nodeFrom = TSsaDefinitionNode(def) and
      nodeTo.asExpr() = vn
    )
    or
    // SSA flow: phi node from input definitions
    exists(Ssa::PhiNode phi, Ssa::Definition input |
      input = Ssa::phiHasInputFromBlock(phi, _) and
      nodeFrom = TSsaDefinitionNode(input) and
      nodeTo = TSsaDefinitionNode(phi)
    )
    or
    // Parenthesized expression: value flows through
    exists(ParenExpr paren |
      nodeFrom.asExpr() = paren.getExpr() and
      nodeTo.asExpr() = paren
    )
    or
    // Conditional expression: value flows from branches
    exists(ConditionalExpr cond |
      (
        nodeFrom.asExpr() = cond.getConsequence() or
        nodeFrom.asExpr() = cond.getAlternative()
      ) and
      nodeTo.asExpr() = cond
    )
  )
}

/**
 * Holds if SSA definition `def` reaches a read at position `i` in basic block `bb`.
 */
private predicate ssaDefReachesRead(
  Ssa::Definition def, BasicBlocks::BasicBlock bb, int i
) {
  exists(Ssa::SsaSourceVariable v |
    def.definesAt(v, _, _) and
    Ssa::SsaInput::variableRead(bb, i, v, _) and
    Ssa::getARead(def) = bb.getNode(i)
  )
}

/** A type of data-flow content. */
newtype TContent =
  TArrayElementContent() or
  TPropertyContent(string name) { exists(MemberAccessExpr ma | ma.getName().getValue() = name) }

/** Data flow content (field, array element, etc.). */
class Content extends TContent {
  string toString() {
    this = TArrayElementContent() and result = "ArrayElement"
    or
    exists(string name | this = TPropertyContent(name) and result = "Property[" + name + "]")
  }
}

class ContentApprox extends TContent {
  string toString() { result = this.(Content).toString() }
}

ContentApprox getContentApprox(Content c) { result = c }

predicate forceHighPrecision(Content c) { none() }

predicate readStep(Node node1, ContentSet c, Node node2) {
  // Property read: $obj->prop
  exists(MemberAccessExpr ma |
    node1.asExpr() = ma.getObject() and
    node2.asExpr() = ma and
    c = TPropertyContent(ma.getName().getValue())
  )
  or
  // Array read: $arr[idx]
  exists(SubscriptExpr sub |
    node1.asExpr() = sub.getObject() and
    node2.asExpr() = sub and
    c = TArrayElementContent()
  )
}

predicate storeStep(Node node1, ContentSet c, Node node2) {
  // Property write: $obj->prop = value
  exists(AssignExpr assign, MemberAccessExpr ma |
    ma = assign.getLeftOperand() and
    node1.asExpr() = assign.getRightOperand() and
    node2 = TPostUpdateNode(ma.getObject()) and
    c = TPropertyContent(ma.getName().getValue())
  )
  or
  // Array write: $arr[idx] = value
  exists(AssignExpr assign, SubscriptExpr sub |
    sub = assign.getLeftOperand() and
    node1.asExpr() = assign.getRightOperand() and
    node2 = TPostUpdateNode(sub.getObject()) and
    c = TArrayElementContent()
  )
}

predicate clearsContent(Node n, ContentSet c) { none() }

predicate expectsContent(Node n, ContentSet c) { none() }

predicate jumpStep(Node node1, Node node2) { none() }

class NodeRegion instanceof string {
  NodeRegion() { this = "NodeRegion" }

  predicate contains(Node n) { none() }

  string toString() { result = this }
}

predicate isUnreachableInCall(NodeRegion nr, DataFlowCall call) { none() }

predicate allowParameterReturnInSelf(ParameterNode p) { none() }

predicate localMustFlowStep(Node node1, Node node2) {
  exists(AssignExpr assign |
    node1.asExpr() = assign.getRightOperand() and
    node2.asExpr() = assign.getLeftOperand()
  )
}

class LambdaCallKind extends string {
  LambdaCallKind() { this = "closure" }
}

predicate lambdaCreation(Node creation, LambdaCallKind kind, DataFlowCallable c) { none() }

predicate lambdaCall(DataFlowCall call, LambdaCallKind kind, Node receiver) { none() }

predicate additionalLambdaFlowStep(Node nodeFrom, Node nodeTo, boolean preservesValue) { none() }

predicate knownSourceModel(Node source, string model) { none() }

predicate knownSinkModel(Node sink, string model) { none() }

predicate neverSkipInPathGraph(Node n) { none() }

class DataFlowSecondLevelScope extends string {
  DataFlowSecondLevelScope() { this = "" }

  string toString() { result = this }
}

/** The type of data flow expressions. */
class DataFlowExpr = Expr;

/** An argument node. */
class ArgumentNode extends ExprNode {
  private Call call;

  ArgumentNode() { call.getAnArgument() = this.asExpr() }

  predicate argumentOf(DataFlowCall c, ArgumentPosition pos) {
    exists(int i |
      call = c.asCall() and
      call.getArgument(i) = this.getExpr() and
      pos = TPositionalArgumentPosition(i)
    )
  }
}

/** A return node. */
class ReturnNode extends ExprNode {
  ReturnStmt ret;

  ReturnNode() { this.getExpr() = ret.getValue() }

  ReturnKind getKind() { result instanceof NormalReturnKind }
}

/** An out node (at a call site, reading return values). */
class OutNode extends ExprNode {
  OutNode() { this.getExpr() instanceof Call }

  DataFlowCall getCall(ReturnKind kind) {
    result.asCall() = this.getExpr() and
    kind instanceof NormalReturnKind
  }
}

class CastNode extends Node {
  CastNode() { this.asExpr() instanceof CastExpr }
}

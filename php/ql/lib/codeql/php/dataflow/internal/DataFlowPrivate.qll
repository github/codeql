/**
 * Provides private implementation details for PHP data flow.
 */

private import codeql.php.ast.internal.TreeSitter as TS
private import codeql.Locations as L
import DataFlowPublic


/**
 * Newtype for data flow nodes.
 */
newtype TNode =
  TExprNode(TS::PHP::Expression e) or
  TParameterNode(TS::PHP::SimpleParameter p) or
  TArgumentNode(TS::PHP::Argument a) or
  TReturnNode(TS::PHP::ReturnStatement r) or
  TOutNode(TS::PHP::Expression call) {
    call instanceof TS::PHP::FunctionCallExpression or
    call instanceof TS::PHP::MemberCallExpression
  } or
  TPostUpdateNode(Node pre) { pre instanceof ExprNode } or
  TCastNode(TS::PHP::CastExpression c)

/**
 * Newtype for data flow callables.
 */
newtype TDataFlowCallable =
  TFunctionCallable(TS::PHP::FunctionDefinition f) or
  TMethodCallable(TS::PHP::MethodDeclaration m)

/**
 * Newtype for data flow calls.
 */
newtype TDataFlowCall =
  TFunctionCall(TS::PHP::FunctionCallExpression call) or
  TMethodCall(TS::PHP::MemberCallExpression call)

/**
 * Newtype for return kinds.
 */
newtype TReturnKind = TNormalReturn()

/**
 * Newtype for parameter positions.
 */
newtype TParameterPosition = TPositionalParameter(int pos) { pos in [0 .. 20] }

/**
 * Newtype for argument positions.
 */
newtype TArgumentPosition = TPositionalArgument(int pos) { pos in [0 .. 20] }

/**
 * Newtype for data flow types.
 */
newtype TDataFlowType = TAnyType()

/**
 * Newtype for content.
 */
newtype TContent =
  TArrayContent() or
  TFieldContent(string name) { exists(TS::PHP::PropertyElement p | name = p.toString()) }

/**
 * Newtype for content sets.
 */
newtype TContentSet =
  TSingletonContentSet(Content c) or
  TAnyContentSet()

/**
 * Newtype for content approximations.
 */
newtype TContentApprox =
  TArrayApprox() or
  TFieldApprox()

/**
 * Base class for node implementations.
 */
abstract class NodeImpl extends Node {
  /** Gets the enclosing callable. */
  abstract DataFlowCallable getEnclosingCallable();

  /** Gets the location. */
  abstract L::Location getLocationImpl();

  /** Gets a string representation. */
  abstract string toStringImpl();
}

private class ExprNodeImpl extends ExprNode, NodeImpl {
  override DataFlowCallable getEnclosingCallable() {
    exists(TS::PHP::FunctionDefinition f |
      this.getExpr().getParent+() = f and
      result = TFunctionCallable(f)
    )
    or
    exists(TS::PHP::MethodDeclaration m |
      this.getExpr().getParent+() = m and
      result = TMethodCallable(m)
    )
  }

  override L::Location getLocationImpl() { result = this.getExpr().getLocation() }

  override string toStringImpl() { result = this.getExpr().toString() }
}

private class ParameterNodeImpl extends ParameterNode, NodeImpl {
  override DataFlowCallable getEnclosingCallable() {
    exists(TS::PHP::FunctionDefinition f |
      this.getParameter().getParent+() = f and
      result = TFunctionCallable(f)
    )
    or
    exists(TS::PHP::MethodDeclaration m |
      this.getParameter().getParent+() = m and
      result = TMethodCallable(m)
    )
  }

  override L::Location getLocationImpl() { result = this.getParameter().getLocation() }

  override string toStringImpl() { result = this.getParameter().toString() }

  /** Holds if this parameter is at position `pos` in callable `c`. */
  predicate isParameterOf(DataFlowCallable c, ParameterPosition pos) {
    exists(TS::PHP::FormalParameters params, int i |
      c.asFunction().getParameters() = params and
      this.getParameter() = params.getChild(i) and
      pos.getPosition() = i
    )
    or
    exists(TS::PHP::FormalParameters params, int i |
      c.asMethod().getParameters() = params and
      this.getParameter() = params.getChild(i) and
      pos.getPosition() = i
    )
  }
}

private class ArgumentNodeImpl extends ArgumentNode, NodeImpl {
  override DataFlowCallable getEnclosingCallable() {
    exists(TS::PHP::FunctionDefinition f |
      this.getArgument().getParent+() = f and
      result = TFunctionCallable(f)
    )
    or
    exists(TS::PHP::MethodDeclaration m |
      this.getArgument().getParent+() = m and
      result = TMethodCallable(m)
    )
  }

  override L::Location getLocationImpl() { result = this.getArgument().getLocation() }

  override string toStringImpl() { result = this.getArgument().toString() }
}

private class ReturnNodeImpl extends ReturnNode, NodeImpl {
  override DataFlowCallable getEnclosingCallable() {
    exists(TS::PHP::FunctionDefinition f |
      this.getReturnStatement().getParent+() = f and
      result = TFunctionCallable(f)
    )
    or
    exists(TS::PHP::MethodDeclaration m |
      this.getReturnStatement().getParent+() = m and
      result = TMethodCallable(m)
    )
  }

  override L::Location getLocationImpl() { result = this.getReturnStatement().getLocation() }

  override string toStringImpl() { result = "return" }
}

private class OutNodeImpl extends OutNode, NodeImpl {
  override DataFlowCallable getEnclosingCallable() {
    exists(TS::PHP::FunctionDefinition f |
      this.getCall().getParent+() = f and
      result = TFunctionCallable(f)
    )
    or
    exists(TS::PHP::MethodDeclaration m |
      this.getCall().getParent+() = m and
      result = TMethodCallable(m)
    )
  }

  override L::Location getLocationImpl() { result = this.getCall().getLocation() }

  override string toStringImpl() { result = "out: " + this.getCall().toString() }
}

private class PostUpdateNodeImpl extends PostUpdateNode, NodeImpl {
  override DataFlowCallable getEnclosingCallable() {
    result = this.getPreUpdateNode().(NodeImpl).getEnclosingCallable()
  }

  override L::Location getLocationImpl() { result = this.getPreUpdateNode().(NodeImpl).getLocationImpl() }

  override string toStringImpl() { result = "[post] " + this.getPreUpdateNode().toString() }
}

private class CastNodeImpl extends CastNode, NodeImpl {
  override DataFlowCallable getEnclosingCallable() {
    exists(TS::PHP::FunctionDefinition f |
      this.getCast().getParent+() = f and
      result = TFunctionCallable(f)
    )
    or
    exists(TS::PHP::MethodDeclaration m |
      this.getCast().getParent+() = m and
      result = TMethodCallable(m)
    )
  }

  override L::Location getLocationImpl() { result = this.getCast().getLocation() }

  override string toStringImpl() { result = this.getCast().toString() }
}

/** Gets the callable for node `n`. */
DataFlowCallable nodeGetEnclosingCallable(Node n) { result = n.(NodeImpl).getEnclosingCallable() }

/** Holds if `p` is a parameter of `c` at position `pos`. */
predicate isParameterNode(ParameterNode p, DataFlowCallable c, ParameterPosition pos) {
  p.(ParameterNodeImpl).isParameterOf(c, pos)
}

/** Holds if `arg` is an argument of `c` at position `pos`. */
predicate isArgumentNode(ArgumentNode arg, DataFlowCall c, ArgumentPosition pos) {
  arg.argumentOf(c, pos)
}

/** Gets the node type for `n`. */
DataFlowType getNodeType(Node n) { any() and result = TAnyType() and exists(n) }

/** Holds if `n` is hidden. */
predicate nodeIsHidden(Node n) { none() }

/** Data flow expression type. */
class DataFlowExpr = TS::PHP::Expression;

/** Gets the node for expression `e`. */
Node exprNode(DataFlowExpr e) { result = TExprNode(e) }

/** Gets a viable callable for call `c`. */
DataFlowCallable viableCallable(DataFlowCall c) {
  // Simplified: just return any callable with matching name
  exists(string name |
    name = c.getCall().(TS::PHP::FunctionCallExpression).getFunction().(TS::PHP::Name).getValue() and
    name = result.asFunction().getName().(TS::PHP::Name).getValue()
  )
}

/** Gets an output node for call `c` with return kind `kind`. */
OutNode getAnOutNode(DataFlowCall c, ReturnKind kind) {
  result.getCall() = c.getCall() and
  kind instanceof NormalReturnKind
}

/** Holds if types are compatible. */
predicate compatibleTypes(DataFlowType t1, DataFlowType t2) { any() }

/** Holds if `t1` is stronger than `t2`. */
predicate typeStrongerThan(DataFlowType t1, DataFlowType t2) { none() }

/** Holds if `c` should use high precision. */
predicate forceHighPrecision(Content c) { none() }

/**
 * Holds if there is a simple local flow step from `node1` to `node2`.
 */
predicate simpleLocalFlowStep(Node node1, Node node2, string model) {
  // Assignment: RHS flows to variable
  exists(TS::PHP::AssignmentExpression assign |
    node1.asExpr() = assign.getRight() and
    node2.asExpr() = assign
  ) and
  model = "assignment"
  or
  // Variable reference flows to use
  exists(TS::PHP::VariableName v1, TS::PHP::VariableName v2 |
    node1.asExpr() = v1 and
    node2.asExpr() = v2 and
    v1.getChild().(TS::PHP::Name).getValue() = v2.getChild().(TS::PHP::Name).getValue() and
    v1 != v2
  ) and
  model = "variable"
  or
  // Return value flows to call result
  exists(ReturnNode ret, OutNode out |
    node1 = ret and
    node2 = out and
    ret.(NodeImpl).getEnclosingCallable() = viableCallable(TFunctionCall(out.getCall()))
  ) and
  model = "return"
  or
  // Parenthesized expression
  exists(TS::PHP::ParenthesizedExpression paren |
    node1.asExpr() = paren.getChild() and
    node2.asExpr() = paren
  ) and
  model = "paren"
  or
  // Cast expression
  exists(TS::PHP::CastExpression cast |
    node1.asExpr() = cast.getValue() and
    node2 = TCastNode(cast)
  ) and
  model = "cast"
}

/** Jump step (non-local flow). */
predicate jumpStep(Node node1, Node node2) { none() }

/** Read step (field/array read). */
predicate readStep(Node node1, ContentSet c, Node node2) {
  exists(TS::PHP::SubscriptExpression sub |
    node1.asExpr() = sub.getChild(0) and
    node2.asExpr() = sub and
    c = TAnyContentSet()
  )
  or
  exists(TS::PHP::MemberAccessExpression access |
    node1.asExpr() = access.getObject() and
    node2.asExpr() = access and
    c = TAnyContentSet()
  )
}

/** Store step (field/array write). */
predicate storeStep(Node node1, ContentSet c, Node node2) {
  exists(TS::PHP::AssignmentExpression assign, TS::PHP::SubscriptExpression sub |
    sub = assign.getLeft() and
    node1.asExpr() = assign.getRight() and
    node2.asExpr() = sub.getChild(0) and
    c = TAnyContentSet()
  )
  or
  exists(TS::PHP::AssignmentExpression assign, TS::PHP::MemberAccessExpression access |
    access = assign.getLeft() and
    node1.asExpr() = assign.getRight() and
    node2.asExpr() = access.getObject() and
    c = TAnyContentSet()
  )
}

/** Clears content. */
predicate clearsContent(Node n, ContentSet c) { none() }

/** Expects content. */
predicate expectsContent(Node n, ContentSet c) { none() }

/** A node region. */
class NodeRegion extends TNodeRegion {
  /** Holds if this region contains `n`. */
  predicate contains(Node n) { none() }

  /** Gets a string representation. */
  string toString() { result = "region" }
}

newtype TNodeRegion = TEmptyRegion()

/** Unreachable in call. */
predicate isUnreachableInCall(NodeRegion nr, DataFlowCall call) { none() }

/** Allow parameter return in self. */
predicate allowParameterReturnInSelf(ParameterNode p) { none() }

/** Local must flow step. */
predicate localMustFlowStep(Node node1, Node node2) { none() }

/** Lambda call kind. */
class LambdaCallKind extends TLambdaCallKind {
  string toString() { result = "lambda" }
}

newtype TLambdaCallKind = TClosureKind()

/** Lambda creation. */
predicate lambdaCreation(Node creation, LambdaCallKind kind, DataFlowCallable c) {
  // Disabled for now - AnonymousFunction is not a FunctionDefinition
  none()
}

/** Lambda call. */
predicate lambdaCall(DataFlowCall call, LambdaCallKind kind, Node receiver) { none() }

/** Additional lambda flow step. */
predicate additionalLambdaFlowStep(Node nodeFrom, Node nodeTo, boolean preservesValue) { none() }

/** Known source model. */
predicate knownSourceModel(Node source, string model) { none() }

/** Known sink model. */
predicate knownSinkModel(Node sink, string model) { none() }

/** Second-level scope. */
class DataFlowSecondLevelScope extends TDataFlowSecondLevelScope {
  string toString() { result = "scope" }
}

newtype TDataFlowSecondLevelScope = TEmptyScope()

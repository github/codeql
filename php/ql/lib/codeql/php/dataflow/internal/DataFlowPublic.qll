/**
 * Provides public classes and predicates for PHP data flow.
 */

private import codeql.php.ast.internal.TreeSitter as TS
private import codeql.Locations as L
private import DataFlowPrivate

/**
 * A node in the data flow graph.
 */
class Node extends TNode {
  /** Gets the expression corresponding to this node, if any. */
  TS::PHP::Expression asExpr() { this = TExprNode(result) }

  /** Gets a textual representation of this node. */
  string toString() { result = this.(NodeImpl).toStringImpl() }

  /** Gets the location of this node. */
  L::Location getLocation() { result = this.(NodeImpl).getLocationImpl() }
}

/**
 * An expression node in the data flow graph.
 */
class ExprNode extends Node {
  TS::PHP::Expression expr;

  ExprNode() { this = TExprNode(expr) }

  /** Gets the expression. */
  TS::PHP::Expression getExpr() { result = expr }
}

/**
 * A parameter node in the data flow graph.
 */
class ParameterNode extends Node {
  TS::PHP::SimpleParameter param;

  ParameterNode() { this = TParameterNode(param) }

  /** Gets the parameter. */
  TS::PHP::SimpleParameter getParameter() { result = param }
}

/**
 * An argument node in the data flow graph.
 */
class ArgumentNode extends Node {
  TS::PHP::Argument arg;

  ArgumentNode() { this = TArgumentNode(arg) }

  /** Gets the argument. */
  TS::PHP::Argument getArgument() { result = arg }

  /** Holds if this argument is at position `pos` in call `call`. */
  predicate argumentOf(DataFlowCall call, ArgumentPosition pos) {
    exists(TS::PHP::Arguments args |
      args = call.getCall().(TS::PHP::FunctionCallExpression).getArguments() and
      arg = args.getChild(pos.getPosition())
    )
    or
    exists(TS::PHP::Arguments args |
      args = call.getCall().(TS::PHP::MemberCallExpression).getArguments() and
      arg = args.getChild(pos.getPosition())
    )
  }
}

/**
 * A return node in the data flow graph.
 */
class ReturnNode extends Node {
  TS::PHP::ReturnStatement ret;

  ReturnNode() { this = TReturnNode(ret) }

  /** Gets the return statement. */
  TS::PHP::ReturnStatement getReturnStatement() { result = ret }

  /** Gets the return kind. */
  ReturnKind getKind() { result instanceof NormalReturnKind }
}

/**
 * An output node representing the result of a call.
 */
class OutNode extends Node {
  TS::PHP::Expression call;

  OutNode() { this = TOutNode(call) }

  /** Gets the call. */
  TS::PHP::Expression getCall() { result = call }
}

/**
 * A post-update node representing the value after mutation.
 */
class PostUpdateNode extends Node {
  Node preUpdate;

  PostUpdateNode() { this = TPostUpdateNode(preUpdate) }

  /** Gets the pre-update node. */
  Node getPreUpdateNode() { result = preUpdate }
}

/**
 * A cast node in the data flow graph.
 */
class CastNode extends Node {
  TS::PHP::CastExpression cast;

  CastNode() { this = TCastNode(cast) }

  /** Gets the cast expression. */
  TS::PHP::CastExpression getCast() { result = cast }
}

/**
 * A data flow callable (function/method).
 */
class DataFlowCallable extends TDataFlowCallable {
  /** Gets a textual representation. */
  string toString() {
    exists(TS::PHP::FunctionDefinition f | this = TFunctionCallable(f) | result = f.toString())
    or
    exists(TS::PHP::MethodDeclaration m | this = TMethodCallable(m) | result = m.toString())
  }

  /** Gets the location. */
  L::Location getLocation() {
    exists(TS::PHP::FunctionDefinition f | this = TFunctionCallable(f) | result = f.getLocation())
    or
    exists(TS::PHP::MethodDeclaration m | this = TMethodCallable(m) | result = m.getLocation())
  }

  /** Gets the underlying function definition, if any. */
  TS::PHP::FunctionDefinition asFunction() { this = TFunctionCallable(result) }

  /** Gets the underlying method declaration, if any. */
  TS::PHP::MethodDeclaration asMethod() { this = TMethodCallable(result) }
}

/**
 * A data flow call.
 */
class DataFlowCall extends TDataFlowCall {
  /** Gets a textual representation. */
  string toString() { result = this.getCall().toString() }

  /** Gets the location. */
  L::Location getLocation() { result = this.getCall().getLocation() }

  /** Gets the underlying call expression. */
  TS::PHP::Expression getCall() {
    this = TFunctionCall(result) or this = TMethodCall(result)
  }

  /** Gets the enclosing callable. */
  DataFlowCallable getEnclosingCallable() {
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
}

/**
 * A return kind.
 */
class ReturnKind extends TReturnKind {
  /** Gets a textual representation. */
  string toString() {
    this instanceof NormalReturnKind and result = "return"
  }
}

/** A normal return kind. */
class NormalReturnKind extends ReturnKind, TNormalReturn { }

/**
 * A parameter position.
 */
class ParameterPosition extends TParameterPosition {
  int pos;

  ParameterPosition() { this = TPositionalParameter(pos) }

  /** Gets the position. */
  int getPosition() { result = pos }

  /** Gets a textual representation. */
  bindingset[this]
  string toString() { result = "param " + pos.toString() }
}

/**
 * An argument position.
 */
class ArgumentPosition extends TArgumentPosition {
  int pos;

  ArgumentPosition() { this = TPositionalArgument(pos) }

  /** Gets the position. */
  int getPosition() { result = pos }

  /** Gets a textual representation. */
  bindingset[this]
  string toString() { result = "arg " + pos.toString() }
}

/**
 * Holds if positions match.
 */
predicate parameterMatch(ParameterPosition ppos, ArgumentPosition apos) {
  ppos.getPosition() = apos.getPosition()
}

/**
 * A data flow type (placeholder).
 */
class DataFlowType extends TDataFlowType {
  /** Gets a textual representation. */
  string toString() { result = "type" }
}

/**
 * Content (for field/array access).
 */
class Content extends TContent {
  /** Gets a textual representation. */
  string toString() {
    this = TArrayContent() and result = "array"
    or
    exists(string name | this = TFieldContent(name) | result = "field " + name)
  }
}

/** Array content. */
class ArrayContent extends Content, TArrayContent { }

/** Field content. */
class FieldContent extends Content, TFieldContent {
  string name;

  FieldContent() { this = TFieldContent(name) }

  /** Gets the field name. */
  string getName() { result = name }
}

/**
 * A content set.
 */
class ContentSet extends TContentSet {
  /** Gets a textual representation. */
  string toString() { result = "content set" }

  /** Gets a content in this set for storing. */
  Content getAStoreContent() {
    exists(Content c | this = TSingletonContentSet(c) | result = c)
    or
    this = TAnyContentSet() and result instanceof Content
  }

  /** Gets a content in this set for reading. */
  Content getAReadContent() { result = this.getAStoreContent() }
}

/**
 * A content approximation.
 */
class ContentApprox extends TContentApprox {
  /** Gets a textual representation. */
  string toString() { result = "content approx" }
}

/**
 * Gets the content approximation for content `c`.
 */
ContentApprox getContentApprox(Content c) {
  c instanceof ArrayContent and result = TArrayApprox()
  or
  c instanceof FieldContent and result = TFieldApprox()
}

/**
 * Holds if there is a local flow step from `node1` to `node2`.
 */
predicate localFlowStep(Node node1, Node node2) {
  simpleLocalFlowStep(node1, node2, _)
}

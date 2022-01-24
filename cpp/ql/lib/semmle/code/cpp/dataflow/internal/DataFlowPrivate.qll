private import cpp
private import DataFlowUtil
private import DataFlowDispatch
private import FlowVar
private import DataFlowImplConsistency

/** Gets the callable in which this node occurs. */
DataFlowCallable nodeGetEnclosingCallable(Node n) { result = n.getEnclosingCallable() }

/** Holds if `p` is a `ParameterNode` of `c` with position `pos`. */
predicate isParameterNode(ParameterNode p, DataFlowCallable c, ParameterPosition pos) {
  p.isParameterOf(c, pos)
}

/** Holds if `arg` is an `ArgumentNode` of `c` with position `pos`. */
predicate isArgumentNode(ArgumentNode arg, DataFlowCall c, ArgumentPosition pos) {
  arg.argumentOf(c, pos)
}

/** Gets the instance argument of a non-static call. */
private Node getInstanceArgument(Call call) {
  result.asExpr() = call.getQualifier()
  or
  result.(PreObjectInitializerNode).getExpr().(ConstructorCall) = call
  // This does not include the implicit `this` argument on auto-generated
  // base class destructor calls as those do not have an AST element.
}

/** An argument to a call. */
private class Argument extends Expr {
  Call call;
  int pos;

  Argument() { call.getArgument(pos) = this }

  /** Gets the call that has this argument. */
  Call getCall() { result = call }

  /** Gets the position of this argument. */
  int getPosition() { result = pos }
}

/**
 * A data flow node that occurs as the argument of a call and is passed as-is
 * to the callable. Arguments that are wrapped in an implicit varargs array
 * creation are not included, but the implicitly created array is.
 * Instance arguments are also included.
 */
class ArgumentNode extends Node {
  ArgumentNode() {
    this.asExpr() instanceof Argument or
    this = getInstanceArgument(_)
  }

  /**
   * Holds if this argument occurs at the given position in the given call.
   * The instance argument is considered to have index `-1`.
   */
  predicate argumentOf(DataFlowCall call, int pos) {
    exists(Argument arg | this.asExpr() = arg | call = arg.getCall() and pos = arg.getPosition())
    or
    pos = -1 and this = getInstanceArgument(call)
  }

  /** Gets the call in which this node is an argument. */
  DataFlowCall getCall() { this.argumentOf(result, _) }
}

private newtype TReturnKind =
  TNormalReturnKind() or
  TRefReturnKind(int i) { exists(Parameter parameter | i = parameter.getIndex()) }

/**
 * A return kind. A return kind describes how a value can be returned
 * from a callable. For C++, this is simply a function return.
 */
class ReturnKind extends TReturnKind {
  /** Gets a textual representation of this return kind. */
  string toString() {
    this instanceof TNormalReturnKind and
    result = "return"
    or
    this instanceof TRefReturnKind and
    result = "ref"
  }
}

/** A data flow node that represents a returned value in the called function. */
abstract class ReturnNode extends Node {
  /** Gets the kind of this returned value. */
  abstract ReturnKind getKind();
}

/** A `ReturnNode` that occurs as the result of a `ReturnStmt`. */
private class NormalReturnNode extends ReturnNode, ExprNode {
  NormalReturnNode() { exists(ReturnStmt ret | this.getExpr() = ret.getExpr()) }

  /** Gets the kind of this returned value. */
  override ReturnKind getKind() { result = TNormalReturnKind() }
}

/**
 * A `ReturnNode` that occurs as a result of a definition of a reference
 * parameter reaching the end of a function body.
 */
private class RefReturnNode extends ReturnNode, RefParameterFinalValueNode {
  /** Gets the kind of this returned value. */
  override ReturnKind getKind() { result = TRefReturnKind(this.getParameter().getIndex()) }
}

/** A data flow node that represents the output of a call at the call site. */
abstract class OutNode extends Node {
  /** Gets the underlying call. */
  abstract DataFlowCall getCall();
}

private class ExprOutNode extends OutNode, ExprNode {
  ExprOutNode() { this.getExpr() instanceof Call }

  /** Gets the underlying call. */
  override DataFlowCall getCall() { result = this.getExpr() }
}

private class RefOutNode extends OutNode, DefinitionByReferenceOrIteratorNode {
  /** Gets the underlying call. */
  override DataFlowCall getCall() { result = this.getArgument().getParent() }
}

/**
 * Gets a node that can read the value returned from `call` with return kind
 * `kind`.
 */
OutNode getAnOutNode(DataFlowCall call, ReturnKind kind) {
  result = call.getNode() and
  kind = TNormalReturnKind()
  or
  exists(int i |
    result.(DefinitionByReferenceOrIteratorNode).getArgument() = call.getArgument(i) and
    kind = TRefReturnKind(i)
  )
}

/**
 * Holds if data can flow from `node1` to `node2` in a way that loses the
 * calling context. For example, this would happen with flow through a
 * global or static variable.
 */
predicate jumpStep(Node n1, Node n2) { none() }

/**
 * Holds if data can flow from `node1` to `node2` via an assignment to `f`.
 * Thus, `node2` references an object with a field `f` that contains the
 * value of `node1`.
 */
predicate storeStep(Node node1, Content f, PostUpdateNode node2) {
  exists(ClassAggregateLiteral aggr, Field field |
    // The following line requires `node2` to be both an `ExprNode` and a
    // `PostUpdateNode`, which means it must be an `ObjectInitializerNode`.
    node2.asExpr() = aggr and
    f.(FieldContent).getField() = field and
    aggr.getFieldExpr(field) = node1.asExpr()
  )
  or
  exists(FieldAccess fa |
    exists(Assignment a |
      node1.asExpr() = a and
      a.getLValue() = fa
    ) and
    node2.getPreUpdateNode().asExpr() = fa.getQualifier() and
    f.(FieldContent).getField() = fa.getTarget()
  )
  or
  exists(ConstructorFieldInit cfi |
    node2.getPreUpdateNode().(PreConstructorInitThis).getConstructorFieldInit() = cfi and
    f.(FieldContent).getField() = cfi.getTarget() and
    node1.asExpr() = cfi.getExpr()
  )
}

/**
 * Holds if data can flow from `node1` to `node2` via a read of `f`.
 * Thus, `node1` references an object with a field `f` whose value ends up in
 * `node2`.
 */
predicate readStep(Node node1, Content f, Node node2) {
  exists(FieldAccess fr |
    node1.asExpr() = fr.getQualifier() and
    fr.getTarget() = f.(FieldContent).getField() and
    fr = node2.asExpr() and
    not fr = any(AssignExpr a).getLValue()
  )
}

/**
 * Holds if values stored inside content `c` are cleared at node `n`.
 */
predicate clearsContent(Node n, Content c) {
  none() // stub implementation
}

/** Gets the type of `n` used for type pruning. */
Type getNodeType(Node n) {
  suppressUnusedNode(n) and
  result instanceof VoidType // stub implementation
}

/** Gets a string representation of a type returned by `getNodeType`. */
string ppReprType(Type t) { none() } // stub implementation

/**
 * Holds if `t1` and `t2` are compatible, that is, whether data can flow from
 * a node of type `t1` to a node of type `t2`.
 */
pragma[inline]
predicate compatibleTypes(Type t1, Type t2) {
  any() // stub implementation
}

private predicate suppressUnusedNode(Node n) { any() }

//////////////////////////////////////////////////////////////////////////////
// Java QL library compatibility wrappers
//////////////////////////////////////////////////////////////////////////////
/** A node that performs a type cast. */
class CastNode extends Node {
  CastNode() { none() } // stub implementation
}

class DataFlowCallable = Function;

class DataFlowExpr = Expr;

class DataFlowType = Type;

/** A function call relevant for data flow. */
class DataFlowCall extends Expr instanceof Call {
  /**
   * Gets the nth argument for this call.
   *
   * The range of `n` is from `0` to `getNumberOfArguments() - 1`.
   */
  Expr getArgument(int n) { result = super.getArgument(n) }

  /** Gets the data flow node corresponding to this call. */
  ExprNode getNode() { result.getExpr() = this }

  /** Gets the enclosing callable of this call. */
  Function getEnclosingCallable() { result = this.getEnclosingFunction() }
}

predicate isUnreachableInCall(Node n, DataFlowCall call) { none() } // stub implementation

int accessPathLimit() { result = 5 }

/**
 * Holds if access paths with `c` at their head always should be tracked at high
 * precision. This disables adaptive access path precision for such access paths.
 */
predicate forceHighPrecision(Content c) { none() }

/** The unit type. */
private newtype TUnit = TMkUnit()

/** The trivial type with a single element. */
class Unit extends TUnit {
  /** Gets a textual representation of this element. */
  string toString() { result = "unit" }
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
predicate allowParameterReturnInSelf(ParameterNode p) { none() }

private class MyConsistencyConfiguration extends Consistency::ConsistencyConfiguration {
  override predicate argHasPostUpdateExclude(ArgumentNode n) {
    // Is the null pointer (or something that's not really a pointer)
    exists(n.asExpr().getValue())
    or
    // Isn't a pointer or is a pointer to const
    forall(DerivedType dt | dt = n.asExpr().getActualType() |
      dt.getBaseType().isConst()
      or
      dt.getBaseType() instanceof RoutineType
    )
    // The above list of cases isn't exhaustive, but it narrows down the
    // consistency alerts enough that most of them are interesting.
  }
}

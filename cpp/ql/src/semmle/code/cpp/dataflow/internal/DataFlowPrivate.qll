private import cpp
private import DataFlowUtil

/** Gets the instance argument of a non-static call. */
private Node getInstanceArgument(Call call) {
  result.asExpr() = call.getQualifier()
  // This does not include the implicit `this` argument on auto-generated
  // base class destructor calls as those do not have an AST element.
}

/**
 * A data flow node that occurs as the argument of a call and is passed as-is
 * to the callable. Arguments that are wrapped in an implicit varargs array
 * creation are not included, but the implicitly created array is.
 * Instance arguments are also included.
 */
class ArgumentNode extends Node {
  ArgumentNode() {
    exists(Argument arg | this.asExpr() = arg) or
    this = getInstanceArgument(_)
  }

  /**
   * Holds if this argument occurs at the given position in the given call.
   * The instance argument is considered to have index `-1`.
   */
  predicate argumentOf(Call call, int pos) {
    exists(Argument arg | this.asExpr() = arg | call = arg.getCall() and pos = arg.getPosition()) or
    pos = -1 and this = getInstanceArgument(call)
  }
}

/** A data flow node that occurs as the result of a `ReturnStmt`. */
class ReturnNode extends ExprNode {
  ReturnNode() {
    exists(ReturnStmt ret | this.getExpr() = ret.getExpr())
  }
}

/**
 * Holds if data can flow from `node1` to `node2` in a way that loses the
 * calling context. For example, this would happen with flow through a
 * global or static variable.
 */
predicate jumpStep(Node n1, Node n2) {
  none()
}

/**
 * Holds if `call` does not pass an implicit or explicit qualifier, i.e., a
 * `this` parameter.
 */
predicate callHasQualifier(Call call) {
  call.hasQualifier()
  or
  call.getTarget() instanceof Destructor
}

private newtype TContent = TFieldContent(Field f) or TCollectionContent() or TArrayContent()

/**
 * A reference contained in an object. Examples include instance fields, the
 * contents of a collection object, or the contents of an array.
 */
class Content extends TContent {
  /** Gets a textual representation of this element. */
  abstract string toString();
  predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    path = "" and sl = 0 and sc = 0 and el = 0 and ec = 0
  }
  /** Gets the type of the object containing this content. */
  abstract RefType getDeclaringType();
  /** Gets the type of this content. */
  abstract Type getType();
  /**
   * Holds if this content may contain an object of the same type as the one
   * that contains this content, and if this fact should be used to compress
   * access paths.
   *
   * Examples include the tail pointer in a linked list or the left and right
   * pointers in a binary tree.
   */
  predicate isSelfRef() { none() }
}
private class FieldContent extends Content, TFieldContent {
  Field f;
  FieldContent() { this = TFieldContent(f) }
  Field getField() { result = f }
  override string toString() { result = f.toString() }
  override predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    f.getLocation().hasLocationInfo(path, sl, sc, el, ec)
  }
  override RefType getDeclaringType() { result = f.getDeclaringType() }
  override Type getType() { result = f.getType() }
}
private class CollectionContent extends Content, TCollectionContent {
  override string toString() { result = "collection" }
  override RefType getDeclaringType() { none() }
  override Type getType() { none() }
}
private class ArrayContent extends Content, TArrayContent {
  override string toString() { result = "array" }
  override RefType getDeclaringType() { none() }
  override Type getType() { none() }
}

/**
 * Holds if data can flow from `node1` to `node2` via an assignment to `f`.
 * Thus, `node2` references an object with a field `f` that contains the
 * value of `node1`.
 */
predicate storeStep(Node node1, Content f, PostUpdateNode node2) {
  none() // stub implementation
}

/**
 * Holds if data can flow from `node1` to `node2` via a read of `f`.
 * Thus, `node1` references an object with a field `f` whose value ends up in
 * `node2`.
 */
predicate readStep(Node node1, Content f, Node node2) {
  none() // stub implementation
}

/**
 * Gets a representative (boxed) type for `t` for the purpose of pruning
 * possible flow. A single type is used for all numeric types to account for
 * numeric conversions, and otherwise the erasure is used.
 */
RefType getErasedRepr(Type t) {
  suppressUnusedType(t) and
  result instanceof VoidType // stub implementation
}

/**
 * Holds if `t1` and `t2` are compatible, that is, whether data can flow from
 * a node of type `t1` to a node of type `t2`.
 */
pragma[inline]
predicate compatibleTypes(Type t1, Type t2) {
  any() // stub implementation
}

private predicate suppressUnusedType(Type t) { any() }

//////////////////////////////////////////////////////////////////////////////
// Java QL library compatibility wrappers
//////////////////////////////////////////////////////////////////////////////

class RefType extends Type {
}

class CastExpr extends Expr {
  CastExpr() { none() } // stub implementation
}

/** An argument to a call. */
class Argument extends Expr {
  Call call;
  int pos;

  Argument() {
    call.getArgument(pos) = this
  }

  /** Gets the call that has this argument. */
  Call getCall() { result = call }

  /** Gets the position of this argument. */
  int getPosition() {
    result = pos
  }
}

class Callable extends Function { }

/**
 * An alias for `Function` in the C++ library. In the Java library, a `Method`
 * is any callable except a constructor.
 */
class Method extends Function { }

/**
 * An alias for `FunctionCall` in the C++ library. In the Java library, a
 * `MethodAccess` is any `Call` that does not call a constructor.
 */
class MethodAccess extends FunctionCall {
  /**
   * INTERNAL: Do not use. Alternative name for `getEnclosingFunction`.
   */
  Callable getEnclosingCallable() {
    result = this.getEnclosingFunction()
  }
}

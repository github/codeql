private import go
private import DataFlowUtil

private newtype TReturnKind =
  TSingleReturn()
  or
  TMultiReturn(int i) { exists(SignatureType st | exists(st.getResultType(i))) }

/**
 * A return kind. A return kind describes how a value can be returned
 * from a callable. For Go, this is either a return of a single value
 * or of one of multiple values.
 */
class ReturnKind extends TReturnKind {
  /** Gets a textual representation of this return kind. */
  string toString() {
    this = TSingleReturn() and
    result = "return"
    or
    exists(int i | this = TMultiReturn(i) |
      result = "return[" + i + "]"
    )
  }
}

/** A data flow node that represents returning a value from a function. */
class ReturnNode extends ResultNode {
  ReturnKind kind;

  ReturnNode() {
    exists(int nr | nr = fd.getType().getNumResult() |
      if nr = 1 then
        kind = TSingleReturn()
      else
        kind = TMultiReturn(i)
    )
  }

  /** Gets the kind of this returned value. */
  ReturnKind getKind() { result = kind }
}

/** A data flow node that represents the output of a call. */
class OutNode extends DataFlow::Node {
  DataFlow::CallNode call;

  int i;

  OutNode() {
    this = call.getResult() and
    i = -1
    or
    this = call.getResult(i)
  }

  /** Gets the underlying call. */
  DataFlowCall getCall() { result = call.asExpr() }
}

/**
 * Gets a node that can read the value returned from `call` with return kind
 * `kind`.
 */
OutNode getAnOutNode(DataFlowCall call, ReturnKind kind) {
  exists(DataFlow::CallNode c | c.asExpr() = call |
    kind = TSingleReturn() and
    result = c.getResult()
    or
    exists(int i | kind = TMultiReturn(i) |
      result = c.getResult(i)
    )
  )
}

/**
 * Holds if data can flow from `node1` to `node2` in a way that loses the
 * calling context. For example, this would happen with flow through a
 * global or static variable.
 */
predicate jumpStep(Node n1, Node n2) {
  exists(ValueEntity v, Write w |
    not v instanceof SsaSourceVariable and
    w.writes(v, n1) and
    n2 = v.getARead()
  )
}

/**
 * Holds if `call` passes an implicit or explicit qualifier, i.e., a
 * `this` parameter.
 */
predicate callHasQualifier(CallExpr call) { exists(call.getQualifier()) }

private newtype TContent =
  TFieldContent(Field f) or
  TCollectionContent() or
  TArrayContent() or
  TPointerContent(PointerType p)

/**
 * A reference contained in an object. Examples include instance fields, the
 * contents of a collection object, the contents of an array or pointer.
 */
class Content extends TContent {
  /** Gets a textual representation of this element. */
  abstract string toString();

  predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    path = "" and sl = 0 and sc = 0 and el = 0 and ec = 0
  }

  /** Gets the type of the object containing this content. */
  abstract Type getContainerType();

  /** Gets the type of this content. */
  abstract Type getType();
}

private class FieldContent extends Content, TFieldContent {
  Field f;

  FieldContent() { this = TFieldContent(f) }

  override string toString() { result = f.toString() }

  override predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    f.getDeclaration().hasLocationInfo(path, sl, sc, el, ec)
  }

  override Type getContainerType() { result = f.getDeclaringType() }

  override Type getType() { result = f.getType() }
}

private class CollectionContent extends Content, TCollectionContent {
  override string toString() { result = "collection" }

  override Type getContainerType() { none() }

  override Type getType() { none() }
}

private class ArrayContent extends Content, TArrayContent {
  override string toString() { result = "array" }

  override Type getContainerType() { none() }

  override Type getType() { none() }
}

private class PointerContent extends Content, TPointerContent {
  override string toString() { result = "pointer" }

  override Type getContainerType() { this = TPointerContent(result) }

  override Type getType() { result = getContainerType().(PointerType).getBaseType() }
}

/**
 * Holds if data can flow from `node1` to `node2` via an assignment to `c`.
 * Thus, `node2` references an object with a field `f` that contains the
 * value of `node1`.
 */
predicate storeStep(Node node1, Content c, PostUpdateNode node2) {
  exists(Write w, Field f |
    w.writesField(node2.getPreUpdateNode(), f, node1) and
    c = TFieldContent(f)
  )
  or
  node1 = node2.(AddressOperationNode).getOperand() and
  c = TPointerContent(node2.getType())
}

/**
 * Holds if data can flow from `node1` to `node2` via a read of `f`.
 * Thus, `node1` references an object with a field `f` whose value ends up in
 * `node2`.
 */
predicate readStep(Node node1, Content f, Node node2) {
  node1 = node2.(PointerDereferenceNode).getOperand() and
  f = TPointerContent(node1.getType())
  or
  exists(FieldReadNode read |
    node2 = read and
    node1 = read.getBase() and
    f = TFieldContent(read.getField())
  )
}

/**
 * Gets a representative (boxed) type for `t` for the purpose of pruning
 * possible flow. A single type is used for all numeric types to account for
 * numeric conversions, and otherwise the erasure is used.
 */
Type getErasedRepr(Type t) {
  result = t // stub implementation
}

/** Gets a string representation of a type returned by `getErasedRepr`. */
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

class DataFlowCallable = FuncDef;

class DataFlowExpr = Expr;

class DataFlowType = Type;

class DataFlowLocation = Location;

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
  DataFlowCallable getEnclosingCallable() { result = this.getEnclosingFunction() }
}

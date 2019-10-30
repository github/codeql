private import java
private import DataFlowUtil
private import DataFlowImplCommon::Public
private import DataFlowDispatch
private import semmle.code.java.controlflow.Guards
private import semmle.code.java.dataflow.SSA
private import semmle.code.java.dataflow.TypeFlow

private newtype TReturnKind = TNormalReturnKind()

/**
 * A return kind. A return kind describes how a value can be returned
 * from a callable. For Java, this is simply a method return.
 */
class ReturnKind extends TReturnKind {
  /** Gets a textual representation of this return kind. */
  string toString() { result = "return" }
}

/**
 * Gets a node that can read the value returned from `call` with return kind
 * `kind`.
 */
OutNode getAnOutNode(DataFlowCall call, ReturnKind kind) {
  result = call.getNode() and
  kind = TNormalReturnKind()
}

/**
 * A data flow node that occurs as the argument of a call and is passed as-is
 * to the callable. Arguments that are wrapped in an implicit varargs array
 * creation are not included, but the implicitly created array is.
 * Instance arguments are also included.
 */
class ArgumentNode extends Node {
  ArgumentNode() {
    exists(Argument arg | this.asExpr() = arg | not arg.isVararg())
    or
    this instanceof ImplicitVarargsArray
    or
    this = getInstanceArgument(_)
  }

  /**
   * Holds if this argument occurs at the given position in the given call.
   * The instance argument is considered to have index `-1`.
   */
  predicate argumentOf(DataFlowCall call, int pos) {
    exists(Argument arg | this.asExpr() = arg | call = arg.getCall() and pos = arg.getPosition())
    or
    call = this.(ImplicitVarargsArray).getCall() and
    pos = call.getCallee().getNumberOfParameters() - 1
    or
    pos = -1 and this = getInstanceArgument(call)
  }

  /** Gets the call in which this node is an argument. */
  DataFlowCall getCall() { this.argumentOf(result, _) }
}

/** A data flow node that occurs as the result of a `ReturnStmt`. */
class ReturnNode extends ExprNode {
  ReturnNode() { exists(ReturnStmt ret | this.getExpr() = ret.getResult()) }

  /** Gets the kind of this returned value. */
  ReturnKind getKind() { any() }
}

/** A data flow node that represents the output of a call. */
class OutNode extends ExprNode {
  OutNode() { this.getExpr() instanceof MethodAccess }

  /** Gets the underlying call. */
  DataFlowCall getCall() { result = this.getExpr() }
}

/**
 * Holds if data can flow from `node1` to `node2` through a static field.
 */
private predicate staticFieldStep(ExprNode node1, ExprNode node2) {
  exists(Field f, FieldRead fr |
    f.isStatic() and
    f.getAnAssignedValue() = node1.getExpr() and
    fr.getField() = f and
    fr = node2.getExpr() and
    hasNonlocalValue(fr)
  )
}

/**
 * Holds if data can flow from `node1` to `node2` through variable capture.
 */
private predicate variableCaptureStep(Node node1, ExprNode node2) {
  exists(SsaImplicitInit closure, SsaVariable captured |
    closure.captures(captured) and
    node2.getExpr() = closure.getAFirstUse()
  |
    node1.asExpr() = captured.getAUse()
    or
    not exists(captured.getAUse()) and
    exists(SsaVariable capturedDef | capturedDef = captured.getAnUltimateDefinition() |
      capturedDef.(SsaImplicitInit).isParameterDefinition(node1.asParameter()) or
      capturedDef.(SsaExplicitUpdate).getDefiningExpr().(VariableAssign).getSource() = node1
            .asExpr() or
      capturedDef.(SsaExplicitUpdate).getDefiningExpr().(AssignOp) = node1.asExpr()
    )
  )
}

/**
 * Holds if data can flow from `node1` to `node2` through a static field or
 * variable capture.
 */
predicate jumpStep(Node node1, Node node2) {
  staticFieldStep(node1, node2) or
  variableCaptureStep(node1, node2)
}

/**
 * Holds if `fa` is an access to an instance field that occurs as the
 * destination of an assignment of the value `src`.
 */
predicate instanceFieldAssign(Expr src, FieldAccess fa) {
  exists(AssignExpr a |
    a.getSource() = src and
    a.getDest() = fa and
    fa.getField() instanceof InstanceField
  )
}

/**
 * Gets an upper bound on the type of `f`.
 */
private Type getFieldTypeBound(Field f) {
  fieldTypeFlow(f, result, _)
  or
  not fieldTypeFlow(f, _, _) and result = f.getType()
}

private newtype TContent =
  TFieldContent(InstanceField f) or
  TCollectionContent() or
  TArrayContent()

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
  abstract RefType getContainerType();

  /** Gets the type of this content. */
  abstract Type getType();
}

private class FieldContent extends Content, TFieldContent {
  InstanceField f;

  FieldContent() { this = TFieldContent(f) }

  InstanceField getField() { result = f }

  override string toString() { result = f.toString() }

  override predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    f.getLocation().hasLocationInfo(path, sl, sc, el, ec)
  }

  override RefType getContainerType() { result = f.getDeclaringType() }

  override Type getType() { result = getFieldTypeBound(f) }
}

private class CollectionContent extends Content, TCollectionContent {
  override string toString() { result = "collection" }

  override RefType getContainerType() { none() }

  override Type getType() { none() }
}

private class ArrayContent extends Content, TArrayContent {
  override string toString() { result = "array" }

  override RefType getContainerType() { none() }

  override Type getType() { none() }
}

/**
 * Holds if data can flow from `node1` to `node2` via an assignment to `f`.
 * Thus, `node2` references an object with a field `f` that contains the
 * value of `node1`.
 */
predicate storeStep(Node node1, Content f, PostUpdateNode node2) {
  exists(FieldAccess fa |
    instanceFieldAssign(node1.asExpr(), fa) and
    node2.getPreUpdateNode() = getFieldQualifier(fa) and
    f.(FieldContent).getField() = fa.getField()
  )
}

/**
 * Holds if data can flow from `node1` to `node2` via a read of `f`.
 * Thus, `node1` references an object with a field `f` whose value ends up in
 * `node2`.
 */
predicate readStep(Node node1, Content f, Node node2) {
  exists(FieldRead fr |
    node1 = getFieldQualifier(fr) and
    fr.getField() = f.(FieldContent).getField() and
    fr = node2.asExpr()
  )
}

/**
 * Gets a representative (boxed) type for `t` for the purpose of pruning
 * possible flow. A single type is used for all numeric types to account for
 * numeric conversions, and otherwise the erasure is used.
 */
RefType getErasedRepr(Type t) {
  exists(Type e | e = t.getErasure() |
    if e instanceof NumericOrCharType
    then result.(BoxedType).getPrimitiveType().getName() = "double"
    else
      if e instanceof BooleanType
      then result.(BoxedType).getPrimitiveType().getName() = "boolean"
      else result = e
  )
}

/** Gets a string representation of a type returned by `getErasedRepr`. */
string ppReprType(Type t) {
  if t.(BoxedType).getPrimitiveType().getName() = "double"
  then result = "Number"
  else result = t.toString()
}

private predicate canContainBool(Type t) {
  t instanceof BooleanType or
  any(BooleanType b).(RefType).getASourceSupertype+() = t
}

/**
 * Holds if `t1` and `t2` are compatible, that is, whether data can flow from
 * a node of type `t1` to a node of type `t2`.
 */
pragma[inline]
predicate compatibleTypes(Type t1, Type t2) {
  exists(Type e1, Type e2 |
    e1 = getErasedRepr(t1) and
    e2 = getErasedRepr(t2)
  |
    // Because of `getErasedRepr`, `erasedHaveIntersection` is a sufficient
    // compatibility check, but `conContainBool` is kept as a dummy disjunct
    // to get the proper join-order.
    erasedHaveIntersection(e1, e2)
    or
    canContainBool(e1) and canContainBool(e2)
  )
}

/** A node that performs a type cast. */
class CastNode extends ExprNode {
  CastNode() { this.getExpr() instanceof CastExpr }
}

class DataFlowCallable = Callable;

class DataFlowExpr = Expr;

class DataFlowType = RefType;

class DataFlowLocation = Location;

class DataFlowBasicBlock = BasicBlock;

/** Gets the basic block in which the node `n` occurs. */
DataFlowBasicBlock getBasicBlock(Node n) {
  result = n.asExpr().getBasicBlock() or
  result = n.(ImplicitVarargsArray).getCall().(Expr).getBasicBlock() or
  result = n.(ImplicitInstanceAccess).getInstanceAccess().getCfgNode().getBasicBlock() or
  result = n.(MallocNode).getClassInstanceExpr().getBasicBlock() or
  result = getBasicBlock(n.(PostUpdateNode).getPreUpdateNode())
}

class DataFlowCall extends Call {
  /** Gets the data flow node corresponding to this call. */
  ExprNode getNode() { result.getExpr() = this }
}

/** Holds if `e` is an expression that always has the same Boolean value `val`. */
private predicate constantBooleanExpr(Expr e, boolean val) {
  e.(CompileTimeConstantExpr).getBooleanValue() = val
  or
  exists(SsaExplicitUpdate v, Expr src |
    e = v.getAUse() and
    src = v.getDefiningExpr().(VariableAssign).getSource() and
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
 * Holds if the node `n` is unreachable when the call context is `call`.
 */
cached
predicate isUnreachableInCall(Node n, DataFlowCall call) {
  exists(
    ExplicitParameterNode paramNode, ConstantBooleanArgumentNode arg, SsaImplicitInit param,
    Guard guard
  |
    // get constant bool argument and parameter for this call
    viableParamArg(call, paramNode, arg) and
    // get the ssa variable definition for this parameter
    param.isParameterDefinition(paramNode.getParameter()) and
    // which is used in a guard
    param.getAUse() = guard and
    // which controls `n` with the opposite value of `arg`
    guard.controls(n.asExpr().getBasicBlock(), arg.getBooleanValue().booleanNot())
  )
}

cached
module DataFlowPropertyImpl {
  /**
   * Holds if the guards `g1` and `g2` both read `v` with inverted polarity
   * and there exists a use-use chain from `g1` to `g2`.
   */
  cached
  private predicate useUseGuards(SsaVariable v, Guard g1, Guard g2) {
    g1 = v.getAUse() and
    exists(boolean b |
      adjacentUseUseSameVar+(g1, g2) and
      g1.controls(_, b) and
      g2.controls(_, b.booleanNot())
    )
  }

  /**
   * Holds if `useUseGuards` holds, and no control flow path
   * from `g1` to the definition of `v` exists without passing
   * through the guard `g2`.
   */
  cached
  private predicate interestingGuardsWithSsaVar(SsaVariable v, Guard g1, Guard g2) {
    useUseGuards(v, g1, g2) and
    not readReachesCfnWithout(v, g1, g2, v.getCFGNode())
  }

  /**
   * Holds if `read` is a read of SSA definition `def`, and `read` can
   * reach control flow node `cfn` without passing through `except`, which is also a
   * read of `def`.
   * Furthermore, `read` and `except` have to be guards of opposite polarity in a
   * use-use chain of `def`.
   */
  cached
  private predicate readReachesCfnWithout(
    SsaVariable def, RValue read, RValue except, ControlFlowNode cfn
  ) {
    cfn = read.getControlFlowNode() and
    useUseGuards(def, read, except)
    or
    exists(ControlFlowNode mid | readReachesCfnWithout(def, read, except, mid) |
      cfn = mid.getASuccessor() and
      not cfn = except.getControlFlowNode()
    )
  }

  cached
  newtype TProperty = TBooleanSsaVar(SsaVariable v) { interestingGuardsWithSsaVar(v, _, _) }

  /**
   * A property is an object that guards (parts) of a dataflow path.
   * If it holds at one DataFlowBasicBlock `bb1` of a dataflow path with boolean `b`,
   * that implies that all DataFlowBasicBlock `bb2` where the property holds with
   * `b.booleanNot()` can *not* be part of that dataflow path.
   */
  cached
  abstract class Property extends TProperty {
    cached
    abstract predicate holdsAt(DataFlowBasicBlock bb, boolean b);

    cached
    abstract string toString();
  }

  private class BooleanSsaVarProperty extends Property, TBooleanSsaVar {
    SsaVariable v;

    BooleanSsaVarProperty() { this = TBooleanSsaVar(v) }

    override predicate holdsAt(DataFlowBasicBlock bb, boolean b) {
      exists(Guard g |
        interestingGuardsWithSsaVar(v, g, _) or interestingGuardsWithSsaVar(v, _, g)
      |
        g.controls(bb, b)
      )
    }

    override string toString() { result = "BooleanSsaVarProperty " + v.toString() }
  }
}

import DataFlowPropertyImpl

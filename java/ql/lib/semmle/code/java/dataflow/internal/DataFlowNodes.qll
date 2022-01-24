private import java
private import semmle.code.java.dataflow.InstanceAccess
private import semmle.code.java.dataflow.FlowSummary
private import semmle.code.java.dataflow.TypeFlow
private import DataFlowPrivate
private import FlowSummaryImpl as FlowSummaryImpl
private import DataFlowImplCommon as DataFlowImplCommon

cached
newtype TNode =
  TExprNode(Expr e) {
    DataFlowImplCommon::forceCachingInSameStage() and
    not e.getType() instanceof VoidType and
    not e.getParent*() instanceof Annotation
  } or
  TExplicitParameterNode(Parameter p) {
    exists(p.getCallable().getBody()) or p.getCallable() = any(SummarizedCallable sc).asCallable()
  } or
  TImplicitVarargsArray(Call c) {
    c.getCallee().isVarargs() and
    not exists(Argument arg | arg.getCall() = c and arg.isExplicitVarargsArray())
  } or
  TInstanceParameterNode(Callable c) {
    (exists(c.getBody()) or c = any(SummarizedCallable sc).asCallable()) and
    not c.isStatic()
  } or
  TImplicitInstanceAccess(InstanceAccessExt ia) { not ia.isExplicit(_) } or
  TMallocNode(ClassInstanceExpr cie) or
  TExplicitExprPostUpdate(Expr e) {
    explicitInstanceArgument(_, e)
    or
    e instanceof Argument and not e.getType() instanceof ImmutableType
    or
    exists(FieldAccess fa | fa.getField() instanceof InstanceField and e = fa.getQualifier())
    or
    exists(ArrayAccess aa | e = aa.getArray())
  } or
  TImplicitExprPostUpdate(InstanceAccessExt ia) {
    implicitInstanceArgument(_, ia)
    or
    exists(FieldAccess fa |
      fa.getField() instanceof InstanceField and ia.isImplicitFieldQualifier(fa)
    )
  } or
  TSummaryInternalNode(SummarizedCallable c, FlowSummaryImpl::Private::SummaryNodeState state) {
    FlowSummaryImpl::Private::summaryNodeRange(c, state)
  } or
  TFieldValueNode(Field f)

private predicate explicitInstanceArgument(Call call, Expr instarg) {
  call instanceof MethodAccess and
  instarg = call.getQualifier() and
  not call.getCallee().isStatic()
}

private predicate implicitInstanceArgument(Call call, InstanceAccessExt ia) {
  ia.isImplicitMethodQualifier(call) or
  ia.isImplicitThisConstructorArgument(call)
}

module Public {
  /**
   * An element, viewed as a node in a data flow graph. Either an expression,
   * a parameter, or an implicit varargs array creation.
   */
  class Node extends TNode {
    /** Gets a textual representation of this element. */
    string toString() { none() }

    /** Gets the source location for this element. */
    Location getLocation() { none() }

    /** Gets the expression corresponding to this node, if any. */
    Expr asExpr() { result = this.(ExprNode).getExpr() }

    /** Gets the parameter corresponding to this node, if any. */
    Parameter asParameter() { result = this.(ExplicitParameterNode).getParameter() }

    /** Gets the type of this node. */
    Type getType() {
      result = this.asExpr().getType()
      or
      result = this.asParameter().getType()
      or
      exists(Parameter p |
        result = p.getType() and
        p.isVarargs() and
        p = this.(ImplicitVarargsArray).getCall().getCallee().getAParameter()
      )
      or
      result = this.(InstanceParameterNode).getCallable().getDeclaringType()
      or
      result = this.(ImplicitInstanceAccess).getInstanceAccess().getType()
      or
      result = this.(MallocNode).getClassInstanceExpr().getType()
      or
      result = this.(ImplicitPostUpdateNode).getPreUpdateNode().getType()
      or
      result = this.(FieldValueNode).getField().getType()
    }

    /** Gets the callable in which this node occurs. */
    Callable getEnclosingCallable() { result = nodeGetEnclosingCallable(this).asCallable() }

    private Type getImprovedTypeBound() {
      exprTypeFlow(this.asExpr(), result, _) or
      result = this.(ImplicitPostUpdateNode).getPreUpdateNode().getImprovedTypeBound()
    }

    /**
     * Gets an upper bound on the type of this node.
     */
    Type getTypeBound() {
      result = this.getImprovedTypeBound()
      or
      result = this.getType() and not exists(this.getImprovedTypeBound())
    }

    /**
     * Holds if this element is at the specified location.
     * The location spans column `startcolumn` of line `startline` to
     * column `endcolumn` of line `endline` in file `filepath`.
     * For more information, see
     * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
     */
    predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      this.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    }
  }

  /**
   * An expression, viewed as a node in a data flow graph.
   */
  class ExprNode extends Node, TExprNode {
    Expr expr;

    ExprNode() { this = TExprNode(expr) }

    override string toString() { result = expr.toString() }

    override Location getLocation() { result = expr.getLocation() }

    /** Gets the expression corresponding to this node. */
    Expr getExpr() { result = expr }
  }

  /** Gets the node corresponding to `e`. */
  ExprNode exprNode(Expr e) { result.getExpr() = e }

  /** An explicit or implicit parameter. */
  abstract class ParameterNode extends Node {
    /**
     * Holds if this node is the parameter of `c` at the specified (zero-based)
     * position. The implicit `this` parameter is considered to have index `-1`.
     */
    abstract predicate isParameterOf(Callable c, int pos);
  }

  /**
   * A parameter, viewed as a node in a data flow graph.
   */
  class ExplicitParameterNode extends ParameterNode, TExplicitParameterNode {
    Parameter param;

    ExplicitParameterNode() { this = TExplicitParameterNode(param) }

    override string toString() { result = param.toString() }

    override Location getLocation() { result = param.getLocation() }

    /** Gets the parameter corresponding to this node. */
    Parameter getParameter() { result = param }

    override predicate isParameterOf(Callable c, int pos) { c.getParameter(pos) = param }
  }

  /** Gets the node corresponding to `p`. */
  ExplicitParameterNode parameterNode(Parameter p) { result.getParameter() = p }

  /**
   * An implicit varargs array creation expression.
   *
   * A call `f(x1, x2)` to a method `f(A... xs)` desugars to `f(new A[]{x1, x2})`,
   * and this node corresponds to such an implicit array creation.
   */
  class ImplicitVarargsArray extends Node, TImplicitVarargsArray {
    Call call;

    ImplicitVarargsArray() { this = TImplicitVarargsArray(call) }

    override string toString() { result = "new ..[] { .. }" }

    override Location getLocation() { result = call.getLocation() }

    /** Gets the call containing this varargs array creation argument. */
    Call getCall() { result = call }
  }

  /**
   * An instance parameter for an instance method or constructor.
   */
  class InstanceParameterNode extends ParameterNode, TInstanceParameterNode {
    Callable callable;

    InstanceParameterNode() { this = TInstanceParameterNode(callable) }

    override string toString() { result = "parameter this" }

    override Location getLocation() { result = callable.getLocation() }

    /** Gets the callable containing this `this` parameter. */
    Callable getCallable() { result = callable }

    override predicate isParameterOf(Callable c, int pos) { callable = c and pos = -1 }
  }

  /**
   * An implicit read of `this` or `A.this`.
   */
  class ImplicitInstanceAccess extends Node, TImplicitInstanceAccess {
    InstanceAccessExt ia;

    ImplicitInstanceAccess() { this = TImplicitInstanceAccess(ia) }

    override string toString() { result = ia.toString() }

    override Location getLocation() { result = ia.getLocation() }

    /** Gets the instance access corresponding to this node. */
    InstanceAccessExt getInstanceAccess() { result = ia }
  }

  /**
   * A node associated with an object after an operation that might have
   * changed its state.
   *
   * This can be either the argument to a callable after the callable returns
   * (which might have mutated the argument), or the qualifier of a field after
   * an update to the field.
   *
   * Nodes corresponding to AST elements, for example `ExprNode`, usually refer
   * to the value before the update with the exception of `ClassInstanceExpr`,
   * which represents the value after the constructor has run.
   */
  abstract class PostUpdateNode extends Node {
    /**
     * Gets the node before the state update.
     */
    abstract Node getPreUpdateNode();
  }

  /**
   * A node representing the value of a field.
   */
  class FieldValueNode extends Node, TFieldValueNode {
    /** Gets the field corresponding to this node. */
    Field getField() { this = TFieldValueNode(result) }

    override string toString() { result = this.getField().toString() }

    override Location getLocation() { result = this.getField().getLocation() }
  }

  /**
   * Gets the node that occurs as the qualifier of `fa`.
   */
  Node getFieldQualifier(FieldAccess fa) {
    fa.getField() instanceof InstanceField and
    (
      result.asExpr() = fa.getQualifier() or
      result.(ImplicitInstanceAccess).getInstanceAccess().isImplicitFieldQualifier(fa)
    )
  }

  /** Gets the instance argument of a non-static call. */
  Node getInstanceArgument(Call call) {
    result.(MallocNode).getClassInstanceExpr() = call or
    explicitInstanceArgument(call, result.asExpr()) or
    implicitInstanceArgument(call, result.(ImplicitInstanceAccess).getInstanceAccess())
  }

  /** A node representing an `InstanceAccessExt`. */
  class InstanceAccessNode extends Node {
    InstanceAccessNode() {
      this instanceof ImplicitInstanceAccess or this.asExpr() instanceof InstanceAccess
    }

    /** Gets the instance access corresponding to this node. */
    InstanceAccessExt getInstanceAccess() {
      result = this.(ImplicitInstanceAccess).getInstanceAccess() or result.isExplicit(this.asExpr())
    }

    /** Holds if this is an access to an object's own instance. */
    predicate isOwnInstanceAccess() { this.getInstanceAccess().isOwnInstanceAccess() }
  }
}

private import Public

private class NewExpr extends PostUpdateNode, TExprNode {
  NewExpr() { exists(ClassInstanceExpr cie | this = TExprNode(cie)) }

  override Node getPreUpdateNode() { this = TExprNode(result.(MallocNode).getClassInstanceExpr()) }
}

/**
 * A `PostUpdateNode` that is not a `ClassInstanceExpr`.
 */
abstract private class ImplicitPostUpdateNode extends PostUpdateNode {
  override Location getLocation() { result = this.getPreUpdateNode().getLocation() }

  override string toString() { result = this.getPreUpdateNode().toString() + " [post update]" }
}

private class ExplicitExprPostUpdate extends ImplicitPostUpdateNode, TExplicitExprPostUpdate {
  override Node getPreUpdateNode() { this = TExplicitExprPostUpdate(result.asExpr()) }
}

private class ImplicitExprPostUpdate extends ImplicitPostUpdateNode, TImplicitExprPostUpdate {
  override Node getPreUpdateNode() {
    this = TImplicitExprPostUpdate(result.(ImplicitInstanceAccess).getInstanceAccess())
  }
}

module Private {
  private import DataFlowDispatch

  /** Gets the callable in which this node occurs. */
  DataFlowCallable nodeGetEnclosingCallable(Node n) {
    result.asCallable() = n.asExpr().getEnclosingCallable() or
    result.asCallable() = n.asParameter().getCallable() or
    result.asCallable() = n.(ImplicitVarargsArray).getCall().getEnclosingCallable() or
    result.asCallable() = n.(InstanceParameterNode).getCallable() or
    result.asCallable() = n.(ImplicitInstanceAccess).getInstanceAccess().getEnclosingCallable() or
    result.asCallable() = n.(MallocNode).getClassInstanceExpr().getEnclosingCallable() or
    result = nodeGetEnclosingCallable(n.(ImplicitPostUpdateNode).getPreUpdateNode()) or
    n = TSummaryInternalNode(result, _) or
    result.asFieldScope() = n.(FieldValueNode).getField()
  }

  /** Holds if `p` is a `ParameterNode` of `c` with position `pos`. */
  predicate isParameterNode(ParameterNode p, DataFlowCallable c, ParameterPosition pos) {
    p.isParameterOf(c.asCallable(), pos)
  }

  /** Holds if `arg` is an `ArgumentNode` of `c` with position `pos`. */
  predicate isArgumentNode(ArgumentNode arg, DataFlowCall c, ArgumentPosition pos) {
    arg.argumentOf(c, pos)
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
      or
      this.(SummaryNode).isArgumentOf(_, _)
    }

    /**
     * Holds if this argument occurs at the given position in the given call.
     * The instance argument is considered to have index `-1`.
     */
    predicate argumentOf(DataFlowCall call, int pos) {
      exists(Argument arg | this.asExpr() = arg |
        call.asCall() = arg.getCall() and pos = arg.getPosition()
      )
      or
      call.asCall() = this.(ImplicitVarargsArray).getCall() and
      pos = call.asCall().getCallee().getNumberOfParameters() - 1
      or
      pos = -1 and this = getInstanceArgument(call.asCall())
      or
      this.(SummaryNode).isArgumentOf(call, pos)
    }

    /** Gets the call in which this node is an argument. */
    DataFlowCall getCall() { this.argumentOf(result, _) }
  }

  /** A data flow node that occurs as the result of a `ReturnStmt`. */
  class ReturnNode extends Node {
    ReturnNode() {
      exists(ReturnStmt ret | this.asExpr() = ret.getResult()) or
      this.(SummaryNode).isReturn()
    }

    /** Gets the kind of this returned value. */
    ReturnKind getKind() { any() }
  }

  /** A data flow node that represents the output of a call. */
  class OutNode extends Node {
    OutNode() {
      this.asExpr() instanceof MethodAccess
      or
      this.(SummaryNode).isOut(_)
    }

    /** Gets the underlying call. */
    DataFlowCall getCall() {
      result.asCall() = this.asExpr()
      or
      this.(SummaryNode).isOut(result)
    }
  }

  /**
   * A data-flow node used to model flow summaries.
   */
  class SummaryNode extends Node, TSummaryInternalNode {
    private SummarizedCallable c;
    private FlowSummaryImpl::Private::SummaryNodeState state;

    SummaryNode() { this = TSummaryInternalNode(c, state) }

    override Location getLocation() { result = c.getLocation() }

    override string toString() { result = "[summary] " + state + " in " + c }

    /** Holds if this summary node is the `i`th argument of `call`. */
    predicate isArgumentOf(DataFlowCall call, int i) {
      FlowSummaryImpl::Private::summaryArgumentNode(call, this, i)
    }

    /** Holds if this summary node is a return node. */
    predicate isReturn() { FlowSummaryImpl::Private::summaryReturnNode(this, _) }

    /** Holds if this summary node is an out node for `call`. */
    predicate isOut(DataFlowCall call) { FlowSummaryImpl::Private::summaryOutNode(call, this, _) }
  }

  SummaryNode getSummaryNode(SummarizedCallable c, FlowSummaryImpl::Private::SummaryNodeState state) {
    result = TSummaryInternalNode(c, state)
  }
}

private import Private

/**
 * A node that corresponds to the value of a `ClassInstanceExpr` before the
 * constructor has run.
 */
private class MallocNode extends Node, TMallocNode {
  ClassInstanceExpr cie;

  MallocNode() { this = TMallocNode(cie) }

  override string toString() { result = cie.toString() + " [pre constructor]" }

  override Location getLocation() { result = cie.getLocation() }

  ClassInstanceExpr getClassInstanceExpr() { result = cie }
}

private class SummaryPostUpdateNode extends SummaryNode, PostUpdateNode {
  private Node pre;

  SummaryPostUpdateNode() { FlowSummaryImpl::Private::summaryPostUpdateNode(this, pre) }

  override Node getPreUpdateNode() { result = pre }
}

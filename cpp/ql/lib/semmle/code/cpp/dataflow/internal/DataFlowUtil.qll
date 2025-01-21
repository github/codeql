/**
 * DEPRECATED: Use `semmle.code.cpp.dataflow.new.DataFlow` instead.
 *
 * Provides C++-specific definitions for use in the data flow library.
 */

private import cpp
private import FlowVar
private import semmle.code.cpp.models.interfaces.DataFlow
private import semmle.code.cpp.controlflow.Guards
private import AddressFlow

cached
private newtype TNode =
  TExprNode(Expr e) or
  TPartialDefinitionNode(PartialDefinition pd) or
  TPreObjectInitializerNode(Expr e) {
    e instanceof ConstructorCall
    or
    e instanceof ClassAggregateLiteral
  } or
  TExplicitParameterNode(Parameter p) { exists(p.getFunction().getBlock()) } or
  TInstanceParameterNode(MemberFunction f) { exists(f.getBlock()) and not f.isStatic() } or
  TPreConstructorInitThis(ConstructorFieldInit cfi) or
  TPostConstructorInitThis(ConstructorFieldInit cfi) or
  TInnerPartialDefinitionNode(Expr e) {
    exists(PartialDefinition def, Expr outer |
      def.definesExpressions(e, outer) and
      // This condition ensures that we don't get two post-update nodes sharing
      // the same pre-update node.
      e != outer
    )
  } or
  TUninitializedNode(LocalVariable v) { not v.hasInitializer() } or
  TRefParameterFinalValueNode(Parameter p) { exists(FlowVar var | var.reachesRefParameter(p)) }

/**
 * A node in a data flow graph.
 *
 * A node can be either an expression, a parameter, or an uninitialized local
 * variable. Such nodes are created with `DataFlow::exprNode`,
 * `DataFlow::parameterNode`, and `DataFlow::uninitializedNode` respectively.
 */
class Node extends TNode {
  /** Gets the function to which this node belongs. */
  Function getFunction() { none() } // overridden in subclasses

  /**
   * INTERNAL: Do not use. Alternative name for `getFunction`.
   */
  final Function getEnclosingCallable() { result = this.getFunction() }

  /** Gets the type of this node. */
  Type getType() { none() } // overridden in subclasses

  /**
   * Gets the expression corresponding to this node, if any. This predicate
   * only has a result on nodes that represent the value of evaluating the
   * expression. For data flowing _out of_ an expression, like when an
   * argument is passed by reference, use `asDefiningArgument` instead of
   * `asExpr`.
   */
  Expr asExpr() { result = this.(ExprNode).getExpr() }

  /** Gets the parameter corresponding to this node, if any. */
  Parameter asParameter() { result = this.(ExplicitParameterNode).getParameter() }

  /**
   * Gets the argument that defines this `DefinitionByReferenceNode`, if any.
   * This predicate should be used instead of `asExpr` when referring to the
   * value of a reference argument _after_ the call has returned. For example,
   * in `f(&x)`, this predicate will have `&x` as its result for the `Node`
   * that represents the new value of `x`.
   */
  Expr asDefiningArgument() { result = this.(DefinitionByReferenceNode).getArgument() }

  /**
   * Gets the expression that is partially defined by this node, if any.
   *
   * Partial definitions are created for field stores (`x.y = taint();` is a partial
   * definition of `x`), and for calls that may change the value of an object (so
   * `x.set(taint())` is a partial definition of `x`, and `transfer(&x, taint())` is
   * a partial definition of `&x`).
   */
  Expr asPartialDefinition() {
    this.(PartialDefinitionNode).getPartialDefinition().definesExpressions(_, result)
  }

  /**
   * Gets the uninitialized local variable corresponding to this node, if
   * any.
   */
  LocalVariable asUninitialized() { result = this.(UninitializedNode).getLocalVariable() }

  /** Gets a textual representation of this element. */
  string toString() { none() } // overridden by subclasses

  /** Gets the location of this element. */
  Location getLocation() { none() } // overridden by subclasses

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  deprecated predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }

  /**
   * Gets an upper bound on the type of this node.
   */
  Type getTypeBound() { result = this.getType() }
}

/**
 * An expression, viewed as a node in a data flow graph.
 */
class ExprNode extends Node, TExprNode {
  Expr expr;

  ExprNode() { this = TExprNode(expr) }

  override Function getFunction() { result = expr.getEnclosingFunction() }

  override Type getType() { result = expr.getType() }

  override string toString() { result = expr.toString() }

  override Location getLocation() { result = expr.getLocation() }

  /** Gets the expression corresponding to this node. */
  Expr getExpr() { result = expr }
}

abstract class ParameterNode extends Node, TNode {
  /**
   * Holds if this node is the parameter of `c` at the specified (zero-based)
   * position. The implicit `this` parameter is considered to have index `-1`.
   */
  abstract predicate isParameterOf(Function f, int i);
}

/**
 * The value of a parameter at function entry, viewed as a node in a data
 * flow graph.
 */
class ExplicitParameterNode extends ParameterNode, TExplicitParameterNode {
  Parameter param;

  ExplicitParameterNode() { this = TExplicitParameterNode(param) }

  override Function getFunction() { result = param.getFunction() }

  override Type getType() { result = param.getType() }

  override string toString() { result = param.toString() }

  override Location getLocation() { result = param.getLocation() }

  /** Gets the parameter corresponding to this node. */
  Parameter getParameter() { result = param }

  override predicate isParameterOf(Function f, int i) { f.getParameter(i) = param }
}

class ImplicitParameterNode extends ParameterNode, TInstanceParameterNode {
  MemberFunction f;

  ImplicitParameterNode() { this = TInstanceParameterNode(f) }

  override Function getFunction() { result = f }

  override Type getType() { result = f.getDeclaringType() }

  override string toString() { result = "this" }

  override Location getLocation() { result = f.getLocation() }

  override predicate isParameterOf(Function fun, int i) { f = fun and i = -1 }
}

/**
 * INTERNAL: do not use.
 *
 * A node that represents the value of a variable after a function call that
 * may have changed the variable because it's passed by reference or because an
 * iterator for it was passed by value or by reference.
 */
class DefinitionByReferenceOrIteratorNode extends PartialDefinitionNode {
  Expr inner;
  Expr argument;

  DefinitionByReferenceOrIteratorNode() {
    this.getPartialDefinition().definesExpressions(inner, argument) and
    (
      this.getPartialDefinition() instanceof DefinitionByReference
      or
      this.getPartialDefinition() instanceof DefinitionByIterator
    )
  }

  override Function getFunction() { result = inner.getEnclosingFunction() }

  override Type getType() { result = inner.getType() }

  override Location getLocation() { result = argument.getLocation() }

  override ExprNode getPreUpdateNode() { result.getExpr() = argument }

  /** Gets the argument corresponding to this node. */
  Expr getArgument() { result = argument }

  /** Gets the parameter through which this value is assigned. */
  Parameter getParameter() {
    exists(FunctionCall call, int i |
      argument = call.getArgument(i) and
      result = call.getTarget().getParameter(i)
    )
  }
}

/**
 * A node that represents the value of a variable after a function call that
 * may have changed the variable because it's passed by reference.
 *
 * A typical example would be a call `f(&x)`. Firstly, there will be flow into
 * `x` from previous definitions of `x`. Secondly, there will be a
 * `DefinitionByReferenceNode` to represent the value of `x` after the call has
 * returned. This node will have its `getArgument()` equal to `&x`.
 */
class DefinitionByReferenceNode extends DefinitionByReferenceOrIteratorNode {
  override VariablePartialDefinition pd;

  override string toString() { result = "ref arg " + argument.toString() }
}

/**
 * The value of an uninitialized local variable, viewed as a node in a data
 * flow graph.
 */
class UninitializedNode extends Node, TUninitializedNode {
  LocalVariable v;

  UninitializedNode() { this = TUninitializedNode(v) }

  override Function getFunction() { result = v.getFunction() }

  override Type getType() { result = v.getType() }

  override string toString() { result = v.toString() }

  override Location getLocation() { result = v.getLocation() }

  /** Gets the uninitialized local variable corresponding to this node. */
  LocalVariable getLocalVariable() { result = v }
}

/** INTERNAL: do not use. The final value of a non-const ref parameter. */
class RefParameterFinalValueNode extends Node, TRefParameterFinalValueNode {
  Parameter p;

  RefParameterFinalValueNode() { this = TRefParameterFinalValueNode(p) }

  override Function getFunction() { result = p.getFunction() }

  override Type getType() { result = p.getType() }

  override string toString() { result = p.toString() }

  override Location getLocation() { result = p.getLocation() }

  Parameter getParameter() { result = p }
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

  override Function getFunction() { result = this.getPreUpdateNode().getFunction() }

  override Type getType() { result = this.getPreUpdateNode().getType() }

  override Location getLocation() { result = this.getPreUpdateNode().getLocation() }
}

abstract private class PartialDefinitionNode extends PostUpdateNode, TPartialDefinitionNode {
  PartialDefinition pd;

  PartialDefinitionNode() { this = TPartialDefinitionNode(pd) }

  override Location getLocation() { result = pd.getActualLocation() }

  PartialDefinition getPartialDefinition() { result = pd }

  override string toString() { result = this.getPreUpdateNode().toString() + " [post update]" }
}

private class VariablePartialDefinitionNode extends PartialDefinitionNode {
  override VariablePartialDefinition pd;

  override Node getPreUpdateNode() { pd.definesExpressions(_, result.asExpr()) }
}

/**
 * INTERNAL: do not use.
 *
 * A synthetic data flow node used for flow into a collection when an iterator
 * write occurs in a callee.
 */
private class IteratorPartialDefinitionNode extends PartialDefinitionNode {
  override IteratorPartialDefinition pd;

  override Node getPreUpdateNode() { pd.definesExpressions(_, result.asExpr()) }
}

/**
 * A post-update node on the `e->f` in `f(&e->f)` (and other forms).
 */
private class InnerPartialDefinitionNode extends TInnerPartialDefinitionNode, PostUpdateNode {
  Expr e;

  InnerPartialDefinitionNode() { this = TInnerPartialDefinitionNode(e) }

  override ExprNode getPreUpdateNode() { result.getExpr() = e }

  override Function getFunction() { result = e.getEnclosingFunction() }

  override Type getType() { result = e.getType() }

  override string toString() { result = e.toString() + " [inner post update]" }

  override Location getLocation() { result = e.getLocation() }
}

/**
 * A node representing the temporary value of an object that was just
 * constructed by a constructor call or an aggregate initializer. This is only
 * for objects, not for pointers to objects.
 *
 * These expressions are their own post-update nodes but instead have synthetic
 * pre-update nodes.
 */
private class ObjectInitializerNode extends PostUpdateNode, TExprNode {
  PreObjectInitializerNode pre;

  ObjectInitializerNode() {
    // If a `Node` is associated with a `PreObjectInitializerNode`, then it's
    // an `ObjectInitializerNode`.
    pre.getExpr() = this.asExpr()
  }

  override PreObjectInitializerNode getPreUpdateNode() { result = pre }
  // No override of `toString` since these nodes already have a `toString` from
  // their overlap with `ExprNode`.
}

/**
 * INTERNAL: do not use.
 *
 * A synthetic data-flow node that plays the role of a temporary object that
 * has not yet been initialized.
 */
class PreObjectInitializerNode extends Node, TPreObjectInitializerNode {
  Expr getExpr() { this = TPreObjectInitializerNode(result) }

  override Function getFunction() { result = this.getExpr().getEnclosingFunction() }

  override Type getType() { result = this.getExpr().getType() }

  override Location getLocation() { result = this.getExpr().getLocation() }

  override string toString() { result = this.getExpr().toString() + " [pre init]" }
}

/**
 * A synthetic data-flow node that plays the role of the post-update `this`
 * pointer in a `ConstructorFieldInit`. For example, the `x(1)` in
 * `C() : x(1) { }` is roughly equivalent to `this.x = 1`, and this node is
 * equivalent to the `this` _after_ the field has been assigned.
 */
private class PostConstructorInitThis extends PostUpdateNode, TPostConstructorInitThis {
  override PreConstructorInitThis getPreUpdateNode() {
    this = TPostConstructorInitThis(result.getConstructorFieldInit())
  }

  override string toString() {
    result = this.getPreUpdateNode().getConstructorFieldInit().toString() + " [post-this]"
  }
}

/**
 * INTERNAL: do not use.
 *
 * A synthetic data-flow node that plays the role of the pre-update `this`
 * pointer in a `ConstructorFieldInit`. For example, the `x(1)` in
 * `C() : x(1) { }` is roughly equivalent to `this.x = 1`, and this node is
 * equivalent to the `this` _before_ the field has been assigned.
 */
class PreConstructorInitThis extends Node, TPreConstructorInitThis {
  ConstructorFieldInit getConstructorFieldInit() { this = TPreConstructorInitThis(result) }

  override Constructor getFunction() {
    result = this.getConstructorFieldInit().getEnclosingFunction()
  }

  override PointerType getType() {
    result.getBaseType() = this.getConstructorFieldInit().getEnclosingFunction().getDeclaringType()
  }

  override Location getLocation() { result = this.getConstructorFieldInit().getLocation() }

  override string toString() { result = this.getConstructorFieldInit().toString() + " [pre-this]" }
}

/**
 * Gets the `Node` corresponding to the value of evaluating `e`. For data
 * flowing _out of_ an expression, like when an argument is passed by
 * reference, use `definitionByReferenceNodeFromArgument` instead.
 */
ExprNode exprNode(Expr e) { result.getExpr() = e }

/**
 * Gets the `Node` corresponding to the value of `p` at function entry.
 */
ParameterNode parameterNode(Parameter p) { result.(ExplicitParameterNode).getParameter() = p }

/**
 * Gets the `Node` corresponding to a definition by reference of the variable
 * that is passed as `argument` of a call.
 */
DefinitionByReferenceNode definitionByReferenceNodeFromArgument(Expr argument) {
  result.getArgument() = argument
}

/**
 * Gets the `Node` corresponding to the value of an uninitialized local
 * variable `v`.
 */
UninitializedNode uninitializedNode(LocalVariable v) { result.getLocalVariable() = v }

private module ThisFlow {
  /**
   * Gets the 0-based index of `thisNode` in `b`, where `thisNode` is an access
   * to `this` that may or may not have an associated `PostUpdateNode`. To make
   * room for synthetic nodes that access `this`, the index may not correspond
   * to an actual `ControlFlowNode`.
   */
  private int basicBlockThisIndex(BasicBlock b, Node thisNode) {
    // The implicit `this` parameter node is given a very negative offset to
    // make space for any `ConstructorFieldInit`s there may be between it and
    // the block contents.
    thisNode.(ImplicitParameterNode).getFunction().getBlock() = b and
    result = -2147483648
    or
    // Place the synthetic `this` node for a `ConstructorFieldInit` at a
    // negative offset in the first basic block, between the
    // `ImplicitParameterNode` and the first statement.
    exists(Constructor constructor, int i |
      thisNode.(PreConstructorInitThis).getConstructorFieldInit() = constructor.getInitializer(i) and
      result = -2147483648 + 1 + i and
      b = thisNode.getFunction().getBlock()
    )
    or
    b.getNode(result) = thisNode.asExpr().(ThisExpr)
  }

  private int thisRank(BasicBlock b, Node thisNode) {
    thisNode = rank[result](Node n, int i | i = basicBlockThisIndex(b, n) | n order by i)
  }

  private int lastThisRank(BasicBlock b) { result = max(thisRank(b, _)) }

  private predicate thisAccessBlockReaches(BasicBlock b1, BasicBlock b2) {
    exists(basicBlockThisIndex(b1, _)) and b2 = b1.getASuccessor()
    or
    exists(BasicBlock mid |
      thisAccessBlockReaches(b1, mid) and
      b2 = mid.getASuccessor() and
      not exists(basicBlockThisIndex(mid, _))
    )
  }

  predicate adjacentThisRefs(Node n1, Node n2) {
    exists(BasicBlock b | thisRank(b, n1) + 1 = thisRank(b, n2))
    or
    exists(BasicBlock b1, BasicBlock b2 |
      lastThisRank(b1) = thisRank(b1, n1) and
      thisAccessBlockReaches(b1, b2) and
      thisRank(b2, n2) = 1
    )
  }
}

/**
 * Holds if data flows from `nodeFrom` to `nodeTo` in exactly one local
 * (intra-procedural) step.
 */
cached
predicate localFlowStep(Node nodeFrom, Node nodeTo) {
  simpleLocalFlowStep(nodeFrom, nodeTo, _)
  or
  // Field flow is not strictly a "step" but covers the whole function
  // transitively. There's no way to get a step-like relation out of the global
  // data flow library, so we just have to accept some big steps here.
  FieldFlow::fieldFlow(nodeFrom, nodeTo)
}

/**
 * INTERNAL: do not use.
 *
 * This is the local flow predicate that's used as a building block in global
 * data flow. It may have less flow than the `localFlowStep` predicate.
 */
predicate simpleLocalFlowStep(Node nodeFrom, Node nodeTo, string model) {
  (
    // Expr -> Expr
    exprToExprStep_nocfg(nodeFrom.asExpr(), nodeTo.asExpr())
    or
    // Assignment -> LValue post-update node
    //
    // This is used for assignments whose left-hand side is not a variable
    // assignment or a storeStep but is still modeled by other means. It could be
    // a call to `operator*` or `operator[]` where taint should flow to the
    // post-update node of the qualifier.
    exists(AssignExpr assign |
      nodeFrom.asExpr() = assign and
      nodeTo.(PostUpdateNode).getPreUpdateNode().asExpr() = assign.getLValue()
    )
    or
    // Node -> FlowVar -> VariableAccess
    exists(FlowVar var |
      (
        exprToVarStep(nodeFrom.asExpr(), var)
        or
        varSourceBaseCase(var, nodeFrom.asParameter())
        or
        varSourceBaseCase(var, nodeFrom.asUninitialized())
        or
        var.definedPartiallyAt(nodeFrom.asPartialDefinition())
      ) and
      varToNodeStep(var, nodeTo)
    )
    or
    // Expr -> DefinitionByReferenceNode
    exprToDefinitionByReferenceStep(nodeFrom.asExpr(), nodeTo.asDefiningArgument())
    or
    // `this` -> adjacent-`this`
    ThisFlow::adjacentThisRefs(nodeFrom, nodeTo)
    or
    // post-update-`this` -> following-`this`-ref
    ThisFlow::adjacentThisRefs(nodeFrom.(PostUpdateNode).getPreUpdateNode(), nodeTo)
    or
    // In `f(&x->a)`, this step provides the flow from post-`&` to post-`x->a`,
    // from which there is field flow to `x` via reverse read.
    exists(PartialDefinition def, Expr inner, Expr outer |
      def.definesExpressions(inner, outer) and
      inner = nodeTo.(InnerPartialDefinitionNode).getPreUpdateNode().asExpr() and
      outer = nodeFrom.(PartialDefinitionNode).getPreUpdateNode().asExpr()
    )
    or
    // Reverse flow: data that flows from the post-update node of a reference
    // returned by a function call, back into the qualifier of that function.
    // This allows data to flow 'in' through references returned by a modeled
    // function such as `operator[]`.
    exists(DataFlowFunction f, Call call, FunctionInput inModel, FunctionOutput outModel |
      call.getTarget() = f and
      inModel.isReturnValueDeref() and
      outModel.isQualifierObject() and
      f.hasDataFlow(inModel, outModel) and
      nodeFrom.(PostUpdateNode).getPreUpdateNode().asExpr() = call and
      nodeTo.asDefiningArgument() = call.getQualifier()
    )
  ) and
  model = ""
}

/**
 * Holds if data flows from `source` to `sink` in zero or more local
 * (intra-procedural) steps.
 */
pragma[inline]
predicate localFlow(Node source, Node sink) { localFlowStep*(source, sink) }

/**
 * Holds if data can flow from `e1` to `e2` in zero or more
 * local (intra-procedural) steps.
 */
pragma[inline]
predicate localExprFlow(Expr e1, Expr e2) { localFlow(exprNode(e1), exprNode(e2)) }

/**
 * Holds if the initial value of `v`, if it is a source, flows to `var`.
 */
private predicate varSourceBaseCase(FlowVar var, Variable v) { var.definedByInitialValue(v) }

/**
 * Holds if `var` is defined by an assignment-like operation that causes flow
 * directly from `assignedExpr` to `var`, _and_ `assignedExpr` evaluates to
 * the same value as what is assigned to `var`.
 */
private predicate exprToVarStep(Expr assignedExpr, FlowVar var) {
  exists(ControlFlowNode operation |
    var.definedByExpr(assignedExpr, operation) and
    not operation instanceof PostfixCrementOperation
  )
}

/**
 * Holds if the node `n` is an access of the variable `var`.
 */
private predicate varToNodeStep(FlowVar var, Node n) {
  n.asExpr() = var.getAnAccess()
  or
  var.reachesRefParameter(n.(RefParameterFinalValueNode).getParameter())
}

/**
 * Holds if data flows from `fromExpr` to `toExpr` directly, in the case
 * where `toExpr` is the immediate AST parent of `fromExpr`. For example,
 * data flows from `x` and `y` to `b ? x : y`.
 */
private predicate exprToExprStep_nocfg(Expr fromExpr, Expr toExpr) {
  toExpr = any(ConditionalExpr cond | fromExpr = cond.getThen() or fromExpr = cond.getElse())
  or
  toExpr = any(AssignExpr assign | fromExpr = assign.getRValue())
  or
  toExpr = any(CommaExpr comma | fromExpr = comma.getRightOperand())
  or
  toExpr = any(PostfixCrementOperation op | fromExpr = op.getOperand())
  or
  toExpr = any(StmtExpr stmtExpr | fromExpr = stmtExpr.getResultExpr())
  or
  toExpr.(AddressOfExpr).getOperand() = fromExpr
  or
  // This rule enables flow from an array to its elements. Example: `a` to
  // `a[i]` or `*a`, where `a` is an array type. It does not enable flow from a
  // pointer to its indirection as in `p[i]` where `p` is a pointer type.
  exists(Expr toConverted |
    variablePartiallyAccessed(fromExpr, toConverted) and
    toExpr = toConverted.getUnconverted() and
    not toExpr = fromExpr
  )
  or
  toExpr.(BuiltInOperationBuiltInAddressOf).getOperand() = fromExpr
  or
  // The following case is needed to track the qualifier object for flow
  // through fields. It gives flow from `T(x)` to `new T(x)`. That's not
  // strictly _data_ flow but _taint_ flow because the type of `fromExpr` is
  // `T` while the type of `toExpr` is `T*`.
  //
  // This discrepancy is an artifact of how `new`-expressions are represented
  // in the database in a way that slightly varies from what the standard
  // specifies. In the C++ standard, there is no constructor call expression
  // `T(x)` after `new`. Instead there is a type `T` and an optional
  // initializer `(x)`.
  toExpr.(NewExpr).getInitializer() = fromExpr
  or
  // A lambda expression (`[captures](params){body}`) is just a thin wrapper
  // around the desugared closure creation in the form of a
  // `ClassAggregateLiteral` (`{ capture1, ..., captureN }`).
  toExpr.(LambdaExpression).getInitializer() = fromExpr
  or
  // Data flow through a function model.
  toExpr =
    any(Call call |
      exists(DataFlowFunction f, FunctionInput inModel, FunctionOutput outModel |
        f.hasDataFlow(inModel, outModel) and
        (
          exists(int iIn |
            inModel.isParameterDeref(iIn) and
            call.passesByReference(iIn, fromExpr)
          )
          or
          exists(int iIn |
            inModel.isParameter(iIn) and
            fromExpr = call.getArgument(iIn)
          )
          or
          inModel.isQualifierObject() and
          fromExpr = call.getQualifier()
          or
          inModel.isQualifierAddress() and
          fromExpr = call.getQualifier()
        ) and
        call.getTarget() = f and
        // AST dataflow treats a reference as if it were the referred-to object, while the dataflow
        // models treat references as pointers. If the return type of the call is a reference, then
        // look for data flow to the referred-to object, rather than the reference itself.
        if call.getType().getUnspecifiedType() instanceof ReferenceType
        then outModel.isReturnValueDeref()
        else outModel.isReturnValue()
      )
    )
}

private predicate exprToDefinitionByReferenceStep(Expr exprIn, Expr argOut) {
  exists(DataFlowFunction f, Call call, FunctionOutput outModel, int argOutIndex |
    call.getTarget() = f and
    argOut = call.getArgument(argOutIndex) and
    outModel.isParameterDeref(argOutIndex) and
    exists(int argInIndex, FunctionInput inModel | f.hasDataFlow(inModel, outModel) |
      inModel.isParameterDeref(argInIndex) and
      call.passesByReference(argInIndex, exprIn)
      or
      inModel.isParameter(argInIndex) and
      exprIn = call.getArgument(argInIndex)
    )
  )
}

private module FieldFlow {
  private import DataFlowImplCommon
  private import DataFlowPrivate
  private import semmle.code.cpp.dataflow.DataFlow

  /**
   * A configuration for finding local-only flow through fields.
   *
   * To keep the flow local to a single function, we put barriers on parameters
   * and return statements. Sources and sinks are the values that go into and
   * out of fields, respectively.
   */
  private module FieldConfig implements DataFlow::ConfigSig {
    predicate isSource(Node source) {
      storeStep(source, _, _)
      or
      // Also mark `foo(a.b);` as a source when `a.b` may be overwritten by `foo`.
      readStep(_, _, any(Node node | node.asExpr() = source.asDefiningArgument()))
    }

    predicate isSink(Node sink) { readStep(_, _, sink) }

    predicate isBarrier(Node node) { node instanceof ParameterNode }

    predicate isBarrierOut(Node node) {
      node.asExpr().getParent() instanceof ReturnStmt
      or
      node.asExpr().getParent() instanceof ThrowExpr
    }
  }

  private module Flow = DataFlow::Global<FieldConfig>;

  predicate fieldFlow(Node node1, Node node2) {
    Flow::flow(node1, node2) and
    // This configuration should not be able to cross function boundaries, but
    // we double-check here just to be sure.
    getNodeEnclosingCallable(node1) = getNodeEnclosingCallable(node2)
  }
}

VariableAccess getAnAccessToAssignedVariable(Expr assign) {
  (
    assign instanceof Assignment
    or
    assign instanceof CrementOperation
  ) and
  exists(FlowVar var |
    var.definedByExpr(_, assign) and
    result = var.getAnAccess()
  )
}

private newtype TContent =
  TFieldContent(Field f) or
  TCollectionContent() or
  TArrayContent()

/**
 * A description of the way data may be stored inside an object. Examples
 * include instance fields, the contents of a collection object, or the contents
 * of an array.
 */
class Content extends TContent {
  /** Gets a textual representation of this element. */
  abstract string toString();

  predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    path = "" and sl = 0 and sc = 0 and el = 0 and ec = 0
  }
}

/** A reference through an instance field. */
class FieldContent extends Content, TFieldContent {
  Field f;

  FieldContent() { this = TFieldContent(f) }

  Field getField() { result = f }

  override string toString() { result = f.toString() }

  override predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    f.getLocation().hasLocationInfo(path, sl, sc, el, ec)
  }
}

/** A reference through an array. */
private class ArrayContent extends Content, TArrayContent {
  override string toString() { result = "[]" }
}

/** A reference through the contents of some collection-like container. */
private class CollectionContent extends Content, TCollectionContent {
  override string toString() { result = "<element>" }
}

/**
 * An entity that represents a set of `Content`s.
 *
 * The set may be interpreted differently depending on whether it is
 * stored into (`getAStoreContent`) or read from (`getAReadContent`).
 */
class ContentSet instanceof Content {
  /** Gets a content that may be stored into when storing into this set. */
  Content getAStoreContent() { result = this }

  /** Gets a content that may be read from when reading from this set. */
  Content getAReadContent() { result = this }

  /** Gets a textual representation of this content set. */
  string toString() { result = super.toString() }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    super.hasLocationInfo(path, sl, sc, el, ec)
  }
}

/**
 * Holds if the guard `g` validates the expression `e` upon evaluating to `branch`.
 *
 * The expression `e` is expected to be a syntactic part of the guard `g`.
 * For example, the guard `g` might be a call `isSafe(x)` and the expression `e`
 * the argument `x`.
 */
signature predicate guardChecksSig(GuardCondition g, Expr e, boolean branch);

/**
 * Provides a set of barrier nodes for a guard that validates an expression.
 *
 * This is expected to be used in `isBarrier`/`isSanitizer` definitions
 * in data flow and taint tracking.
 */
module BarrierGuard<guardChecksSig/3 guardChecks> {
  /** Gets a node that is safely guarded by the given guard check. */
  ExprNode getABarrierNode() {
    exists(GuardCondition g, SsaDefinition def, Variable v, boolean branch |
      result.getExpr() = def.getAUse(v) and
      guardChecks(g, def.getAUse(v), branch) and
      g.controls(result.getExpr().getBasicBlock(), branch)
    )
  }
}

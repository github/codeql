/**
 * DEPRECATED: Use the new data flow library instead.
 *
 * Provides a class `DataFlowNode` for working with a data flow graph-based
 * program representation.
 *
 * We distinguish between _local flow_ and _non-local flow_.
 *
 * Local flow only considers three kinds of data flow:
 *
 *   1. Flow within an expression, for example from the operands of a `&&`
 *      expression to the expression itself.
 *   2. Flow through local variables, that is, from definitions to uses.
 *      Captured variables are treated flow-insensitively, that is, all
 *      definitions are considered to flow to all uses, while for non-captured
 *      variables only definitions that can actually reach a use are considered.
 *   3. Flow into and out of immediately invoked function expressions, that is,
 *      flow from arguments to parameters, and from returned expressions to the
 *      function expression itself.
 *
 * Non-local flow additionally tracks data flow through global variables.
 *
 * Flow through object properties or function calls is not modelled (except
 * for immediately invoked functions as explained above).
 */

import javascript

/**
 * DEPRECATED: Use `DataFlow::Node` instead.
 *
 * An expression or function/class declaration, viewed as a node in a data flow graph.
 */
deprecated class DataFlowNode extends @dataflownode {
  /**
   * Gets another flow node from which data may flow to this node in one local step.
   */
  cached
  DataFlowNode localFlowPred() {
    // to be overridden by subclasses
    none()
  }

  /**
   * Gets another flow node from which data may flow to this node in one non-local step.
   */
  DataFlowNode nonLocalFlowPred() {
    // to be overridden by subclasses
    none()
  }

  /**
   * Gets another flow node from which data may flow to this node in one step,
   * either locally or non-locally.
   */
  DataFlowNode flowPred() {
    result = localFlowPred() or result = nonLocalFlowPred()
  }

  /**
   * Gets a source flow node (that is, a node without a `localFlowPred()`) from which data
   * may flow to this node in zero or more local steps.
   */
  cached deprecated
  DataFlowNode getALocalSource() {
    isLocalSource(result) and
    (
      result = this
      or
      locallyReachable(result, this)
    )
  }

  /**
   * Gets a source flow node (that is, a node without a `flowPred()`) from which data
   * may flow to this node in zero or more steps, considering both local and non-local flow.
   */
  DataFlowNode getASource() {
    if exists(flowPred()) then
      result = flowPred().getASource()
    else
      result = this
  }

  /**
   * Holds if the flow information for this node is incomplete.
   *
   * This predicate holds if there may be a source flow node from which data flows into
   * this node, but that node is not a result of `getASource()` due to analysis incompleteness.
   * The parameter `cause` is bound to a string describing the source of incompleteness.
   *
   * For example, since this analysis is intra-procedural, data flow from actual arguments
   * to formal parameters is not modeled. Hence, if `p` is an access to a parameter,
   * `p.getASource()` does _not_ return the corresponding argument, and
   * `p.isIncomplete("call")` holds.
   */
  predicate isIncomplete(DataFlowIncompleteness cause) {
    none()
  }

  /** Gets type inference results for this data flow node. */
  DataFlow::AnalyzedNode analyze() {
    result = DataFlow::valueNode(this).analyze()
  }

  /** Gets a textual representation of this element. */
  string toString() { result = this.(ASTNode).toString() }

  /** Gets the location of the AST node underlying this data flow node. */
  Location getLocation() { result = this.(ASTNode).getLocation() }
}

/** Holds if `nd` is a local source, that is, it has no local data flow predecessor. */
private deprecated predicate isLocalSource(DataFlowNode nd) {
  not exists(nd.localFlowPred())
}

/** Holds if data may flom from `nd` to `succ` in one local step. */
private deprecated predicate localFlow(DataFlowNode nd, DataFlowNode succ) {
  nd = succ.localFlowPred()
}

/**
 * Holds if `snk` is reachable from `src` in one or more local steps, where `src`
 * itself is reachable from a local source in zere or more local steps.
 */
private deprecated predicate locallyReachable(DataFlowNode src, DataFlowNode snk) =
  boundedFastTC(localFlow/2, isLocalSource/1)(src, snk)

/**
 * A classification of flows that are not modeled, or only modeled incompletely, by
 * `DataFlowNode`.
 */
deprecated class DataFlowIncompleteness extends string {
  DataFlowIncompleteness() {
    this = "call" or   // lack of inter-procedural analysis
    this = "heap" or   // lack of heap modeling
    this = "import" or // lack of module import/export modeling
    this = "global" or // incomplete modeling of global object
    this = "yield" or  // lack of yield/async/await modeling
    this = "eval" or   // lack of reflection modeling
    this = "namespace" // lack of exported variable modeling
  }
}

/**
 * A variable access, viewed as a data flow node.
 */
private deprecated class VarAccessFlow extends DataFlowNode, @varaccess {
  VarAccessFlow() { this instanceof RValue }

  /**
   * Gets a data flow node representing a local variable definition to which
   * this access may refer.
   */
  private VarDefFlow getALocalDef() {
    exists (SsaDefinition def |
      this = def.getVariable().getAUse() and
      result = def.getAContributingVarDef()
    )
  }

  override DataFlowNode localFlowPred() {
    // flow through local variable
    result = getALocalDef().getSourceNode()
  }

  override DataFlowNode nonLocalFlowPred() {
    exists (GlobalVariable v, VarDefFlow def |
      v = def.getAVariable() and
      result = def.getSourceNode() and
      this = v.getAnAccess()
    )
  }

  override predicate isIncomplete(DataFlowIncompleteness cause) {
    exists (SsaDefinition ssa, VarDefFlow def |
      this = ssa.getVariable().getAUse() and def = ssa.getAContributingVarDef() |
      def.isIncomplete(cause)
    )
    or
    exists (Variable v | this = v.getAnAccess() |
      v.isGlobal() and cause = "global" or
      globalIsIncomplete(v, cause) or
      v.isNamespaceExport() and cause = "namespace" or
      v instanceof ArgumentsVariable and cause = "call" or
      any(DirectEval e).mayAffect(v) and cause = "eval"
    )
  }
}

/**
 * Holds if `v` has a definition that introduces analysis incompleteness due to
 * the given `cause`.
 *
 * We exclude cause `"global"`, since all global variables have this incompleteness anyway.
 */
pragma[noinline]
private deprecated predicate globalIsIncomplete(GlobalVariable v, DataFlowIncompleteness cause) {
  exists (VarDefFlow def |
    v = def.getAVariable() and
    def.isIncomplete(cause) and
    cause != "global"
  )
}

/**
 * A variable definition, viewed as a contributor to the data flow graph.
 */
private deprecated class VarDefFlow extends VarDef {
  /**
   * Gets a data flow node representing the value assigned by this
   * definition.
   */
  DataFlowNode getSourceNode() {
    // follow one step of the def-use chain, but only for definitions where
    // the lhs is a simple variable reference (as opposed to a destructuring
    // pattern)
    result = getSource() and getTarget() instanceof VarRef
  }

  /**
   * Holds if this definition is analyzed imprecisely due to `cause`.
   */
  predicate isIncomplete(DataFlowIncompleteness cause) {
    this instanceof Parameter and cause = "call" or
    this instanceof ImportSpecifier and cause = "import" or
    exists (EnhancedForLoop efl | this = efl.getIteratorExpr()) and cause = "heap" or
    exists (ComprehensionBlock cb | this = cb.getIterator()) and cause = "yield" or
    getTarget() instanceof DestructuringPattern and cause = "heap"
  }
}

/**
 * An IIFE parameter, viewed as a contributor to the data flow graph.
 */
private deprecated class IifeParameterFlow extends VarDefFlow {
  /** The function of which this is a parameter. */
  ImmediatelyInvokedFunctionExpr iife;

  IifeParameterFlow() {
    this instanceof SimpleParameter and
    iife.argumentPassing(this, _)
  }

  override DataFlowNode getSourceNode() {
    iife.argumentPassing(this, result)
  }

  override predicate isIncomplete(DataFlowIncompleteness cause) { none() }
}

/**
 * An ECMAScript 2015 import, viewed as a contributor to the data flow graph.
 */
private deprecated class ImportSpecifierFlow extends VarDefFlow, ImportSpecifier {

  override DataFlowNode getSourceNode() {
    result = getLocal()
  }

}

/** A parenthesized expression, viewed as a data flow node. */
private deprecated class ParExprFlow extends DataFlowNode, @parexpr {
  override DataFlowNode localFlowPred() {
    result = this.(ParExpr).getExpression()
  }
}

/** A type assertion, `E as T` or `<T> E`, viewed as a data flow node. */
private deprecated class TypeAssertionFlow extends DataFlowNode, @typeassertion {
  override DataFlowNode localFlowPred() {
    result = this.(TypeAssertion).getExpression()
  }
}

/** A non-null assertion, `E!` viewed as a data flow node. */
private deprecated class NonNullAssertionFlow extends DataFlowNode, @non_null_assertion {
  override DataFlowNode localFlowPred() {
    result = this.(NonNullAssertion).getExpression()
  }
}

/** An expression with type arguments, viewed as a data flow node. */
private deprecated class ExpressionWithTypeArgumentsFlow extends DataFlowNode, @expressionwithtypearguments {
  override DataFlowNode localFlowPred() {
    result = this.(ExpressionWithTypeArguments).getExpression()
  }
}

/** A sequence expression, viewed as a data flow node. */
private deprecated class SeqExprFlow extends DataFlowNode, @seqexpr {
  override DataFlowNode localFlowPred() {
    result = this.(SeqExpr).getLastOperand()
  }
}

/** A short-circuiting logical expression, viewed as a data flow node. */
private deprecated class LogicalBinaryExprFlow extends DataFlowNode, @binaryexpr {
  LogicalBinaryExprFlow() { this instanceof LogicalBinaryExpr }

  override DataFlowNode localFlowPred() {
    result = this.(LogicalBinaryExpr).getAnOperand()
  }
}

/** An assignment expression, viewed as a data flow node. */
private deprecated class AssignExprFlow extends DataFlowNode, @assignexpr {
  override DataFlowNode localFlowPred() {
    result = this.(AssignExpr).getRhs()
  }
}

/** A conditional expression, viewed as a data flow node. */
private deprecated class ConditionalExprFlow extends DataFlowNode, @conditionalexpr {
  override DataFlowNode localFlowPred() {
    result = this.(ConditionalExpr).getABranch()
  }
}

/**
 * A data flow node whose value involves inter-procedural flow,
 * and which hence is analyzed incompletely.
 */
private deprecated class InterProcFlow extends DataFlowNode, @expr {
  InterProcFlow() {
    this instanceof InvokeExpr or
    this instanceof ThisExpr or
    this instanceof SuperExpr or
    this instanceof NewTargetExpr or
    this instanceof FunctionBindExpr or
    this instanceof TaggedTemplateExpr
  }

  override predicate isIncomplete(DataFlowIncompleteness cause) { cause = "call" }
}

/** An external module reference, viewed as a data flow node. */
private deprecated class ExternalModuleFlow extends DataFlowNode, @externalmodulereference {
  override predicate isIncomplete(DataFlowIncompleteness cause) { cause = "import" }
}

/**
 * An immediately invoked function expression, viewed as a data flow node.
 *
 * Unlike other calls, we can analyze the value of an IIFE completely, hence
 * we override `InterProcFlow`.
 */
private deprecated class IifeFlow extends InterProcFlow, @callexpr {
  /** The function this IIFE invokes. */
  ImmediatelyInvokedFunctionExpr iife;

  IifeFlow() {
    this = iife.getInvocation()
  }

  override DataFlowNode localFlowPred() {
    result = iife.getAReturnedExpr()
  }

  override predicate isIncomplete(DataFlowIncompleteness cause) { none() }
}

/**
 * A property access, viewed as a data flow node.
 */
private deprecated class PropAccessFlow extends DataFlowNode, @propaccess {
  override predicate isIncomplete(DataFlowIncompleteness cause) { cause = "heap" }
}

/**
 * A data flow node whose value involves co-routines or promises,
 * and which hence is analyzed incompletely.
 */
private deprecated class IteratorFlow extends DataFlowNode, @expr {
  IteratorFlow() {
    this instanceof YieldExpr or
    this instanceof AwaitExpr or
    this instanceof FunctionSentExpr or
    this instanceof DynamicImportExpr
  }

  override predicate isIncomplete(DataFlowIncompleteness cause) { cause = "yield" }
}

/**
 * A data flow node that reads or writes an object property.
 */
abstract deprecated class PropRefNode extends DataFlowNode {
  /**
   * Gets the data flow node corresponding to the base object
   * whose property is read from or written to.
   */
  abstract DataFlowNode getBase();

  /**
   * Gets the expression specifying the name of the property being
   * read or written. This is usually either an identifier or a literal.
   */
  abstract Expr getPropertyNameExpr();

  /**
   * Gets the name of the property being read or written,
   * if it can be statically determined.
   *
   * This predicate is undefined for dynamic property references
   * such as `e[computePropertyName()]` and for spread/rest
   * properties.
   */
  abstract string getPropertyName();
}

/**
 * A data flow node that writes to an object property.
 */
abstract deprecated class PropWriteNode extends PropRefNode {
  /**
   * Gets the data flow node corresponding to the value being written,
   * if it can be statically determined.
   *
   * This predicate is undefined for spread properties, accessor
   * properties, and most uses of `Object.defineProperty`.
   */
  abstract DataFlowNode getRhs();

  /**
   * Holds if this data flow node writes the value of `rhs` to property
   * `prop` of the object that `base` evaluates to.
   */
  pragma[noinline]
  predicate writes(DataFlow::Node base, string prop, DataFlow::Node rhs) {
    base = DataFlow::valueNode(getBase()) and
    prop = getPropertyName() and
    rhs = DataFlow::valueNode(getRhs())
  }
}

/**
 * A property assignment, viewed as a data flow node.
 */
private deprecated class PropAssignNode extends PropWriteNode, @propaccess {
  PropAssignNode() { this instanceof LValue }
  override DataFlowNode getBase() { result = this.(PropAccess).getBase() }
  override Expr getPropertyNameExpr() { result = this.(PropAccess).getPropertyNameExpr() }
  override string getPropertyName() { result = this.(PropAccess).getPropertyName() }
  override DataFlowNode getRhs() { result = this.(LValue).getRhs() }
}

/**
 * A property of an object literal, viewed as a data flow node that writes
 * to the corresponding property.
 */
private deprecated class PropInitNode extends PropWriteNode, @property {
  /** Gets the property that this node wraps. */
  private Property getProperty() { result = this }
  override DataFlowNode getBase() { result = getProperty().getObjectExpr() }
  override Expr getPropertyNameExpr() { result = getProperty().getNameExpr() }
  override string getPropertyName() { result = getProperty().getName() }
  override DataFlowNode getRhs() { result = getProperty().(ValueProperty).getInit() }
}

/**
 * A call to `Object.defineProperty`, viewed as a data flow node that
 * writes to the corresponding property.
 */
private deprecated class ObjectDefinePropNode extends PropWriteNode, @callexpr {
  CallToObjectDefineProperty odp;
  ObjectDefinePropNode() { this = odp.asExpr() }
  override DataFlowNode getBase() { result = odp.getBaseObject().asExpr() }
  override Expr getPropertyNameExpr() { result = odp.getArgument(1).asExpr() }
  override string getPropertyName() { result = odp.getPropertyName() }
  override DataFlowNode getRhs() {
    exists (ObjectExpr propdesc |
      propdesc = odp.getPropertyDescriptor().asExpr() and
      result = propdesc.getPropertyByName("value").getInit()
    )
  }
}

/**
 * A static member definition, viewed as a data flow node that adds
 * a property to the class.
 */
private deprecated class StaticMemberAsWrite extends PropWriteNode, @expr {
  StaticMemberAsWrite() {
    exists (MemberDefinition md | md.isStatic() and this = md.getNameExpr())
  }
  /** Gets the member definition that this node wraps. */
  private MemberDefinition getMember() { this = result.getNameExpr() }
  override DataFlowNode getBase() { result = getMember().getDeclaringClass() }
  override Expr getPropertyNameExpr() { result = getMember().getNameExpr() }
  override string getPropertyName() { result = getMember().getName() }
  override DataFlowNode getRhs() { result = getMember().getInit() }
}

/**
 * A spread property of an object literal, viewed as a data flow node that writes
 * properties of the object literal.
 */
private deprecated class SpreadPropertyAsWrite extends PropWriteNode, @expr {
  SpreadPropertyAsWrite() { exists (SpreadProperty prop | this = prop.getInit()) }
  override DataFlowNode getBase() { result.(ObjectExpr).getAProperty().getInit() = this }
  override Expr getPropertyNameExpr() { none() }
  override string getPropertyName() { none() }
  override DataFlowNode getRhs() { none() }
}


/**
 * A JSX attribute, viewed as a data flow node that writes properties to
 * the JSX element it is in.
 */
private deprecated class JSXAttributeAsWrite extends PropWriteNode, @identifier {
  JSXAttributeAsWrite() { exists (JSXAttribute attr | this = attr.getNameExpr()) }
  /** Gets the JSX attribute that this node wraps. */
  private JSXAttribute getAttribute() { result.getNameExpr() = this }
  override DataFlowNode getBase() { result = getAttribute().getElement() }
  override Expr getPropertyNameExpr() { result = this }
  override string getPropertyName() { result = this.(Identifier).getName() }
  override DataFlowNode getRhs() { result = getAttribute().getValue() }
}

/**
 * A data flow node that reads an object property.
 */
abstract deprecated class PropReadNode extends PropRefNode {
  /**
   * Gets the default value of this property read, if any.
   */
  abstract DataFlowNode getDefault();
}

/**
 * A property access in rvalue position.
 */
private deprecated class PropAccessReadNode extends PropReadNode, @propaccess {
  PropAccessReadNode() { this instanceof RValue }
  override DataFlowNode getBase() { result = this.(PropAccess).getBase() }
  override Expr getPropertyNameExpr() { result = this.(PropAccess).getPropertyNameExpr() }
  override string getPropertyName() { result = this.(PropAccess).getPropertyName() }
  override DataFlowNode getDefault() { none() }
}

/**
 * A property pattern viewed as a property read; for instance, in
 * `var { p: q } = o`, `p` is a read of property `p` of `o`.
 */
private deprecated class PropPatternReadNode extends PropReadNode, @expr {
  PropPatternReadNode() { this = any(PropertyPattern p).getNameExpr() }
  /** Gets the property pattern that this node wraps. */
  private PropertyPattern getPropertyPattern() { this = result.getNameExpr() }
  override DataFlowNode getBase() {
    exists (VarDef d |
      d.getTarget() = getPropertyPattern().getObjectPattern() and
      result = d.getSource()
    )
  }
  override Expr getPropertyNameExpr() { result = getPropertyPattern().getNameExpr() }
  override string getPropertyName() { result = getPropertyPattern().getName() }
  override DataFlowNode getDefault() { result = getPropertyPattern().getDefault() }
}

/**
 * A rest pattern viewed as a property read; for instance, in
 * `var { ...ps } = o`, `ps` is a read of all properties of `o`.
 */
private deprecated class RestPropertyAsRead extends PropReadNode {
  RestPropertyAsRead() { this = any(ObjectPattern p).getRest() }
  override DataFlowNode getBase() {
    exists (VarDef d |
      d.getTarget().(ObjectPattern).getRest() = this and
      result = d.getSource()
    )
  }
  override Expr getPropertyNameExpr() { none() }
  override string getPropertyName() { none() }
  override DataFlowNode getDefault() { none() }
}

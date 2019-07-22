/**
 * Provides classes for working with a data flow graph-based
 * program representation.
 *
 * We currently consider three kinds of data flow:
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
 * Flow through global variables, object properties or function calls is not
 * modeled (except for immediately invoked functions as explained above).
 */

import javascript

module DataFlow {
  cached
  private newtype TNode =
    TValueNode(AST::ValueNode nd) or
    TSsaDefNode(SsaDefinition d) or
    TPropNode(@property p) or
    TRestPatternNode(DestructuringPattern dp, Expr rest) { rest = dp.getRest() } or
    TElementPatternNode(ArrayPattern ap, Expr p) { p = ap.getElement(_) } or
    TElementNode(ArrayExpr arr, Expr e) { e = arr.getAnElement() } or
    TReflectiveCallNode(MethodCallExpr ce, string kind) {
      ce.getMethodName() = kind and
      (kind = "call" or kind = "apply")
    } or
    TThisNode(StmtContainer f) { f.(Function).getThisBinder() = f or f instanceof TopLevel } or
    TUnusedParameterNode(SimpleParameter p) {
      not exists(SSA::definition(p))
    } or
    TDestructuredModuleImportNode(ImportDeclaration decl) {
      exists(decl.getASpecifier().getImportedName())
    } or
    THtmlAttributeNode(HTML::Attribute attr) or
    TExceptionalFunctionReturnNode(Function f) or
    TExceptionalInvocationReturnNode(InvokeExpr e)

  /**
   * A node in the data flow graph.
   */
  class Node extends TNode {
    /**
     * Gets a data flow node from which data may flow to this node in one local step.
     */
    Node getAPredecessor() { localFlowStep(result, this) }

    /**
     * Gets a data flow node to which data may flow from this node in one local step.
     */
    Node getASuccessor() { localFlowStep(this, result) }

    /**
     * Gets a source node from which data may flow to this node in zero or more local steps.
     */
    SourceNode getALocalSource() { result.flowsTo(this) }

    /**
     * Holds if the flow information for this node is incomplete.
     *
     * This predicate holds if there may be a source flow node from which data flows into
     * this node, but that node is not a result of `getALocalSource()` due to analysis
     * incompleteness. The parameter `cause` is bound to a string describing the source of
     * incompleteness.
     *
     * For example, since this analysis is intra-procedural, data flow from actual arguments
     * to formal parameters is not modeled. Hence, if `p` is an access to a parameter,
     * `p.getALocalSource()` does _not_ return the corresponding argument, and
     * `p.isIncomplete("call")` holds.
     */
    predicate isIncomplete(Incompleteness cause) { isIncomplete(this, cause) }

    /** Gets type inference results for this data flow node. */
    AnalyzedNode analyze() { result = this }

    /** Gets the expression corresponding to this data flow node, if any. */
    Expr asExpr() { this = TValueNode(result) }

    /** Gets the AST node corresponding to this data flow node, if any. */
    ASTNode getAstNode() { none() }

    /** Gets the basic block to which this node belongs. */
    BasicBlock getBasicBlock() { none() }

    /** Gets the container in which this node occurs. */
    StmtContainer getContainer() { result = getBasicBlock().getContainer() }

    /** Gets the toplevel in which this node occurs. */
    TopLevel getTopLevel() { result = getContainer().getTopLevel() }

    /**
     * Holds if this data flow node accesses the global variable `g`, either directly
     * or through the `window` object.
     */
    predicate accessesGlobal(string g) { globalVarRef(g).flowsTo(this) }

    /** Holds if this node may evaluate to the string `s`, possibly through local data flow. */
    predicate mayHaveStringValue(string s) { getAPredecessor().mayHaveStringValue(s) }

    /** Gets the string value of this node, if it is a string literal or constant string concatenation. */
    string getStringValue() { result = asExpr().getStringValue() }

    /** Holds if this node may evaluate to the Boolean value `b`. */
    predicate mayHaveBooleanValue(boolean b) {
      b = analyze().getAValue().(AbstractBoolean).getBooleanValue()
    }

    /** Gets the integer value of this node, if it is an integer constant. */
    int getIntValue() { result = asExpr().getIntValue() }

    /** Gets a function value that may reach this node. */
    FunctionNode getAFunctionValue() {
      result.getAstNode() = analyze().getAValue().(AbstractCallable).getFunction()
    }

    /**
     * Holds if this expression may refer to the initial value of parameter `p`.
     */
    predicate mayReferToParameter(Parameter p) { parameterNode(p).(SourceNode).flowsTo(this) }

    /**
     * Holds if this element is at the specified location.
     * The location spans column `startcolumn` of line `startline` to
     * column `endcolumn` of line `endline` in file `filepath`.
     * For more information, see
     * [Locations](https://help.semmle.com/QL/learn-ql/ql/locations.html).
     */
    predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      filepath = "" and
      startline = 0 and
      startcolumn = 0 and
      endline = 0 and
      endcolumn = 0
    }

    /** Gets the file this data flow node comes from. */
    File getFile() { hasLocationInfo(result.getAbsolutePath(), _, _, _, _) }

    /** Gets the start line of this data flow node. */
    int getStartLine() { hasLocationInfo(_, result, _, _, _) }

    /** Gets the start column of this data flow node. */
    int getStartColumn() { hasLocationInfo(_, _, result, _, _) }

    /** Gets the end line of this data flow node. */
    int getEndLine() { hasLocationInfo(_, _, _, result, _) }

    /** Gets the end column of this data flow node. */
    int getEndColumn() { hasLocationInfo(_, _, _, _, result) }

    /** Gets a textual representation of this element. */
    string toString() { none() }

    /**
     * Gets the immediate predecessor of this node, if any.
     *
     * A node with an immediate predecessor can usually only have the value that flows
     * into its from its immediate predecessor, currently with two exceptions:
     *
     * - An immediately-invoked function expression with a single return expression `e`
     *   has `e` as its immediate predecessor, even if the function can fall over the
     *   end and return `undefined`.
     *
     * - A destructuring property pattern with a default value has both the `PropRead`
     *   and its default value as immediate predecessors.
     */
    cached
    DataFlow::Node getImmediatePredecessor() {
      // Use of variable -> definition of variable
      exists(SsaVariable var |
        this = DataFlow::valueNode(var.getAUse()) and
        result.(DataFlow::SsaDefinitionNode).getSsaVariable() = var
      )
      or
      // Refinement of variable -> original definition of variable
      exists(SsaRefinementNode refinement |
        this.(DataFlow::SsaDefinitionNode).getSsaVariable() = refinement.getVariable() and
        result.(DataFlow::SsaDefinitionNode).getSsaVariable() = refinement.getAnInput()
      )
      or
      // Definition of variable -> RHS of definition
      exists(SsaExplicitDefinition def |
        this = TSsaDefNode(def) and
        result = def.getRhsNode()
      )
      or
      // IIFE call -> return value of IIFE
      // Note: not sound in case function falls over end and returns 'undefined'
      exists(Function fun |
        localCall(this.asExpr(), fun) and
        result = fun.getAReturnedExpr().flow() and
        strictcount(fun.getAReturnedExpr()) = 1
      )
      or
      // IIFE parameter -> IIFE call
      exists(Parameter param |
        this = DataFlow::parameterNode(param) and
        localArgumentPassing(result.asExpr(), param)
      )
      or
      // `{ x } -> e` in `let { x } = e`
      exists(DestructuringPattern pattern |
        this = TValueNode(pattern)
      |
        exists(VarDef def |
          pattern = def.getTarget() and
          result = DataFlow::valueNode(def.getDestructuringSource())
        )
        or
        result = patternPropRead(pattern)
      )
    }
  }

  /**
   * An expression or a declaration of a function, class, namespace or enum,
   * viewed as a node in the data flow graph.
   */
  class ValueNode extends Node, TValueNode {
    AST::ValueNode astNode;

    ValueNode() { this = TValueNode(astNode) }

    /** Gets the expression or declaration this node corresponds to. */
    override AST::ValueNode getAstNode() { result = astNode }

    override predicate mayHaveStringValue(string s) {
      Node.super.mayHaveStringValue(s) or
      astNode.(ConstantString).getStringValue() = s
    }

    override BasicBlock getBasicBlock() { astNode = result.getANode() }

    override predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      astNode.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    }

    override string toString() { result = astNode.toString() }
  }

  /**
   * A node in the data flow graph which corresponds to an SSA variable definition.
   */
  class SsaDefinitionNode extends Node, TSsaDefNode {
    SsaDefinition ssa;

    SsaDefinitionNode() { this = TSsaDefNode(ssa) }

    /** Gets the SSA variable defined at this data flow node. */
    SsaVariable getSsaVariable() { result = ssa.getVariable() }

    override BasicBlock getBasicBlock() { result = ssa.getBasicBlock() }

    override predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      ssa.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    }

    override string toString() { result = ssa.getSourceVariable().getName() }

    override ASTNode getAstNode() { none() }
  }

  /**
   * A node in the data flow graph which corresponds to a `@property`.
   */
  private class PropNode extends Node, TPropNode {
    @property prop;

    PropNode() { this = TPropNode(prop) }

    override BasicBlock getBasicBlock() { result = prop.(ControlFlowNode).getBasicBlock() }

    override predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      prop
          .(Locatable)
          .getLocation()
          .hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    }

    override string toString() { result = prop.(ASTNode).toString() }

    override ASTNode getAstNode() { result = prop }
  }

  /**
   * A node in the data flow graph which corresponds to the rest pattern of a
   * destructuring pattern.
   */
  private class RestPatternNode extends Node, TRestPatternNode {
    DestructuringPattern pattern;

    Expr rest;

    RestPatternNode() { this = TRestPatternNode(pattern, rest) }

    override BasicBlock getBasicBlock() { result = rest.getBasicBlock() }

    override predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      rest.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    }

    override string toString() { result = "..." + rest.toString() }

    override ASTNode getAstNode() { result = rest }
  }

  /**
   * A node in the data flow graph which corresponds to an element pattern of an
   * array pattern.
   */
  private class ElementPatternNode extends Node, TElementPatternNode {
    ArrayPattern pattern;

    Expr elt;

    ElementPatternNode() { this = TElementPatternNode(pattern, elt) }

    override BasicBlock getBasicBlock() { result = elt.getBasicBlock() }

    override predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      elt.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    }

    override string toString() { result = elt.toString() }

    override ASTNode getAstNode() { result = elt }
  }

  /**
   * A node in the data flow graph which represents the (implicit) write of an element
   * in an array expression to the underlying array.
   *
   * That is, for an array expression `["first", ,"third"]`, we have two array element nodes,
   * one representing the write of expression `"first"` into the 0th element of the array,
   * and one representing the write of `"third"` into its second element.
   */
  private class ElementNode extends Node, TElementNode {
    ArrayExpr arr;

    Expr elt;

    ElementNode() { this = TElementNode(arr, elt) }

    override BasicBlock getBasicBlock() { result = elt.getBasicBlock() }

    override predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      elt.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    }

    override string toString() { result = elt.toString() }

    override ASTNode getAstNode() { result = elt }
  }

  /**
   * A node in the data flow graph which corresponds to the reflective call performed
   * by a `.call` or `.apply` invocation.
   */
  private class ReflectiveCallNode extends Node, TReflectiveCallNode {
    MethodCallExpr call;

    string kind;

    ReflectiveCallNode() { this = TReflectiveCallNode(call, kind) }

    override BasicBlock getBasicBlock() { result = call.getBasicBlock() }

    override predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      call.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    }

    override string toString() { result = "reflective call" }
  }

  /**
   * A node referring to the module imported at a named or default ES2015 import declaration.
   */
  private class DestructuredModuleImportNode extends Node, TDestructuredModuleImportNode {
    ImportDeclaration imprt;

    DestructuredModuleImportNode() { this = TDestructuredModuleImportNode(imprt) }

    override BasicBlock getBasicBlock() { result = imprt.getBasicBlock() }

    override predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      imprt.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    }

    override string toString() { result = imprt.toString() }
  }

  /**
   * A data flow node that reads or writes an object property or class member.
   *
   * The default subclasses do not model global variable references or variable
   * references inside `with` statements as property references.
   */
  abstract class PropRef extends Node {
    /**
     * Gets the data flow node corresponding to the base object
     * whose property is read from or written to.
     */
    abstract Node getBase();

    /**
     * Gets the expression specifying the name of the property being
     * read or written, if any.
     *
     * This is usually either an identifier or a literal.
     */
    abstract Expr getPropertyNameExpr();

    /**
     * Gets the name of the property being read or written,
     * if it can be statically determined.
     *
     * By default, this predicate is undefined for dynamic property references
     * such as `e[computePropertyName()]` and for spread/rest properties.
     */
    abstract string getPropertyName();

    /**
     * Holds if this data flow node accesses property `p` on base node `base`.
     */
    pragma[noinline]
    predicate accesses(Node base, string p) { getBase() = base and getPropertyName() = p }
  }

  /**
   * A data flow node that writes to an object property.
   */
  abstract class PropWrite extends PropRef {
    /**
     * Gets the data flow node corresponding to the value being written,
     * if it can be statically determined.
     *
     * This predicate is undefined for spread properties, accessor
     * properties, and most uses of `Object.defineProperty`.
     */
    abstract Node getRhs();

    /**
     * Holds if this data flow node writes the value of `rhs` to property
     * `prop` of the object that `base` evaluates to.
     */
    pragma[noinline]
    predicate writes(DataFlow::Node base, string prop, DataFlow::Node rhs) {
      base = getBase() and
      prop = getPropertyName() and
      rhs = getRhs()
    }

    /**
     * Gets the node where the property write happens in the control flow graph.
     */
    abstract ControlFlowNode getWriteNode();
  }

  /**
   * A property access in lvalue position, viewed as a property definition node.
   */
  private class PropLValueAsPropWrite extends PropWrite, ValueNode {
    override PropAccess astNode;

    PropLValueAsPropWrite() { astNode instanceof LValue }

    override Node getBase() { result = valueNode(astNode.getBase()) }

    override Expr getPropertyNameExpr() { result = astNode.getPropertyNameExpr() }

    override string getPropertyName() { result = astNode.getPropertyName() }

    override Node getRhs() { result = valueNode(astNode.(LValue).getRhs()) }

    override ControlFlowNode getWriteNode() { result = astNode.(LValue).getDefNode() }
  }

  /**
   * A property of an object literal, viewed as a data flow node that writes
   * to the corresponding property.
   */
  private class PropInitAsPropWrite extends PropWrite, PropNode {
    override Property prop;

    override Node getBase() { result = valueNode(prop.getObjectExpr()) }

    override Expr getPropertyNameExpr() { result = prop.getNameExpr() }

    override string getPropertyName() { result = prop.getName() }

    override Node getRhs() { result = valueNode(prop.(ValueProperty).getInit()) }

    override ControlFlowNode getWriteNode() { result = prop }
  }

  /**
   * A call to `Object.defineProperty`, viewed as a data flow node that
   * writes to the corresponding property.
   */
  private class ObjectDefinePropertyAsPropWrite extends PropWrite, ValueNode {
    CallToObjectDefineProperty odp;

    ObjectDefinePropertyAsPropWrite() { odp = this }

    override Node getBase() { result = odp.getBaseObject() }

    override Expr getPropertyNameExpr() { result = odp.getArgument(1).asExpr() }

    override string getPropertyName() { result = odp.getPropertyName() }

    override Node getRhs() {
      // not using `CallToObjectDefineProperty::getAPropertyAttribute` for performance reasons
      exists(ObjectLiteralNode propdesc |
        propdesc.flowsTo(odp.getPropertyDescriptor()) and
        propdesc.hasPropertyWrite("value", result)
      )
    }

    override ControlFlowNode getWriteNode() { result = odp.getAstNode() }
  }

  /**
   * A static member definition, viewed as a data flow node that adds
   * a property to the class.
   */
  private class StaticClassMemberAsPropWrite extends PropWrite, PropNode {
    override MemberDefinition prop;

    StaticClassMemberAsPropWrite() { prop.isStatic() }

    override Node getBase() { result = valueNode(prop.getDeclaringClass()) }

    override Expr getPropertyNameExpr() { result = prop.getNameExpr() }

    override string getPropertyName() { result = prop.getName() }

    override Node getRhs() {
      not prop instanceof AccessorMethodDefinition and
      result = valueNode(prop.getInit())
    }

    override ControlFlowNode getWriteNode() { result = prop }
  }

  /**
   * An instance method definition, viewed as a data flow node that adds
   * a property to an unseen value.
   */
  private class InstanceMethodAsPropWrite extends PropWrite, PropNode {
    override MethodDefinition prop;

    InstanceMethodAsPropWrite() { not prop.isStatic() }

    override Node getBase() { none() } // The prototype has no DataFlow node

    override Expr getPropertyNameExpr() { result = prop.getNameExpr() }

    override string getPropertyName() { result = prop.getName() }

    override Node getRhs() {
      not prop instanceof AccessorMethodDefinition and
      result = valueNode(prop.getInit())
    }

    override ControlFlowNode getWriteNode() { result = prop }
  }

  /**
   * A JSX attribute definition, viewed as a data flow node that writes properties to
   * the JSX element it is in.
   */
  private class JsxAttributeAsPropWrite extends PropWrite, PropNode {
    override JSXAttribute prop;

    override Node getBase() { result = valueNode(prop.getElement()) }

    override Expr getPropertyNameExpr() { result = prop.getNameExpr() }

    override string getPropertyName() { result = prop.getName() }

    override Node getRhs() { result = valueNode(prop.getValue()) }

    override ControlFlowNode getWriteNode() { result = prop }
  }

  /**
   * A field induced by an initializing constructor parameter, seen as a property write (TypeScript only).
   */
  private class ParameterFieldAsPropWrite extends PropWrite, PropNode {
    override ParameterField prop;

    override Node getBase() {
      result = thisNode(prop.getDeclaringClass().getConstructor().getBody())
    }

    override Expr getPropertyNameExpr() { result = prop.getNameExpr() }

    override string getPropertyName() { result = prop.getName() }

    override Node getRhs() {
      exists(Parameter param, Node paramNode |
        param = prop.getParameter() and
        parameterNode(paramNode, param)
        |
        result = paramNode
        or
        // special case: there is no SSA flow step for unused parameters
        paramNode instanceof UnusedParameterNode and
        result = param.getDefault().flow()
      )
    }

    override ControlFlowNode getWriteNode() { result = prop.getParameter() }
  }

  /**
   * An instance field with an initializer, seen as a property write.
   */
  private class InstanceFieldAsPropWrite extends PropWrite, PropNode {
    override FieldDefinition prop;

    InstanceFieldAsPropWrite() {
      not prop.isStatic() and
      not prop instanceof ParameterField and
      exists(prop.getInit())
    }

    override Node getBase() {
      result = thisNode(prop.getDeclaringClass().getConstructor().getBody())
    }

    override Expr getPropertyNameExpr() { result = prop.getNameExpr() }

    override string getPropertyName() { result = prop.getName() }

    override Node getRhs() { result = valueNode(prop.getInit()) }

    override ControlFlowNode getWriteNode() { result = prop }
  }

  /**
   * A data flow node that reads an object property.
   */
  abstract class PropRead extends PropRef, SourceNode { }

  /**
   * A property read, considered as a source node.
   *
   * Note that we cannot simplify the characteristic predicate to `this instanceof PropRead`,
   * since `PropRead` is itself a subclass of `SourceNode`.
   */
  private class PropReadAsSourceNode extends SourceNode::Range {
    PropReadAsSourceNode() {
      this = TPropNode(any(PropertyPattern p)) or
      this instanceof RestPatternNode or
      this instanceof ElementPatternNode
    }
  }

  /**
   * A property access in rvalue position.
   */
  private class PropRValueAsPropRead extends PropRead, ValueNode {
    override PropAccess astNode;

    PropRValueAsPropRead() { astNode instanceof RValue }

    override Node getBase() { result = valueNode(astNode.getBase()) }

    override Expr getPropertyNameExpr() { result = astNode.getPropertyNameExpr() }

    override string getPropertyName() { result = astNode.getPropertyName() }
  }

  /**
   * A property pattern viewed as a property read; for instance, in
   * `var { p: q } = o`, `p` is a read of property `p` of `o`.
   */
  private class PropPatternAsPropRead extends PropRead, PropNode {
    override PropertyPattern prop;

    /** Gets the value pattern of this property pattern. */
    Expr getValuePattern() { result = prop.getValuePattern() }

    override Node getBase() { result = TValueNode(prop.getObjectPattern()) }

    override Expr getPropertyNameExpr() { result = prop.getNameExpr() }

    override string getPropertyName() { result = prop.getName() }
  }

  /**
   * A rest pattern viewed as a property read; for instance, in
   * `var { ...ps } = o`, `ps` is a read of all properties of `o`, and similar
   * for `[ ...elts ] = arr`.
   */
  private class RestPatternAsPropRead extends PropRead, RestPatternNode {
    override Node getBase() { result = TValueNode(pattern) }

    override Expr getPropertyNameExpr() { none() }

    override string getPropertyName() { none() }
  }

  /**
   * An array element pattern viewed as a property read; for instance, in
   * `var [ x, y ] = arr`, `x` is a read of property 0 of `arr` and similar
   * for `y`.
   *
   * Note: We currently do not expose the array index as the property name,
   * instead treating it as a read of an unknown property.
   */
  private class ElementPatternAsPropRead extends PropRead, ElementPatternNode {
    override Node getBase() { result = TValueNode(pattern) }

    override Expr getPropertyNameExpr() { none() }

    override string getPropertyName() { none() }
  }

  /**
   * A named import specifier seen as a property read on the imported module.
   */
  private class ImportSpecifierAsPropRead extends PropRead {
    ImportDeclaration imprt;

    ImportSpecifier spec;

    ImportSpecifierAsPropRead() {
      spec = imprt.getASpecifier() and
      exists(spec.getImportedName()) and
      this = ssaDefinitionNode(SSA::definition(spec))
    }

    override Node getBase() { result = TDestructuredModuleImportNode(imprt) }

    override Expr getPropertyNameExpr() { result = spec.getImported() }

    override string getPropertyName() { result = spec.getImportedName() }
  }

  /**
   * A data flow node representing an unused parameter.
   *
   * This case exists to ensure all parameters have a corresponding data-flow node.
   * In most cases, parameters are represented by SSA definitions or destructuring pattern nodes.
   */
  private class UnusedParameterNode extends DataFlow::Node, TUnusedParameterNode {
    SimpleParameter p;

    UnusedParameterNode() { this = TUnusedParameterNode(p) }

    override string toString() { result = p.toString() }

    override ASTNode getAstNode() { result = p }

    override BasicBlock getBasicBlock() { result = p.getBasicBlock() }

    override predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      p.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    }
  }

  /**
   * A data flow node representing an HTML attribute.
   */
  class HtmlAttributeNode extends DataFlow::Node, THtmlAttributeNode {
    HTML::Attribute attr;

    HtmlAttributeNode() { this = THtmlAttributeNode(attr) }

    override string toString() { result = attr.toString() }

    override predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      attr.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    }

    /** Gets the attribute corresponding to this data flow node. */
    HTML::Attribute getAttribute() { result = attr }
  }

  /**
   * A data flow node representing the exceptions thrown by a function.
   */
  class ExceptionalFunctionReturnNode extends DataFlow::Node, TExceptionalFunctionReturnNode {
    Function function;

    ExceptionalFunctionReturnNode() { this = TExceptionalFunctionReturnNode(function) }

    override string toString() { result = "exceptional return of " + function.describe() }

    override predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      function.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    }

    override BasicBlock getBasicBlock() {
      result = function.(ExprOrStmt).getBasicBlock()
    }

    /**
     * Gets the function corresponding to this exceptional return node.
     */
    Function getFunction() { result = function }
  }

  /**
   * A data flow node representing the exceptions thrown by the callee of an invocation.
   */
  class ExceptionalInvocationReturnNode extends DataFlow::Node, TExceptionalInvocationReturnNode {
    InvokeExpr invoke;

    ExceptionalInvocationReturnNode() { this = TExceptionalInvocationReturnNode(invoke) }

    override string toString() { result = "exceptional return of " + invoke.toString() }

    override predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      invoke.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    }

    override BasicBlock getBasicBlock() {
      result = invoke.getBasicBlock()
    }

    /**
     * Gets the invocation corresponding to this exceptional return node.
     */
    DataFlow::InvokeNode getInvocation() { result = invoke.flow() }
  }

  /**
   * Provides classes representing various kinds of calls.
   *
   * Subclass the classes in this module to introduce new kinds of calls. If you want to
   * refine the behaviour of the analysis on existing kinds of calls, subclass `InvokeNode`
   * instead.
   */
  module Impl {
    /**
     * A data flow node representing a function invocation, either explicitly or reflectively,
     * and either with or without `new`.
     */
    abstract class InvokeNodeDef extends DataFlow::Node {
      /** Gets the name of the function or method being invoked, if it can be determined. */
      abstract string getCalleeName();

      /** Gets the data flow node specifying the function to be called. */
      abstract DataFlow::Node getCalleeNode();

      /** Gets the data flow node corresponding to the `i`th argument of this invocation. */
      abstract DataFlow::Node getArgument(int i);

      /** Gets the data flow node corresponding to an argument of this invocation. */
      abstract DataFlow::Node getAnArgument();

      /**
       * Gets a data flow node corresponding to an array of values being passed as
       * individual arguments to this invocation.
       */
      abstract DataFlow::Node getASpreadArgument();

      /** Gets the number of arguments of this invocation, if it can be determined. */
      abstract int getNumArgument();
    }

    /**
     * A data flow node representing a function call without `new`, either explicitly or
     * reflectively.
     */
    abstract class CallNodeDef extends InvokeNodeDef {
      /** Gets the data flow node corresponding to the receiver of this call, if any. */
      DataFlow::Node getReceiver() { none() }
    }

    /**
     * A data flow node representing a method call.
     */
    abstract class MethodCallNodeDef extends CallNodeDef {
      /** Gets the name of the method being invoked, if it can be determined. */
      abstract string getMethodName();
    }

    /**
     * A data flow node representing a function invocation with `new`.
     */
    abstract class NewNodeDef extends InvokeNodeDef { }

    /**
     * A data flow node representing an explicit (that is, non-reflective) function invocation.
     */
    class ExplicitInvokeNode extends InvokeNodeDef, DataFlow::ValueNode {
      override InvokeExpr astNode;

      override string getCalleeName() { result = astNode.getCalleeName() }

      override DataFlow::Node getCalleeNode() { result = DataFlow::valueNode(astNode.getCallee()) }

      override DataFlow::Node getArgument(int i) {
        not astNode.isSpreadArgument([0 .. i]) and
        result = DataFlow::valueNode(astNode.getArgument(i))
      }

      override DataFlow::Node getAnArgument() {
        exists(Expr arg | arg = astNode.getAnArgument() |
          not arg instanceof SpreadElement and
          result = DataFlow::valueNode(arg)
        )
      }

      override DataFlow::Node getASpreadArgument() {
        exists(SpreadElement arg | arg = astNode.getAnArgument() |
          result = DataFlow::valueNode(arg.getOperand())
        )
      }

      override int getNumArgument() {
        not astNode.isSpreadArgument(_) and result = astNode.getNumArgument()
      }
    }

    /**
     * A data flow node representing an explicit (that is, non-reflective) function call.
     */
    class ExplicitCallNode extends CallNodeDef, ExplicitInvokeNode {
      override CallExpr astNode;
    }

    /**
     * A data flow node representing an explicit (that is, non-reflective) method call.
     */
    private class ExplicitMethodCallNode extends MethodCallNodeDef, ExplicitCallNode {
      override MethodCallExpr astNode;

      override DataFlow::Node getReceiver() { result = DataFlow::valueNode(astNode.getReceiver()) }

      override string getMethodName() { result = astNode.getMethodName() }
    }

    /**
     * A data flow node representing a `new` expression.
     */
    private class ExplicitNewNode extends NewNodeDef, ExplicitInvokeNode {
      override NewExpr astNode;
    }

    /**
     * A data flow node representing a reflective function call.
     */
    private class ReflectiveCallNodeDef extends CallNodeDef {
      ExplicitMethodCallNode originalCall;

      string kind;

      ReflectiveCallNodeDef() { this = TReflectiveCallNode(originalCall.asExpr(), kind) }

      override string getCalleeName() {
        result = originalCall.getReceiver().asExpr().(PropAccess).getPropertyName()
      }

      override DataFlow::Node getCalleeNode() { result = originalCall.getReceiver() }

      override DataFlow::Node getReceiver() { result = originalCall.getArgument(0) }

      override DataFlow::Node getArgument(int i) {
        i >= 0 and kind = "call" and result = originalCall.getArgument(i + 1)
      }

      override DataFlow::Node getAnArgument() {
        kind = "call" and result = originalCall.getAnArgument() and result != getReceiver()
      }

      override DataFlow::Node getASpreadArgument() {
        kind = "apply" and
        result = originalCall.getArgument(1)
        or
        kind = "call" and
        result = originalCall.getASpreadArgument()
      }

      override int getNumArgument() {
        result >= 0 and kind = "call" and result = originalCall.getNumArgument() - 1
      }
    }
  }

  /**
   * An array element viewed as a property write; for instance, in
   * `var arr = ["first", , "third"]`, `"first"` is a write of property 0 of `arr`
   * and `"third"` is a write of property 2 of `arr`.
   *
   * Note: We currently do not expose the array index as the property name,
   * instead treating it as a write of an unknown property.
   */
  private class ElementNodeAsPropWrite extends PropWrite, ElementNode {
    override Expr getPropertyNameExpr() { none() }

    override string getPropertyName() { none() }

    override Node getRhs() { result = valueNode(elt) }

    override Node getBase() { result = valueNode(arr) }

    override ControlFlowNode getWriteNode() { result = arr }
  }

  /**
   * A data flow node representing `this` in a function or top-level.
   */
  private class ThisNodeInternal extends Node, TThisNode {
    override string toString() { result = "this" }

    override BasicBlock getBasicBlock() {
      exists(StmtContainer container | this = TThisNode(container) |
        result = container.getEntry()
      )
    }

    override predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      // Use the function entry as the location
      exists(StmtContainer container | this = TThisNode(container) |
        container.getEntry()
            .getLocation()
            .hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
      )
    }
  }

  /**
   * Gets the data flow node corresponding to `nd`.
   *
   * This predicate is only defined for expressions, properties, and for statements that declare
   * a function, a class, or a TypeScript namespace or enum.
   */
  ValueNode valueNode(ASTNode nd) { result.getAstNode() = nd }

  /**
   * Gets the data flow node corresponding to `e`.
   */
  ExprNode exprNode(Expr e) { result = valueNode(e) }

  /** Gets the data flow node corresponding to `ssa`. */
  SsaDefinitionNode ssaDefinitionNode(SsaDefinition ssa) { result = TSsaDefNode(ssa) }

  /** Gets the node corresponding to the initialization of parameter `p`. */
  ParameterNode parameterNode(Parameter p) { result.getParameter() = p }

  /**
   * INTERNAL: Use `parameterNode(Parameter)` instead.
   */
  predicate parameterNode(DataFlow::Node nd, Parameter p) {
    nd = ssaDefinitionNode(SSA::definition((SimpleParameter)p))
    or
    nd = TValueNode(p.(DestructuringPattern))
    or
    nd = TUnusedParameterNode(p)
  }

  /**
   * INTERNAL: Use `thisNode(StmtContainer container)` instead.
   */
  predicate thisNode(DataFlow::Node node, StmtContainer container) { node = TThisNode(container) }

  /**
   * Gets the node representing the receiver of the given function, or `this` in the given top-level.
   *
   * Has no result if `container` is an arrow function.
   */
  DataFlow::ThisNode thisNode(StmtContainer container) { result = TThisNode(container) }

  /**
   * INTERNAL. DO NOT USE.
   *
   * Gets the data flow node holding the reference to the module being destructured at
   * the given import declaration.
   */
  DataFlow::Node destructuredModuleImportNode(ImportDeclaration imprt) {
    result = TDestructuredModuleImportNode(imprt)
  }

  /**
   * INTERNAL: Use `ExceptionalInvocationReturnNode` instead.
   */
  predicate exceptionalInvocationReturnNode(DataFlow::Node nd, InvokeExpr invocation) {
    nd = TExceptionalInvocationReturnNode(invocation)
  }

  /**
   * INTERNAL: Use `ExceptionalFunctionReturnNode` instead.
   */
  predicate exceptionalFunctionReturnNode(DataFlow::Node nd, Function function) {
    nd = TExceptionalFunctionReturnNode(function)
  }

  /**
   * INTERNAL. DO NOT USE.
   *
   * Gets the `PropRead` node corresponding to the value stored in the given
   * binding pattern due to destructuring.
   *
   * For example, in `let { p: value } = f()`, the `value` pattern maps to a `PropRead`
   * extracting the `p` property.
   */
  DataFlow::PropRead patternPropRead(BindingPattern value) {
    exists(PropertyPattern prop |
      value = prop.getValuePattern() and
      result = TPropNode(prop)
    )
    or
    exists(ArrayPattern array |
      value = array.getAnElement() and
      result = TElementPatternNode(array, value)
    )
  }

  /**
   * A classification of flows that are not modeled, or only modeled incompletely, by
   * `DataFlowNode`:
   *
   * - `"await"`: missing flow through promises;
   * - `"call"`: missing inter-procedural data flow;
   * - `"eval"`: missing reflective data flow;
   * - `"global"`: missing ata flow through global variables;
   * - `"heap"`: missing data flow through properties;
   * - `"import"`: missing data flow through module imports;
   * - `"namespace"`: missing data flow through exported namespace members;
   * - `"yield"`: missing data flow through generators.
   */
  class Incompleteness extends string {
    Incompleteness() {
      this = "await" or
      this = "call" or
      this = "eval" or
      this = "global" or
      this = "heap" or
      this = "import" or
      this = "namespace" or
      this = "yield"
    }
  }

  /**
   * Holds if `call` may call `callee`, and this call should be
   * tracked by local data flow.
   */
  private predicate localCall(InvokeExpr call, Function callee) {
    call = callee.(ImmediatelyInvokedFunctionExpr).getInvocation()
  }

  /**
   * Holds if some call passes `arg` as the value of `parm`, and this
   * call should be tracked by local data flow.
   */
  private predicate localArgumentPassing(Expr arg, Parameter parm) {
    any(ImmediatelyInvokedFunctionExpr iife).argumentPassing(parm, arg)
  }

  /**
   * Holds if data can flow from `pred` to `succ` in one local step.
   */
  cached
  predicate localFlowStep(Node pred, Node succ) {
    // flow into local variables
    exists(SsaDefinition ssa | succ = TSsaDefNode(ssa) |
      // from the rhs of an explicit definition into the variable
      exists(SsaExplicitDefinition def | def = ssa |
        pred = defSourceNode(def.getDef(), def.getSourceVariable())
      )
      or
      // from any explicit definition or implicit init of a captured variable into
      // the capturing definition
      exists(SsaSourceVariable v, SsaDefinition predDef |
        v = ssa.(SsaVariableCapture).getSourceVariable() and
        predDef.getSourceVariable() = v and
        pred = TSsaDefNode(predDef)
      |
        predDef instanceof SsaExplicitDefinition or
        predDef instanceof SsaImplicitInit
      )
      or
      // from the inputs of phi and pi nodes into the node itself
      pred = TSsaDefNode(ssa.(SsaPseudoDefinition).getAnInput().getDefinition())
    )
    or
    // flow out of local variables
    exists(SsaVariable v |
      pred = TSsaDefNode(v.getDefinition()) and
      succ = valueNode(v.getAUse())
    )
    or
    exists(Expr predExpr, Expr succExpr |
      pred = valueNode(predExpr) and succ = valueNode(succExpr)
    |
      predExpr = succExpr.(ParExpr).getExpression()
      or
      predExpr = succExpr.(SeqExpr).getLastOperand()
      or
      predExpr = succExpr.(LogicalBinaryExpr).getAnOperand()
      or
      predExpr = succExpr.(AssignExpr).getRhs()
      or
      predExpr = succExpr.(ConditionalExpr).getABranch()
      or
      predExpr = succExpr.(TypeAssertion).getExpression()
      or
      predExpr = succExpr.(NonNullAssertion).getExpression()
      or
      predExpr = succExpr.(ExpressionWithTypeArguments).getExpression()
      or
      exists(Function f |
        predExpr = f.getAReturnedExpr() and
        localCall(succExpr, f)
      )
    )
    or
    exists(VarDef def |
      // from `e` to `{ p: x }` in `{ p: x } = e`
      pred = valueNode(defSourceNode(def)) and
      succ = TValueNode(def.getTarget().(DestructuringPattern))
    )
    or
    // flow from the value read from a property pattern to the value being
    // destructured in the child pattern. For example, for
    //
    //   let { p: { q: x } } = obj
    //
    // add edge from the 'p:' pattern to '{ q:x }'.
    exists(PropertyPattern pattern |
      pred = TPropNode(pattern) and
      succ = TValueNode(pattern.getValuePattern().(DestructuringPattern))
    )
    or
    // Like the step above, but for array destructuring patterns.
    exists(Expr elm |
      pred = TElementPatternNode(_, elm) and
      succ = TValueNode(elm.(DestructuringPattern))
    )
    or
    // flow from 'this' parameter into 'this' expressions
    exists(ThisExpr thiz |
      pred = TThisNode(thiz.getBindingContainer()) and
      succ = valueNode(thiz)
    )
    or
    // `f.call(...)` and `f.apply(...)` evaluate to the result of the reflective call they perform
    pred = TReflectiveCallNode(succ.asExpr(), _)
  }

  /**
   * Holds if there is a step from `pred` to `succ` through a field accessed through `this` in a class.
   */
  predicate localFieldStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(ClassNode cls, string prop |
      pred = cls.getAReceiverNode().getAPropertyWrite(prop).getRhs() and
      succ = cls.getAReceiverNode().getAPropertyRead(prop)
    )
  }

  /**
   * Gets the data flow node representing the source of definition `def`, taking
   * flow through IIFE calls into account.
   */
  private AST::ValueNode defSourceNode(VarDef def) {
    result = def.getSource() or
    result = def.getDestructuringSource() or
    localArgumentPassing(result, def)
  }

  /**
   * INTERNAL. DO NOT USE.
   *
   * Gets the data flow node representing the source of the definition of `v` at `def`,
   * if any.
   */
  Node defSourceNode(VarDef def, SsaSourceVariable v) {
    exists(BindingPattern lhs, VarRef r |
      lhs = def.getTarget() and r = lhs.getABindingVarRef() and r.getVariable() = v
    |
      // follow one step of the def-use chain if the lhs is a simple variable reference
      lhs = r and
      result = TValueNode(defSourceNode(def))
      or
      // handle destructuring assignments
      exists(PropertyPattern pp | r = pp.getValuePattern() |
        result = TPropNode(pp) or result = pp.getDefault().flow()
      )
      or
      result = TElementPatternNode(_, r)
      or
      exists(ArrayPattern ap, int i | ap.getElement(i) = r and result = ap.getDefault(i).flow())
    )
  }

  /**
   * Holds if the flow information for this node is incomplete.
   *
   * This predicate holds if there may be a source flow node from which data flows into
   * this node, but that node is not a result of `getALocalSource()` due to analysis incompleteness.
   * The parameter `cause` is bound to a string describing the source of incompleteness.
   *
   * For example, since this analysis is intra-procedural, data flow from actual arguments
   * to formal parameters is not modeled. Hence, if `p` is an access to a parameter,
   * `p.getALocalSource()` does _not_ return the corresponding argument, and
   * `p.isIncomplete("call")` holds.
   */
  predicate isIncomplete(Node nd, Incompleteness cause) {
    exists(SsaVariable ssa | nd = TSsaDefNode(ssa.getDefinition()) |
      defIsIncomplete(ssa.(SsaExplicitDefinition).getDef(), cause)
      or
      exists(Variable v | v = ssa.getSourceVariable() |
        v.isNamespaceExport() and cause = "namespace"
        or
        any(DirectEval e).mayAffect(v) and cause = "eval"
      )
    )
    or
    exists(GlobalVarAccess va |
      nd = valueNode(va.(VarUse)) and
      if Closure::isClosureNamespace(va.getName()) then cause = "heap" else cause = "global"
    )
    or
    exists(Expr e | e = nd.asExpr() and cause = "call" |
      e instanceof InvokeExpr and
      not localCall(e, _)
      or
      e instanceof ThisExpr
      or
      e instanceof SuperExpr
      or
      e instanceof NewTargetExpr
      or
      e instanceof FunctionBindExpr
      or
      e instanceof TaggedTemplateExpr
    )
    or
    nd.asExpr() instanceof ExternalModuleReference and
    cause = "import"
    or
    exists(Expr e | e = nd.asExpr() and cause = "heap" |
      e instanceof PropAccess or
      e instanceof E4X::XMLAnyName or
      e instanceof E4X::XMLAttributeSelector or
      e instanceof E4X::XMLDotDotExpression or
      e instanceof E4X::XMLFilterExpression or
      e instanceof E4X::XMLQualifiedIdentifier
    )
    or
    exists(Expr e | e = nd.asExpr() |
      (e instanceof YieldExpr or e instanceof FunctionSentExpr) and
      cause = "yield"
      or
      (e instanceof AwaitExpr or e instanceof DynamicImportExpr) and
      cause = "await"
    )
    or
    nd instanceof TExceptionalInvocationReturnNode and cause = "call"
    or
    nd instanceof TExceptionalFunctionReturnNode and cause = "call"
    or
    exists(PropertyPattern p | nd = TPropNode(p)) and cause = "heap"
    or
    nd instanceof TElementPatternNode and cause = "heap"
    or
    nd instanceof UnusedParameterNode and cause = "call"
  }

  /**
   * Holds if definition `def` cannot be completely analyzed due to `cause`.
   */
  private predicate defIsIncomplete(VarDef def, Incompleteness cause) {
    def instanceof Parameter and
    not localArgumentPassing(_, def) and
    cause = "call"
    or
    def instanceof ImportSpecifier and
    cause = "import"
    or
    exists(EnhancedForLoop efl | def = efl.getIteratorExpr()) and
    cause = "heap"
    or
    exists(ComprehensionBlock cb | def = cb.getIterator()) and
    cause = "yield"
  }
  import Nodes
  import Sources
  import TypeInference
  import Configuration
  import TrackedNodes
  import TypeTracking
}

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
private import internal.CallGraphs
private import internal.FlowSteps as FlowSteps
private import internal.DataFlowNode
private import internal.AnalyzedParameters
private import internal.PreCallGraphStep
private import semmle.javascript.internal.CachedStages

module DataFlow {
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

    /**
     * Gets the expression enclosing this data flow node.
     * In most cases the result is the same as `asExpr()`, however this method
     * additionally includes the `InvokeExpr` corresponding to reflective calls.
     */
    Expr getEnclosingExpr() {
      result = this.asExpr() or
      this = DataFlow::reflectiveCallNode(result)
    }

    /** Gets the AST node corresponding to this data flow node, if any. */
    AstNode getAstNode() { none() }

    /** Gets the basic block to which this node belongs. */
    BasicBlock getBasicBlock() { none() }

    /** Gets the container in which this node occurs. */
    StmtContainer getContainer() { result = this.getBasicBlock().getContainer() }

    /** Gets the toplevel in which this node occurs. */
    TopLevel getTopLevel() { result = this.getContainer().getTopLevel() }

    /**
     * Holds if this data flow node accesses the global variable `g`, either directly
     * or through the `window` object.
     */
    predicate accessesGlobal(string g) { globalVarRef(g).flowsTo(this) }

    /** Holds if this node may evaluate to the string `s`, possibly through local data flow. */
    pragma[nomagic]
    predicate mayHaveStringValue(string s) {
      this.getAPredecessor().mayHaveStringValue(s)
      or
      s = this.getStringValue()
    }

    /** Gets the string value of this node, if it is a string literal or constant string concatenation. */
    string getStringValue() { result = this.asExpr().getStringValue() }

    /** Holds if this node may evaluate to the Boolean value `b`. */
    predicate mayHaveBooleanValue(boolean b) {
      this.getAPredecessor().mayHaveBooleanValue(b)
      or
      b = true and this.asExpr().(BooleanLiteral).getValue() = "true"
      or
      b = false and this.asExpr().(BooleanLiteral).getValue() = "false"
    }

    /** Gets the integer value of this node, if it is an integer constant. */
    int getIntValue() { result = this.asExpr().getIntValue() }

    /** Gets a function value that may reach this node. */
    final FunctionNode getAFunctionValue() {
      CallGraph::getAFunctionReference(result, 0).flowsTo(this)
    }

    /** Gets a function value that may reach this node with the given `imprecision` level. */
    final FunctionNode getAFunctionValue(int imprecision) {
      CallGraph::getAFunctionReference(result, imprecision).flowsTo(this)
    }

    /**
     * Gets a function value that may reach this node,
     * possibly derived from a partial function invocation.
     */
    final FunctionNode getABoundFunctionValue(int boundArgs) {
      result = this.getAFunctionValue() and boundArgs = 0
      or
      CallGraph::getABoundFunctionReference(result, boundArgs, _).flowsTo(this)
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
     * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
     */
    cached
    predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      none()
    }

    /** Gets the file this data flow node comes from. */
    File getFile() { none() } // overridden in subclasses

    /** Gets the start line of this data flow node. */
    int getStartLine() { this.hasLocationInfo(_, result, _, _, _) }

    /** Gets the start column of this data flow node. */
    int getStartColumn() { this.hasLocationInfo(_, _, result, _, _) }

    /** Gets the end line of this data flow node. */
    int getEndLine() { this.hasLocationInfo(_, _, _, result, _) }

    /** Gets the end column of this data flow node. */
    int getEndColumn() { this.hasLocationInfo(_, _, _, _, result) }

    /** Gets a textual representation of this element. */
    cached
    string toString() { none() }

    /**
     * Gets the immediate predecessor of this node, if any.
     *
     * A node with an immediate predecessor can usually only have the value that flows
     * into its from its immediate predecessor.
     */
    cached
    DataFlow::Node getImmediatePredecessor() {
      lvalueFlowStep(result, this) and
      not lvalueDefaultFlowStep(_, this)
      or
      immediateFlowStep(result, this)
      or
      // Refinement of variable -> original definition of variable
      exists(SsaRefinementNode refinement |
        this = TSsaDefNode(refinement) and
        result = TSsaDefNode(refinement.getAnInput())
      )
      or
      exists(SsaPhiNode phi |
        this = TSsaDefNode(phi) and
        result = TSsaDefNode(phi.getRephinedVariable())
      )
      or
      // IIFE call -> return value of IIFE
      exists(Function fun |
        localCall(this.asExpr(), fun) and
        result = unique(Expr ret | ret = fun.getAReturnedExpr()).flow() and
        not fun.getExit().isJoin() // can only reach exit by the return statement
      )
      or
      FlowSteps::identityFunctionStep(result, this)
    }

    /**
     * Gets the static type of this node as determined by the TypeScript type system.
     */
    private Type getType() {
      exists(AST::ValueNode node |
        this = TValueNode(node) and
        ast_node_type(node, result)
      )
      or
      exists(BindingPattern pattern |
        this = lvalueNode(pattern) and
        ast_node_type(pattern, result)
      )
      or
      exists(MethodDefinition def |
        this = TThisNode(def.getInit()) and
        ast_node_type(def.getDeclaringClass(), result)
      )
    }

    /**
     * Gets the type annotation describing the type of this node,
     * provided that a static type could not be found.
     *
     * Doesn't take field types and function return types into account.
     */
    private TypeAnnotation getFallbackTypeAnnotation() {
      exists(BindingPattern pattern |
        this = valueNode(pattern) and
        result = pattern.getTypeAnnotation()
      )
      or
      result = this.getAPredecessor().getFallbackTypeAnnotation()
      or
      exists(DataFlow::ClassNode cls, string fieldName |
        this = cls.getAReceiverNode().getAPropertyRead(fieldName) and
        result = cls.getFieldTypeAnnotation(fieldName)
      )
    }

    /**
     * Holds if this node is annotated with the given named type,
     * or is declared as a subtype thereof, or is a union or intersection containing such a type.
     */
    cached
    predicate hasUnderlyingType(string globalName) {
      Stages::TypeTracking::ref() and
      this.getType().hasUnderlyingType(globalName)
      or
      this.getFallbackTypeAnnotation().getAnUnderlyingType().hasQualifiedName(globalName)
    }

    /**
     * Holds if this node is annotated with the given named type,
     * or is declared as a subtype thereof, or is a union or intersection containing such a type.
     */
    cached
    predicate hasUnderlyingType(string moduleName, string typeName) {
      Stages::TypeTracking::ref() and
      this.getType().hasUnderlyingType(moduleName, typeName)
      or
      this.getFallbackTypeAnnotation().getAnUnderlyingType().hasQualifiedName(moduleName, typeName)
    }
  }

  /**
   * A node in the data flow graph which corresponds to an expression,
   * destructuring pattern, or declaration of a function, class, namespace, or enum.
   *
   * Examples:
   * ```js
   * x + y
   * Math.abs(x)
   * class C {}
   * function f(x, y) {}
   * ```
   */
  class ValueNode extends Node, TValueNode {
    AST::ValueNode astNode;

    ValueNode() { this = TValueNode(astNode) }

    /** Gets the expression or declaration this node corresponds to. */
    override AST::ValueNode getAstNode() { result = astNode }

    override BasicBlock getBasicBlock() { astNode = result.getANode() }

    override predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      Stages::DataFlowStage::ref() and
      astNode.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    }

    override File getFile() { result = astNode.getFile() }

    override string toString() { Stages::DataFlowStage::ref() and result = astNode.toString() }
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

    override File getFile() { result = ssa.getBasicBlock().getFile() }

    override AstNode getAstNode() { none() }
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
      prop.(Locatable)
          .getLocation()
          .hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    }

    override string toString() { result = prop.(AstNode).toString() }

    override File getFile() { result = prop.(AstNode).getFile() }

    override AstNode getAstNode() { result = prop }
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

    override File getFile() { result = pattern.getFile() }

    override AstNode getAstNode() { result = rest }
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

    override File getFile() { result = pattern.getFile() }

    override AstNode getAstNode() { result = elt }
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

    override File getFile() { result = arr.getFile() }

    override AstNode getAstNode() { result = elt }
  }

  /**
   * A node in the data flow graph which corresponds to the reflective call performed
   * by a `.call` or `.apply` invocation.
   */
  private class ReflectiveCallNode extends Node, TReflectiveCallNode {
    MethodCallExpr call;

    ReflectiveCallNode() { this = TReflectiveCallNode(call, _) }

    override BasicBlock getBasicBlock() { result = call.getBasicBlock() }

    override predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      call.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    }

    override string toString() { result = "reflective call" }

    override File getFile() { result = call.getFile() }
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

    override File getFile() { result = imprt.getFile() }
  }

  /**
   * A data flow node that reads or writes an object property or class member.
   *
   * The default subclasses do not model global variable references or variable
   * references inside `with` statements as property references.
   *
   * See `PropWrite` and `PropRead` for concrete syntax examples.
   */
  abstract class PropRef extends Node {
    /**
     * Gets the data flow node corresponding to the base object
     * whose property is read from or written to.
     */
    cached
    abstract Node getBase();

    /**
     * Gets the expression specifying the name of the property being
     * read or written, if any.
     *
     * This is usually either an identifier or a literal.
     */
    abstract Expr getPropertyNameExpr();

    /**
     * Holds if this property reference may access a property named `propName`.
     */
    predicate mayHavePropertyName(string propName) {
      propName = this.getPropertyName() or
      this.getPropertyNameExpr().flow().mayHaveStringValue(propName)
    }

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
    predicate accesses(Node base, string p) { this.getBase() = base and this.getPropertyName() = p }

    /**
     * Holds if this data flow node reads or writes a private field in a class.
     */
    predicate isPrivateField() {
      this.getPropertyName().charAt(0) = "#" and this.getPropertyNameExpr() instanceof Label
    }

    /**
     * Gets an accessor (`get` or `set` method) that may be invoked by this property reference.
     */
    final DataFlow::FunctionNode getAnAccessorCallee() {
      result = CallGraph::getAnAccessorCallee(this)
    }
  }

  /**
   * A data flow node that writes to an object property.
   *
   * For example, all of the following are property writes:
   * ```js
   * obj.f = value;  // assignment to a property
   * obj[e] = value; // assignment to a computed property
   * { f: value }    // property initializer
   * { g() {} }      // object literal method
   * { get g() {}, set g(v) {} }  // accessor methods (have no rhs value)
   * class C {
   *   constructor(public x: number); // parameter field (TypeScript only)
   *   static m() {} // static method
   *   g() {}        // instance method
   * }
   * Object.defineProperty(obj, 'f', { value: 5} ) // call to defineProperty
   * <View width={value}/>  // JSX attribute
   * ```
   */
  abstract class PropWrite extends PropRef {
    /**
     * Gets the data flow node corresponding to the value being written,
     * if it can be statically determined.
     *
     * This predicate is undefined for spread properties, accessor
     * properties, and most uses of `Object.defineProperty`.
     */
    pragma[nomagic]
    abstract Node getRhs();

    /**
     * Holds if this data flow node writes the value of `rhs` to property
     * `prop` of the object that `base` evaluates to.
     */
    pragma[noinline]
    predicate writes(DataFlow::Node base, string prop, DataFlow::Node rhs) {
      base = this.getBase() and
      prop = this.getPropertyName() and
      rhs = this.getRhs()
    }

    /**
     * Gets the node where the property write happens in the control flow graph.
     */
    abstract ControlFlowNode getWriteNode();

    /**
     * If this installs an accessor on an object, as opposed to a regular property,
     * gets the body of the accessor. `isSetter` is true if installing a setter, and
     * false is installing a getter.
     */
    DataFlow::FunctionNode getInstalledAccessor(boolean isSetter) { none() }
  }

  /**
   * A property access in lvalue position, viewed as a property definition node.
   */
  private class PropLValueAsPropWrite extends PropWrite, ValueNode {
    override PropAccess astNode;

    PropLValueAsPropWrite() { astNode instanceof LValue }

    override Node getBase() {
      result = valueNode(astNode.getBase()) and
      Stages::DataFlowStage::ref()
    }

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

    override DataFlow::FunctionNode getInstalledAccessor(boolean isSetter) {
      (
        prop instanceof PropertySetter and
        isSetter = true
        or
        prop instanceof PropertyGetter and
        isSetter = false
      ) and
      result = valueNode(prop.getInit())
    }

    override ControlFlowNode getWriteNode() { result = prop }
  }

  /**
   * A call to `Object.defineProperty`, viewed as a data flow node that
   * writes to the corresponding property.
   */
  private class ObjectDefinePropertyAsPropWrite extends PropWrite, ValueNode {
    override MethodCallExpr astNode;

    ObjectDefinePropertyAsPropWrite() {
      astNode.getReceiver().(GlobalVarAccess).getName() = "Object" and
      astNode.getMethodName() = "defineProperty"
    }

    override Node getBase() { result = astNode.getArgument(0).flow() }

    override Expr getPropertyNameExpr() { result = astNode.getArgument(1) }

    override string getPropertyName() { result = astNode.getArgument(1).getStringValue() }

    override Node getRhs() {
      exists(DataFlow::SourceNode descriptor |
        descriptor = astNode.getArgument(2).flow().getALocalSource()
      |
        result =
          descriptor
              .getAPropertyWrite("get")
              .getRhs()
              .getALocalSource()
              .(DataFlow::FunctionNode)
              .getAReturn()
        or
        result = descriptor.getAPropertyWrite("value").getRhs()
      )
    }

    override ControlFlowNode getWriteNode() { result = astNode }
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

    override DataFlow::FunctionNode getInstalledAccessor(boolean isSetter) {
      (
        prop instanceof SetterMethodDefinition and
        isSetter = true
        or
        prop instanceof GetterMethodDefinition and
        isSetter = false
      ) and
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

    override DataFlow::FunctionNode getInstalledAccessor(boolean isSetter) {
      (
        prop instanceof SetterMethodDefinition and
        isSetter = true
        or
        prop instanceof GetterMethodDefinition and
        isSetter = false
      ) and
      result = valueNode(prop.getInit())
    }

    override ControlFlowNode getWriteNode() { result = prop }
  }

  /**
   * A JSX attribute definition, viewed as a data flow node that writes properties to
   * the JSX element it is in.
   */
  private class JsxAttributeAsPropWrite extends PropWrite, PropNode {
    override JsxAttribute prop;

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
      thisNode(result, prop.getDeclaringClass().getConstructor().getBody())
    }

    override Expr getPropertyNameExpr() {
      none() // The parameter value is not the name of the field
    }

    override string getPropertyName() { result = prop.getName() }

    override Node getRhs() {
      exists(Parameter param, Node paramNode |
        param = prop.getParameter() and
        parameterNode(paramNode, param)
      |
        result = paramNode
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
      thisNode(result, prop.getDeclaringClass().getConstructor().getBody())
    }

    override Expr getPropertyNameExpr() { result = prop.getNameExpr() }

    override string getPropertyName() { result = prop.getName() }

    override Node getRhs() { result = valueNode(prop.getInit()) }

    override ControlFlowNode getWriteNode() { result = prop }
  }

  /**
   * A data flow node that reads an object property.
   *
   * For example, all the following are property reads:
   * ```js
   * obj.f               // property access
   * obj[e]              // computed property access
   * let { f } = obj;    // destructuring object pattern
   * let [x, y] = array; // destructuring array pattern
   * function f({ f }) {} // destructuring pattern (in parameter)
   * for (let elm of array) {}     // element access in for..of loop
   * import { join } from 'path';  // named import specifier
   * ```
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
      this instanceof ElementPatternNode or
      this = lvalueNode(any(ForOfStmt stmt).getLValue())
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
   */
  private class ElementPatternAsPropRead extends PropRead, ElementPatternNode {
    override Node getBase() { result = TValueNode(pattern) }

    override Expr getPropertyNameExpr() { none() }

    override string getPropertyName() {
      exists(int i |
        elt = pattern.getElement(i) and
        result = i.toString()
      )
    }
  }

  /**
   * A named import specifier seen as a property read on the imported module.
   */
  private class ImportSpecifierAsPropRead extends PropRead, ValueNode {
    override ImportSpecifier astNode;
    ImportDeclaration imprt;

    ImportSpecifierAsPropRead() {
      astNode = imprt.getASpecifier() and
      not astNode.isTypeOnly() and
      exists(astNode.getImportedName())
    }

    override Node getBase() { result = TDestructuredModuleImportNode(imprt) }

    override Expr getPropertyNameExpr() { result = astNode.getImported() }

    override string getPropertyName() { result = astNode.getImportedName() }
  }

  /**
   * The left-hand side of a `for..of` statement, seen as a property read
   * on the object being iterated over.
   */
  private class ForOfLvalueAsPropRead extends PropRead {
    ForOfStmt stmt;

    ForOfLvalueAsPropRead() { this = lvalueNode(stmt.getLValue()) }

    override Node getBase() { result = stmt.getIterationDomain().flow() }

    override Expr getPropertyNameExpr() { none() }

    override string getPropertyName() { none() }
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

    override File getFile() { result = attr.getFile() }
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

    override BasicBlock getBasicBlock() { result = function.getExit().getBasicBlock() }

    /**
     * Gets the function corresponding to this exceptional return node.
     */
    Function getFunction() { result = function }

    override File getFile() { result = function.getFile() }
  }

  /**
   * A data flow node representing the values returned by a function.
   */
  class FunctionReturnNode extends DataFlow::Node, TFunctionReturnNode {
    Function function;

    FunctionReturnNode() { this = TFunctionReturnNode(function) }

    override string toString() { result = "return of " + function.describe() }

    override predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      function.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    }

    override BasicBlock getBasicBlock() { result = function.getExit().getBasicBlock() }

    /**
     * Gets the function corresponding to this return node.
     */
    Function getFunction() { result = function }

    override File getFile() { result = function.getFile() }
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

    override BasicBlock getBasicBlock() { result = invoke.getBasicBlock() }

    /**
     * Gets the invocation corresponding to this exceptional return node.
     */
    DataFlow::InvokeNode getInvocation() { result = invoke.flow() }

    override File getFile() { result = invoke.getFile() }
  }

  /**
   * A pseudo-node representing the root of a global access path.
   */
  private class GlobalAccessPathRoot extends TGlobalAccessPathRoot, DataFlow::Node {
    override string toString() { result = "global access path" }
  }

  /**
   * INTERNAL. DO NOT USE.
   *
   * Gets a pseudo-node representing the root of a global access path.
   */
  DataFlow::Node globalAccessPathRootPseudoNode() { result instanceof TGlobalAccessPathRoot }

  /**
   * Gets a data flow node representing the underlying call performed by the given
   * call to `Function.prototype.call` or `Function.prototype.apply`.
   *
   * For example, for an expression `fn.call(x, y)`, this gets a call node with `fn` as the
   * callee, `x` as the receiver, and `y` as the first argument.
   */
  DataFlow::InvokeNode reflectiveCallNode(InvokeExpr expr) { result = TReflectiveCallNode(expr, _) }

  /**
   * Provides classes representing various kinds of calls.
   *
   * Subclass the classes in this module to introduce new kinds of calls. If you want to
   * refine the behavior of the analysis on existing kinds of calls, subclass `InvokeNode`
   * instead.
   */
  module Impl {
    /**
     * A data flow node representing a function invocation, either explicitly or reflectively,
     * and either with or without `new`.
     */
    abstract class InvokeNodeDef extends DataFlow::Node {
      /** Gets the syntactic invoke expression underlying this function invocation. */
      abstract InvokeExpr getInvokeExpr();

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

      override InvokeExpr getInvokeExpr() { result = astNode }

      override string getCalleeName() { result = astNode.getCalleeName() }

      override DataFlow::Node getCalleeNode() { result = DataFlow::valueNode(astNode.getCallee()) }

      /**
       * Whether i is an index that occurs after a spread argument.
       */
      pragma[nomagic]
      private predicate isIndexAfterSpread(int i) {
        astNode.isSpreadArgument(i)
        or
        exists(astNode.getArgument(i)) and
        this.isIndexAfterSpread(i - 1)
      }

      override DataFlow::Node getArgument(int i) {
        not this.isIndexAfterSpread(i) and
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

      override InvokeExpr getInvokeExpr() { result = originalCall.getInvokeExpr() }

      override string getCalleeName() {
        result = originalCall.getReceiver().asExpr().(PropAccess).getPropertyName()
      }

      override DataFlow::Node getCalleeNode() { result = originalCall.getReceiver() }

      override DataFlow::Node getReceiver() { result = originalCall.getArgument(0) }

      override DataFlow::Node getArgument(int i) {
        i >= 0 and kind = "call" and result = originalCall.getArgument(i + 1)
      }

      override DataFlow::Node getAnArgument() {
        kind = "call" and result = originalCall.getAnArgument() and result != this.getReceiver()
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
      exists(StmtContainer container | this = TThisNode(container) | result = container.getEntry())
    }

    override predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      // Use the function entry as the location
      exists(StmtContainer container | this = TThisNode(container) |
        container
            .getEntry()
            .getLocation()
            .hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
      )
    }

    override File getFile() {
      exists(StmtContainer container | this = TThisNode(container) | result = container.getFile())
    }
  }

  /**
   * A data flow node representing a captured variable.
   */
  private class CapturedVariableNode extends Node, TCapturedVariableNode {
    LocalVariable variable;

    CapturedVariableNode() { this = TCapturedVariableNode(variable) }

    override BasicBlock getBasicBlock() { result = variable.getDeclaringContainer().getStartBB() }

    override predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      variable.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    }

    override string toString() { result = variable.getName() }
  }

  /** A data flow node representing the value plugged into a template tag. */
  class TemplatePlaceholderTagNode extends Node, TTemplatePlaceholderTag {
    /** Gets the template tag represented by this data flow node. */
    Templating::TemplatePlaceholderTag getTag() { this = TTemplatePlaceholderTag(result) }

    override BasicBlock getBasicBlock() { none() }

    override predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      this.getTag()
          .getLocation()
          .hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    }

    override string toString() { result = this.getTag().toString() }
  }

  /**
   * INTERNAL. DO NOT USE.
   *
   * Gets a data flow node representing the given captured variable.
   */
  Node capturedVariableNode(LocalVariable variable) { result = TCapturedVariableNode(variable) }

  /**
   * Gets the data flow node corresponding to `nd`.
   *
   * This predicate is only defined for expressions, properties, and for statements that declare
   * a function, a class, or a TypeScript namespace or enum.
   */
  ValueNode valueNode(AstNode nd) { result.getAstNode() = nd }

  /**
   * Gets the data flow node corresponding to `e`.
   */
  pragma[inline]
  ExprNode exprNode(Expr e) { result = valueNode(e) }

  /** Gets the data flow node corresponding to `ssa`. */
  SsaDefinitionNode ssaDefinitionNode(SsaDefinition ssa) { result = TSsaDefNode(ssa) }

  /** Gets the node corresponding to the initialization of parameter `p`. */
  ParameterNode parameterNode(Parameter p) { result.getParameter() = p }

  /**
   * INTERNAL: Use `parameterNode(Parameter)` instead.
   */
  predicate parameterNode(DataFlow::Node nd, Parameter p) { nd = valueNode(p) }

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
   * INTERNAL: Use `FunctionReturnNode` instead.
   */
  predicate functionReturnNode(DataFlow::Node nd, Function function) {
    nd = TFunctionReturnNode(function)
  }

  /**
   * INTERNAL: Do not use outside standard library.
   *
   * Gets a data flow node unique to the given field declaration.
   *
   * Note that this node defaults to being disconnected from the data flow
   * graph, as the individual property reads and writes affecting the field are
   * analyzed independently of the field declaration.
   *
   * Certain framework models may need this node to model the behavior of
   * class and field decorators.
   */
  DataFlow::Node fieldDeclarationNode(FieldDeclaration field) { result = TPropNode(field) }

  /**
   * Gets the data flow node corresponding the given l-value expression, if
   * such a node exists.
   *
   * This differs from `DataFlow::valueNode()`, which represents the value
   * _before_ the l-value is assigned to, whereas `DataFlow::lvalueNode()`
   * represents the value _after_ the assignment.
   */
  Node lvalueNode(BindingPattern lvalue) {
    exists(SsaExplicitDefinition ssa |
      ssa.defines(lvalue.(LValue).getDefNode(), lvalue.(VarRef).getVariable()) and
      result = TSsaDefNode(ssa)
    )
    or
    result = TValueNode(lvalue.(DestructuringPattern))
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
      this = ["await", "call", "eval", "global", "heap", "import", "namespace", "yield"]
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
   * Holds if there is a step from `pred -> succ` due to an assignment
   * to an expression in l-value position.
   */
  private predicate lvalueFlowStep(Node pred, Node succ) {
    exists(VarDef def |
      pred = valueNode(defSourceNode(def)) and
      succ = lvalueNode(def.getTarget())
    )
    or
    exists(SimpleParameter param |
      pred = valueNode(param) and // The value node represents the incoming argument
      succ = lvalueNode(param) // The SSA node represents the parameters's local variable
    )
    or
    exists(Expr arg, Parameter param |
      localArgumentPassing(arg, param) and
      pred = valueNode(arg) and
      succ = valueNode(param)
    )
    or
    exists(PropertyPattern pattern |
      pred = TPropNode(pattern) and
      succ = lvalueNode(pattern.getValuePattern())
    )
    or
    exists(Expr element |
      pred = TElementPatternNode(_, element) and
      succ = lvalueNode(element)
    )
  }

  /**
   * Holds if there is a step from `pred -> succ` from the default
   * value of a destructuring pattern or parameter.
   */
  private predicate lvalueDefaultFlowStep(Node pred, Node succ) {
    exists(PropertyPattern pattern |
      pred = TValueNode(pattern.getDefault()) and
      succ = lvalueNode(pattern.getValuePattern())
    )
    or
    exists(ArrayPattern array, int i |
      pred = TValueNode(array.getDefault(i)) and
      succ = lvalueNode(array.getElement(i))
    )
    or
    exists(Parameter param |
      pred = TValueNode(param.getDefault()) and
      parameterNode(succ, param)
    )
  }

  /**
   * Flow steps shared between `getImmediatePredecessor` and `localFlowStep`.
   *
   * Inlining is forced because the two relations are indexed differently.
   */
  pragma[inline]
  private predicate immediateFlowStep(Node pred, Node succ) {
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
      predExpr = succExpr.(AssignExpr).getRhs()
      or
      predExpr = succExpr.(TypeAssertion).getExpression()
      or
      predExpr = succExpr.(NonNullAssertion).getExpression()
      or
      predExpr = succExpr.(ExpressionWithTypeArguments).getExpression()
      or
      (
        succExpr instanceof AssignLogOrExpr or
        succExpr instanceof AssignLogAndExpr or
        succExpr instanceof AssignNullishCoalescingExpr
      ) and
      (
        predExpr = succExpr.(CompoundAssignExpr).getLhs() or
        predExpr = succExpr.(CompoundAssignExpr).getRhs()
      )
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
   * Holds if data can flow from `pred` to `succ` in one local step.
   */
  cached
  predicate localFlowStep(Node pred, Node succ) {
    Stages::DataFlowStage::ref() and
    // flow from RHS into LHS
    lvalueFlowStep(pred, succ)
    or
    lvalueDefaultFlowStep(pred, succ)
    or
    immediateFlowStep(pred, succ)
    or
    // From an assignment or implicit initialization of a captured variable to its flow-insensitive node.
    exists(SsaDefinition predDef |
      pred = TSsaDefNode(predDef) and
      succ = TCapturedVariableNode(predDef.getSourceVariable())
    |
      predDef instanceof SsaExplicitDefinition or
      predDef instanceof SsaImplicitInit
    )
    or
    // From a captured variable node to its flow-sensitive capture nodes
    exists(SsaVariableCapture ssaCapture |
      pred = TCapturedVariableNode(ssaCapture.getSourceVariable()) and
      succ = TSsaDefNode(ssaCapture)
    )
    or
    // Flow through implicit SSA nodes
    exists(SsaImplicitDefinition ssa | succ = TSsaDefNode(ssa) |
      // from the inputs of phi and pi nodes into the node itself
      pred = TSsaDefNode(ssa.(SsaPseudoDefinition).getAnInput().getDefinition())
    )
    or
    exists(Expr predExpr, Expr succExpr |
      pred = valueNode(predExpr) and succ = valueNode(succExpr)
    |
      predExpr = succExpr.(LogicalBinaryExpr).getAnOperand()
      or
      predExpr = succExpr.(ConditionalExpr).getABranch()
      or
      exists(Function f |
        predExpr = f.getAReturnedExpr() and
        localCall(succExpr, f)
      )
    )
    or
    // from returned expr to the FunctionReturnNode.
    exists(Function f | not f.isAsyncOrGenerator() |
      DataFlow::functionReturnNode(succ, f) and pred = valueNode(f.getAReturnedExpr())
    )
  }

  /**
   * Holds if there is a step from `pred` to `succ` through a field accessed through `this` in a class.
   */
  predicate localFieldStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(ClassNode cls, string prop |
      pred = cls.getADirectSuperClass*().getAReceiverNode().getAPropertyWrite(prop).getRhs() or
      pred = cls.getInstanceMethod(prop)
    |
      succ = cls.getAReceiverNode().getAPropertyRead(prop)
    )
  }

  predicate argumentPassingStep = FlowSteps::argumentPassing/4;

  /**
   * Gets the data flow node representing the source of definition `def`, taking
   * flow through IIFE calls into account.
   */
  private AST::ValueNode defSourceNode(VarDef def) {
    result = def.getSource() or
    result = def.getDestructuringSource()
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
      e instanceof ImportMetaExpr
      or
      e instanceof FunctionBindExpr
      or
      e instanceof TaggedTemplateExpr
      or
      e instanceof Parameter and
      not localArgumentPassing(_, e) and
      not isAnalyzedParameter(e) and
      not e.(Parameter).isRestParameter()
    )
    or
    nd.(AnalyzedNode).hasAdditionalIncompleteness(cause)
    or
    nd.asExpr() instanceof ExternalModuleReference and
    cause = "import"
    or
    exists(Expr e | e = nd.asExpr() and cause = "heap" |
      e instanceof PropAccess or
      e instanceof E4X::XmlAnyName or
      e instanceof E4X::XmlAttributeSelector or
      e instanceof E4X::XmlDotDotExpression or
      e instanceof E4X::XmlFilterExpression or
      e instanceof E4X::XmlQualifiedIdentifier or
      e instanceof Angular2::PipeRefExpr
    )
    or
    exists(Expr e | e = nd.asExpr() |
      (e instanceof YieldExpr or e instanceof FunctionSentExpr) and
      cause = "yield"
      or
      (e instanceof AwaitExpr or e instanceof DynamicImportExpr) and
      cause = "await"
      or
      e instanceof GeneratedCodeExpr and
      cause = "eval" // we use 'eval' here to represent code generation more broadly
    )
    or
    nd instanceof TExceptionalInvocationReturnNode and cause = "call"
    or
    nd instanceof TExceptionalFunctionReturnNode and cause = "call"
    or
    exists(PropertyPattern p | nd = TPropNode(p)) and cause = "heap"
    or
    nd instanceof TElementPatternNode and cause = "heap"
  }

  /**
   * Holds if definition `def` cannot be completely analyzed due to `cause`.
   */
  private predicate defIsIncomplete(VarDef def, Incompleteness cause) {
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
  import TypeTracking
  import internal.FunctionWrapperSteps

  deprecated predicate localTaintStep = TaintTracking::localTaintStep/2;
}

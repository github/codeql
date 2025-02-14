/**
 * Provides classes representing particular kinds of data flow nodes, such
 * as nodes corresponding to function definitions or nodes corresponding to
 * parameters.
 */

private import javascript
private import semmle.javascript.dependencies.Dependencies
private import internal.CallGraphs
private import semmle.javascript.internal.CachedStages
private import semmle.javascript.dataflow.internal.PreCallGraphStep

/**
 * A data flow node corresponding to an expression.
 *
 * Examples:
 * ```js
 * x + y
 * Math.abs(x)
 * ```
 */
class ExprNode extends DataFlow::ValueNode {
  override Expr astNode;

  pragma[nomagic]
  ExprNode() { any() }
}

/**
 * A data flow node corresponding to a parameter.
 *
 * For example, `x` is a parameter of `function f(x) {}`.
 *
 * When a parameter is a destructuring pattern, such as `{x, y}`, there is one
 * parameter node representing the entire parameter, and separate `PropRead` nodes
 * for the individual property patterns (`x` and `y`).
 */
class ParameterNode extends DataFlow::SourceNode {
  Parameter p;

  ParameterNode() { DataFlow::parameterNode(this, p) }

  /** Gets the parameter to which this data flow node corresponds. */
  Parameter getParameter() { result = p }

  /** Gets the name of this parameter. */
  string getName() { result = p.getName() }

  /** Holds if this parameter is a rest parameter. */
  predicate isRestParameter() { p.isRestParameter() }

  /** Gets the data flow node for an expression that is applied to this decorator. */
  DataFlow::Node getADecorator() {
    result = this.getParameter().getADecorator().getExpression().flow()
  }
}

/**
 * A data flow node corresponding to a function invocation (with or without `new`).
 *
 * Examples:
 * ```js
 * Math.abs(x)
 * new Array(16)
 * ```
 */
class InvokeNode extends DataFlow::SourceNode instanceof DataFlow::Impl::InvokeNodeDef {
  /** Gets the syntactic invoke expression underlying this function invocation. */
  InvokeExpr getInvokeExpr() { result = super.getInvokeExpr() }

  /** Gets the name of the function or method being invoked, if it can be determined. */
  string getCalleeName() { result = super.getCalleeName() }

  /** Gets the data flow node specifying the function to be called. */
  DataFlow::Node getCalleeNode() { result = super.getCalleeNode() }

  /**
   * Gets the data flow node corresponding to the `i`th argument of this invocation.
   *
   * For direct calls, this is the `i`th argument to the call itself: for instance,
   * for a call `f(x, y)`, the 0th argument node is `x` and the first argument node is `y`.
   *
   * For reflective calls using `call`, the 0th argument to the call denotes the
   * receiver, so argument positions are shifted by one: for instance, for a call
   * `f.call(x, y, z)`, the 0th argument node is `y` and the first argument node is `z`,
   * while `x` is not an argument node at all.
   *
   * For reflective calls using `apply` we cannot, in general, tell which argument
   * occurs at which position, so this predicate is not defined for such calls.
   *
   * Note that this predicate is not defined for arguments following a spread
   * argument: for instance, for a call `f(x, ...y, z)`, the 0th argument node is `x`,
   * but the position of `z` cannot be determined, hence there are no first and second
   * argument nodes.
   */
  cached
  DataFlow::Node getArgument(int i) {
    result = super.getArgument(i) and Stages::DataFlowStage::ref()
  }

  /** Gets the data flow node corresponding to an argument of this invocation. */
  cached
  DataFlow::Node getAnArgument() { result = super.getAnArgument() and Stages::DataFlowStage::ref() }

  /** Gets the data flow node corresponding to the last argument of this invocation. */
  cached
  DataFlow::Node getLastArgument() {
    result = this.getArgument(this.getNumArgument() - 1) and Stages::DataFlowStage::ref()
  }

  /**
   * Gets a data flow node corresponding to an array of values being passed as
   * individual arguments to this invocation.
   *
   * Examples:
   * ```
   * x.push(...args);                     // 'args' is a spread argument
   * x.push(x, ...args, y, ...more);      // 'args' and 'more' are a spread arguments
   * Array.prototype.push.apply(x, args); // 'args' is a spread argument
   * ```
   *  .
   */
  DataFlow::Node getASpreadArgument() { result = super.getASpreadArgument() }

  /** Gets the number of arguments of this invocation, if it can be determined. */
  int getNumArgument() { result = super.getNumArgument() }

  Function getEnclosingFunction() { result = this.getBasicBlock().getContainer() }

  /**
   * Gets a function passed as the `i`th argument of this invocation.
   *
   * This predicate only performs local data flow tracking.
   * Consider using `getABoundCallbackParameter` to handle interprocedural flow of callback functions.
   */
  FunctionNode getCallback(int i) { result.flowsTo(this.getArgument(i)) }

  /**
   * Gets a parameter of a callback passed into this call.
   *
   * `callback` indicates which argument the callback passed into, and `param`
   * is the index of the parameter in the callback function.
   *
   * For example, for the call below, `getABoundCallbackParameter(1, 0)` refers
   * to the parameter `e` (the first parameter of the second callback argument):
   * ```js
   * addEventHandler("click", e => { ... })
   * ```
   *
   * This predicate takes interprocedural data flow into account, as well as
   * partial function applications such as `.bind`.
   *
   * For example, for the call below `getABoundCallbackParameter(1, 0)` returns the parameter `e`,
   * (the first parameter of the second callback argument), since the first parameter of `foo`
   * has been bound by the `bind` call:
   * ```js
   * function foo(x, e) { }
   * addEventHandler("click", foo.bind(this, "value of x"))
   * ```
   */
  ParameterNode getABoundCallbackParameter(int callback, int param) {
    exists(int boundArgs |
      result =
        this.getArgument(callback).getABoundFunctionValue(boundArgs).getParameter(param + boundArgs)
    )
  }

  /**
   * Holds if the `i`th argument of this invocation is an object literal whose property
   * `name` is set to `result`.
   */
  pragma[nomagic]
  DataFlow::ValueNode getOptionArgument(int i, string name) {
    this.getOptionsArgument(i).hasPropertyWrite(name, result)
  }

  pragma[noinline]
  private ObjectLiteralNode getOptionsArgument(int i) { result.flowsTo(this.getArgument(i)) }

  /** Gets an abstract value representing possible callees of this call site. */
  final AbstractValue getACalleeValue() {
    exists(DataFlow::Node callee, DataFlow::AnalyzedNode analyzed |
      pragma[only_bind_into](callee) = this.getCalleeNode() and
      pragma[only_bind_into](analyzed) = callee.analyze() and
      pragma[only_bind_into](result) = analyzed.getAValue()
    )
  }

  /**
   * Gets a potential callee of this call site.
   *
   * To alter the call graph as seen by the interprocedural data flow libraries, override
   * the `getACallee(int imprecision)` predicate instead.
   */
  final Function getACallee() { result = this.getACallee(0) }

  /**
   * Gets a callee of this call site where `imprecision` is a heuristic measure of how
   * likely it is that `callee` is only suggested as a potential callee due to
   * imprecise analysis of global variables and is not, in fact, a viable callee at all.
   *
   * Callees with imprecision zero, in particular, have either been derived without
   * considering global variables, or are calls to a global variable within the same file,
   * or a global variable that has unique definition within the project.
   *
   * This predicate can be overridden to alter the call graph used by the interprocedural
   * data flow libraries.
   */
  Function getACallee(int imprecision) {
    result = CallGraph::getACallee(this, imprecision).getFunction()
  }

  /**
   * Holds if the approximation of possible callees for this call site is
   * affected by the given analysis incompleteness `cause`.
   */
  predicate isIndefinite(DataFlow::Incompleteness cause) {
    this.getACalleeValue().isIndefinite(cause)
  }

  /**
   * Holds if our approximation of possible callees for this call site is
   * likely to be imprecise.
   *
   * We currently track one specific source of imprecision: call
   * resolution relies on flow through global variables, and the flow
   * analysis finds possible callees that are not functions.
   * This usually means that a global variable is used in multiple
   * independent contexts, so tracking flow through it leads to
   * imprecision.
   */
  predicate isImprecise() {
    this.isIndefinite("global") and
    exists(DefiniteAbstractValue v | v = this.getACalleeValue() | not v instanceof AbstractCallable)
  }

  /**
   * Holds if our approximation of possible callees for this call site is
   * likely to be incomplete.
   */
  predicate isIncomplete() {
    // the flow analysis identifies a source of incompleteness other than
    // global flow (which usually leads to imprecision rather than incompleteness)
    any(DataFlow::Incompleteness cause | this.isIndefinite(cause)) != "global"
  }

  /**
   * Holds if our approximation of possible callees for this call site is
   * likely to be imprecise or incomplete.
   */
  predicate isUncertain() { this.isImprecise() or this.isIncomplete() }

  /**
   * Gets the data flow node representing an exception thrown from this invocation.
   */
  DataFlow::ExceptionalInvocationReturnNode getExceptionalReturn() {
    DataFlow::exceptionalInvocationReturnNode(result, this.asExpr())
  }
}

/**
 * A data flow node corresponding to a function call without `new`.
 *
 * Examples:
 * ```js
 * Math.abs(x)
 * ```
 */
class CallNode extends InvokeNode instanceof DataFlow::Impl::CallNodeDef {
  /**
   * Gets the data flow node corresponding to the receiver expression of this method call.
   *
   * For example, the receiver of `x.m()` is `x`.
   */
  DataFlow::Node getReceiver() { result = super.getReceiver() }
}

/**
 * A data flow node corresponding to a method call, that is,
 * a call of form `x.m(...)`.
 *
 * Examples:
 * ```js
 * obj.foo()
 * Math.abs(x)
 * ```
 */
class MethodCallNode extends CallNode instanceof DataFlow::Impl::MethodCallNodeDef {
  /** Gets the name of the invoked method, if it can be determined. */
  string getMethodName() { result = super.getMethodName() }

  /**
   * Holds if this data flow node calls method `methodName` on receiver node `receiver`.
   */
  predicate calls(DataFlow::Node receiver, string methodName) {
    receiver = this.getReceiver() and
    methodName = this.getMethodName()
  }
}

/**
 * A data flow node corresponding to a `new` expression.
 *
 * Examples:
 * ```js
 * new Array(16)
 * ```
 */
class NewNode extends InvokeNode instanceof DataFlow::Impl::NewNodeDef { }

/**
 * A data flow node corresponding to the `this` parameter in a function or `this` at the top-level.
 *
 * Each function only has one `this` node, even if it references `this` multiple times.
 */
class ThisNode extends DataFlow::Node, DataFlow::SourceNode {
  ThisNode() { DataFlow::thisNode(this, _) }

  /**
   * Gets the function whose `this` binding this expression refers to,
   * which is the nearest enclosing non-arrow function.
   */
  FunctionNode getBinder() {
    exists(Function binder |
      DataFlow::thisNode(this, binder) and
      result = DataFlow::valueNode(binder)
    )
  }

  /**
   * Gets the function or top-level whose `this` binding this expression refers to,
   * which is the nearest enclosing non-arrow function or top-level.
   */
  StmtContainer getBindingContainer() { DataFlow::thisNode(this, result) }
}

/**
 * A data flow node corresponding to a global variable access through a simple identifier.
 *
 * For example, this includes `document` but not `window.document`.
 * To recognize global variable access more generally, instead use `DataFlow::globalVarRef`
 * or the member predicate `accessesGlobal`.
 *
 * Examples:
 * ```js
 * document
 * Math
 * NaN
 * undefined
 * ```
 */
class GlobalVarRefNode extends DataFlow::ValueNode, DataFlow::SourceNode {
  override GlobalVarAccess astNode;

  /** Gets the name of the global variable. */
  string getName() { result = astNode.getName() }
}

/**
 * Gets a data flow node corresponding to an access to the global object, including
 * `this` expressions outside functions, references to global variables `window`
 * and `global`, and uses of the `global` npm package.
 *
 * Examples:
 * ```js
 * window
 * window.window
 * global
 * globalThis
 * this
 * self
 * require('global/window')
 * ```
 */
DataFlow::SourceNode globalObjectRef() {
  // top-level `this`
  exists(StmtContainer sc |
    sc = result.(ThisNode).getBindingContainer() and
    not sc instanceof Function and
    not sc instanceof Templating::TemplateTopLevel
  )
  or
  // DOM
  result = globalVariable("window")
  or
  // Node.js
  result = globalVariable("global")
  or
  // DOM and service workers
  result = globalVariable("self")
  or
  // ECMAScript 2020
  result = globalVariable("globalThis")
  or
  // `require("global")`
  result = moduleImport("global")
  or
  // Closure library - based on AST to avoid recursion with Closure library model
  result = globalVariable("goog").getAPropertyRead("global")
}

/**
 * Gets a reference to a global variable `name`.
 * For example, if `name` is "foo":
 * ```js
 * foo
 * require('global/foo')
 * ```
 */
private DataFlow::SourceNode globalVariable(string name) {
  result.(GlobalVarRefNode).getName() = name
  or
  // `require("global/document")` or `require("global/window")`
  (name = "document" or name = "window") and
  result = moduleImport("global/" + name)
}

/**
 * Gets a data flow node corresponding to an access to global variable `name`,
 * either directly, through `window` or `global`, or through the `global` npm package.
 *
 * Examples:
 * ```js
 * document
 * Math
 * window.document
 * window.Math
 * require('global/document')
 * ```
 */
pragma[nomagic]
DataFlow::SourceNode globalVarRef(string name) {
  result = globalVariable(name)
  or
  result = globalObjectRef().getAPropertyReference(name)
}

/**
 * A data flow node corresponding to a function definition.
 *
 * Examples:
 *
 * ```
 * function greet() {         // function declaration
 *   console.log("Hi");
 * }
 *
 * var greet =
 *   function() {             // function expression
 *     console.log("Hi");
 *   };
 *
 * var greet2 =
 *   () => console.log("Hi")  // arrow function expression
 *
 * var o = {
 *   m() {                    // function expression in a method definition in an object literal
 *     return 0;
 *   },
 *   get x() {                // function expression in a getter method definition in an object literal
 *     return 1
 *   }
 * };
 *
 * class C {
 *   m() {                    // function expression in a method definition in a class
 *     return 0;
 *   }
 * }
 * ```
 */
class FunctionNode extends DataFlow::ValueNode, DataFlow::SourceNode {
  override Function astNode;

  /** Gets the `i`th parameter of this function. */
  ParameterNode getParameter(int i) { result = DataFlow::parameterNode(astNode.getParameter(i)) }

  /** Gets a parameter of this function. */
  ParameterNode getAParameter() { result = this.getParameter(_) }

  /** Gets the parameter named `name` of this function, if any. */
  DataFlow::ParameterNode getParameterByName(string name) {
    result = this.getAParameter() and
    result.getName() = name
  }

  /** Gets the number of parameters declared on this function. */
  int getNumParameter() { result = count(astNode.getAParameter()) }

  /** Gets the last parameter of this function. */
  ParameterNode getLastParameter() { result = this.getParameter(this.getNumParameter() - 1) }

  /** Holds if the last parameter of this function is a rest parameter. */
  predicate hasRestParameter() { astNode.hasRestParameter() }

  /** Gets the unqualified name of this function, if it has one or one can be determined from the context. */
  string getName() { result = astNode.getName() }

  /** Gets a data flow node corresponding to a return value of this function. */
  DataFlow::Node getAReturn() { result = astNode.getAReturnedExpr().flow() }

  /**
   * Gets the function this node corresponds to.
   */
  Function getFunction() { result = astNode }

  /**
   * Gets the function whose `this` binding a `this` expression in this function refers to,
   * which is the nearest enclosing non-arrow function.
   */
  FunctionNode getThisBinder() { result.getFunction() = this.getFunction().getThisBinder() }

  /**
   * Gets the dataflow node holding the value of the receiver passed to the given function.
   *
   * Has no result for arrow functions, as they ignore the receiver argument.
   *
   * To get the data flow node for `this` in an arrow function, consider using `getThisBinder().getReceiver()`.
   */
  ThisNode getReceiver() { result.getBinder() = this }

  /**
   * Gets the data flow node representing an exception thrown from this function.
   */
  DataFlow::ExceptionalFunctionReturnNode getExceptionalReturn() {
    DataFlow::exceptionalFunctionReturnNode(result, astNode)
  }

  /**
   * Gets the data flow node representing the value returned from this function.
   *
   * Note that this differs from `getAReturn()`, in that every function has exactly
   * one canonical return node, but may have multiple (or zero) returned expressions.
   * The result of `getAReturn()` is always a predecessor of `getReturnNode()`
   * in the data-flow graph.
   */
  DataFlow::FunctionReturnNode getReturnNode() { DataFlow::functionReturnNode(result, astNode) }
}

/**
 * A data flow node corresponding to an object literal expression.
 *
 * Example:
 * ```js
 * var p = {  // object literal containing five property definitions
 *   x: 1,
 *   y: 1,
 *   diag: function() { return this.x - this.y; },
 *   get area() { return this.x * this.y; },
 *   set area(a) { this.x = Math.sqrt(a); this.y = Math.sqrt(a); }
 * };
 * ```
 */
class ObjectLiteralNode extends DataFlow::ValueNode, DataFlow::SourceNode {
  override ObjectExpr astNode;

  /** Gets the value of a spread property of this object literal, such as `x` in `{...x}` */
  DataFlow::Node getASpreadProperty() {
    result = astNode.getAProperty().(SpreadProperty).getInit().(SpreadElement).getOperand().flow()
  }

  /** Gets the property getter of the given name, installed on this object literal. */
  DataFlow::FunctionNode getPropertyGetter(string name) {
    result = astNode.getPropertyByName(name).(PropertyGetter).getInit().flow()
  }

  /** Gets the property setter of the given name, installed on this object literal. */
  DataFlow::FunctionNode getPropertySetter(string name) {
    result = astNode.getPropertyByName(name).(PropertySetter).getInit().flow()
  }

  /** Gets the value of a computed property name of this object literal, such as `x` in `{[x]: 1}` */
  DataFlow::Node getAComputedPropertyName() {
    exists(Property prop | prop = astNode.getAProperty() |
      prop.isComputed() and
      result = prop.getNameExpr().flow()
    )
  }
}

/**
 * A data flow node corresponding to an array literal expression.
 *
 * Example:
 * ```
 * [ 1, , [ 3, 4 ] ]
 * ```
 */
class ArrayLiteralNode extends DataFlow::ValueNode, DataFlow::SourceNode {
  override ArrayExpr astNode;

  /** Gets the `i`th element of this array literal. */
  DataFlow::ValueNode getElement(int i) { result = DataFlow::valueNode(astNode.getElement(i)) }

  /** Gets an element of this array literal. */
  DataFlow::ValueNode getAnElement() { result = DataFlow::valueNode(astNode.getAnElement()) }

  /** Gets the initial size of this array. */
  int getSize() { result = astNode.getSize() }
}

/**
 * A data-flow node corresponding to a regular-expression literal.
 *
 * Examples:
 * ```js
 * /https?/i
 * ```
 */
class RegExpLiteralNode extends DataFlow::ValueNode, DataFlow::SourceNode {
  override RegExpLiteral astNode;

  /** Holds if this regular expression has a `g` flag. */
  predicate isGlobal() { astNode.isGlobal() }

  /** Gets the root term of this regular expression. */
  RegExpTerm getRoot() { result = astNode.getRoot() }

  /** Gets the flags of this regular expression literal. */
  string getFlags() { result = astNode.getFlags() }
}

/**
 * A data flow node corresponding to a `new Array()` or `Array()` invocation.
 *
 * Examples:
 * ```js
 * Array('apple', 'orange') // two initial elements
 * new Array('apple', 'orange')
 * Array(16) // size 16 but no initial elements
 * new Array(16)
 * ```
 */
class ArrayConstructorInvokeNode extends DataFlow::InvokeNode {
  ArrayConstructorInvokeNode() { this.getCalleeNode() = DataFlow::globalVarRef("Array") }

  /** Gets the `i`th initial element of this array, if one is provided. */
  DataFlow::ValueNode getElement(int i) {
    this.getNumArgument() > 1 and // A single-argument invocation specifies the array length, not an element.
    result = this.getArgument(i)
  }

  /** Gets an initial element of this array, if one is provided. */
  DataFlow::ValueNode getAnElement() {
    this.getNumArgument() > 1 and
    result = this.getAnArgument()
  }

  /** Gets the initial size of the created array, if it can be determined. */
  int getSize() {
    if this.getNumArgument() = 1
    then result = this.getArgument(0).getIntValue()
    else result = count(this.getAnElement())
  }
}

/**
 * A data flow node corresponding to the creation or a new array, either through an array literal,
 * an invocation of the `Array` constructor, or the `Array.from` method.
 *
 *
 * Examples:
 * ```js
 * ['apple', 'orange'];
 * Array('apple', 'orange')
 * new Array('apple', 'orange')
 * Array(16)
 * new Array(16)
 * ```
 */
class ArrayCreationNode extends DataFlow::ValueNode, DataFlow::SourceNode {
  ArrayCreationNode() {
    this instanceof ArrayLiteralNode or
    this instanceof ArrayConstructorInvokeNode
  }

  /** Gets the `i`th initial element of this array, if one is provided. */
  DataFlow::ValueNode getElement(int i) {
    result = this.(ArrayLiteralNode).getElement(i) or
    result = this.(ArrayConstructorInvokeNode).getElement(i)
  }

  /** Gets an initial element of this array, if one if provided. */
  DataFlow::ValueNode getAnElement() { result = this.getElement(_) }

  /** Gets the initial size of the created array, if it can be determined. */
  int getSize() {
    result = this.(ArrayLiteralNode).getSize() or
    result = this.(ArrayConstructorInvokeNode).getSize()
  }

  /**
   * Gets a data flow node corresponding to an array of values being passed as
   * individual arguments to this array creation.
   */
  DataFlow::Node getASpreadArgument() {
    exists(SpreadElement arg | arg = this.getAnElement().getEnclosingExpr() |
      result = DataFlow::valueNode(arg.getOperand())
    )
  }
}

/**
 * A data flow node representing an import of a module, either through
 * an `import` declaration, a call to `require`, or an AMD dependency parameter.
 *
 * For compatibility with old transpilers, we treat both `import * as x from '...'` and
 * `import x from '...'` as module import nodes.
 *
 * Additional import nodes can be added by subclassing `ModuleImportNode::Range`.
 *
 * Examples:
 * ```js
 * require('fs');
 * import * as fs from 'fs';
 * import fs from 'fs';
 * import { readDir } from 'fs'; // Note: 'readDir' is a PropRead with a ModuleImportNode as base
 * define(["fs"], function(fs) { ... }); // AMD module
 * ```
 */
class ModuleImportNode extends DataFlow::SourceNode instanceof ModuleImportNode::Range {
  /** Gets the path of the imported module. */
  string getPath() { result = super.getPath() }
}

module ModuleImportNode {
  /**
   * A data flow node that refers to an imported module.
   */
  abstract class Range extends DataFlow::SourceNode {
    /** Gets the path of the imported module. */
    abstract string getPath();
  }

  private class DefaultRange extends Range {
    string path;

    DefaultRange() {
      exists(Import i |
        this = i.getImportedModuleNode() and
        i.getImportedPath().getValue() = path
      )
      or
      // AMD require
      exists(AmdModuleDefinition amd, CallExpr req |
        req = amd.getARequireCall() and
        this = DataFlow::valueNode(req) and
        path = req.getArgument(0).getStringValue()
      )
    }

    /** Gets the path of the imported module. */
    override string getPath() { result = path }
  }
}

/**
 * Gets a (default) import of the module with the given path, such as `require("fs")`
 * or `import * as fs from "fs"`.
 *
 * This predicate can be extended by subclassing `ModuleImportNode::Range`.
 */
cached
ModuleImportNode moduleImport(string path) {
  // NB. internal modules may be imported with a "node:" prefix
  Stages::Imports::ref() and result.getPath() = ["node:" + path, path]
}

/**
 * Gets a (default) import of the given dependency `dep`, such as
 * `require("lodash")` in a context where a package.json file includes
 * `"lodash"` as a dependency.
 */
ModuleImportNode dependencyModuleImport(Dependency dep) {
  result = dep.getAUse("import").(Import).getImportedModuleNode()
}

/**
 * Gets a data flow node that either imports `m` from the module with
 * the given `path`, or accesses `m` as a member on a default or
 * namespace import from `path`.
 */
DataFlow::SourceNode moduleMember(string path, string m) {
  result = moduleImport(path).getAPropertyRead(m)
}

/**
 * The string `method`, `getter`, or `setter`, representing the kind of a function member
 * in a class.
 *
 * Can can be used with `ClassNode.getInstanceMember` to obtain members of a specific kind.
 */
class MemberKind extends string {
  MemberKind() { this = "method" or this = "getter" or this = "setter" }

  /** Holds if this is the `method` kind. */
  predicate isMethod() { this = MemberKind::method() }

  /** Holds if this is the `getter` kind. */
  predicate isGetter() { this = MemberKind::getter() }

  /** Holds if this is the `setter` kind. */
  predicate isSetter() { this = MemberKind::setter() }

  /** Holds if this is the `getter` or `setter` kind. */
  predicate isAccessor() { this = MemberKind::accessor() }
}

private import internal.StepSummary

module MemberKind {
  /** Gets the kind of a method, such as `m() {}` */
  MemberKind method() { result = "method" }

  /** Gets the kind of a getter accessor, such as `get f() {}`. */
  MemberKind getter() { result = "getter" }

  /** Gets the kind of a setter accessor, such as `set f() {}`. */
  MemberKind setter() { result = "setter" }

  /** Gets the `getter` and `setter` kinds. */
  MemberKind accessor() { result = getter() or result = setter() }

  /**
   * Gets the member kind of a given syntactic member declaration in a class.
   */
  MemberKind of(MemberDeclaration decl) {
    decl instanceof GetterMethodDeclaration and result = getter()
    or
    decl instanceof SetterMethodDeclaration and result = setter()
    or
    decl instanceof MethodDeclaration and
    not decl instanceof AccessorMethodDeclaration and
    not decl instanceof ConstructorDeclaration and
    result = method()
  }
}

/**
 * A data flow node corresponding to a class definition or a function definition
 * acting as a class.
 *
 * The following patterns are recognized as classes and methods:
 * ```
 * class C {
 *   method()
 * }
 *
 * function F() {}
 *
 * F.prototype.method = function() {}
 *
 * F.prototype = {
 *   method: function() {}
 * }
 *
 * extend(F.prototype, {
 *   method: function() {}
 * });
 * ```
 *
 * Additional patterns can be recognized as class nodes, by extending `DataFlow::ClassNode::Range`.
 */
class ClassNode extends DataFlow::SourceNode instanceof ClassNode::Range {
  /**
   * Gets the unqualified name of the class, if it has one or one can be determined from the context.
   */
  string getName() { result = super.getName() }

  /**
   * Gets a description of the class.
   */
  string describe() { result = super.describe() }

  /**
   * Gets the constructor function of this class.
   */
  FunctionNode getConstructor() { result = super.getConstructor() }

  /**
   * Gets an instance method declared in this class, with the given name, if any.
   *
   * Does not include methods from superclasses.
   */
  FunctionNode getInstanceMethod(string name) {
    result = super.getInstanceMember(name, MemberKind::method())
  }

  /**
   * Gets an instance method declared in this class.
   *
   * The constructor is not considered an instance method.
   *
   * Does not include methods from superclasses.
   */
  FunctionNode getAnInstanceMethod() { result = super.getAnInstanceMember(MemberKind::method()) }

  /**
   * Gets the instance method, getter, or setter with the given name and kind.
   *
   * Does not include members from superclasses.
   */
  FunctionNode getInstanceMember(string name, MemberKind kind) {
    result = super.getInstanceMember(name, kind)
  }

  /**
   * Gets an instance method, getter, or setter with the given kind.
   *
   * Does not include members from superclasses.
   */
  FunctionNode getAnInstanceMember(MemberKind kind) { result = super.getAnInstanceMember(kind) }

  /**
   * Gets an instance method, getter, or setter declared in this class.
   *
   * Does not include members from superclasses.
   */
  FunctionNode getAnInstanceMember() { result = super.getAnInstanceMember(_) }

  /**
   * Gets the static method, getter, or setter declared in this class with the given name and kind.
   */
  FunctionNode getStaticMember(string name, MemberKind kind) {
    result = super.getStaticMember(name, kind)
  }

  /**
   * Gets the static method declared in this class with the given name.
   */
  FunctionNode getStaticMethod(string name) {
    result = this.getStaticMember(name, MemberKind::method())
  }

  /**
   * Gets a static method, getter, or setter declared in this class with the given kind.
   */
  FunctionNode getAStaticMember(MemberKind kind) { result = super.getAStaticMember(kind) }

  /**
   * Gets a static method declared in this class.
   *
   * The constructor is not considered a static method.
   */
  FunctionNode getAStaticMethod() { result = this.getAStaticMember(MemberKind::method()) }

  /**
   * Gets a dataflow node that refers to the superclass of this class.
   */
  DataFlow::Node getASuperClassNode() { result = super.getASuperClassNode() }

  /**
   * Gets a direct super class of this class.
   *
   * This predicate can be overridden to customize the class hierarchy.
   */
  ClassNode getADirectSuperClass() {
    result.getAClassReference().flowsTo(this.getASuperClassNode())
  }

  /**
   * Gets a direct subclass of this class.
   */
  final ClassNode getADirectSubClass() { this = result.getADirectSuperClass() }

  /**
   * Gets the receiver of an instance member or constructor of this class.
   */
  DataFlow::SourceNode getAReceiverNode() {
    result = this.getConstructor().getReceiver()
    or
    result = this.getAnInstanceMember().getReceiver()
  }

  /**
   * Gets the abstract value representing the class itself.
   */
  AbstractValue getAbstractClassValue() { result = this.(AnalyzedNode).getAValue() }

  /**
   * Gets the abstract value representing an instance of this class.
   */
  AbstractValue getAbstractInstanceValue() { result = AbstractInstance::of(this.getAstNode()) }

  /**
   * Gets a dataflow node that refers to this class object.
   *
   * This predicate can be overridden to customize the tracking of class objects.
   */
  DataFlow::SourceNode getAClassReference(DataFlow::TypeTracker t) {
    t.start() and
    result.(AnalyzedNode).getAValue() = this.getAbstractClassValue() and
    (
      not CallGraph::isIndefiniteGlobal(result)
      or
      result.getAstNode().getFile() = this.getAstNode().getFile()
    )
    or
    t.start() and
    PreCallGraphStep::classObjectSource(this, result)
    or
    result = this.getAClassReferenceRec(t)
  }

  pragma[noopt]
  private DataFlow::SourceNode getAClassReferenceRec(DataFlow::TypeTracker t) {
    exists(DataFlow::TypeTracker t2, StepSummary summary, DataFlow::SourceNode prev |
      prev = this.getAClassReference(t2) and
      StepSummary::step(prev, result, summary) and
      t = t2.append(summary)
    )
  }

  /**
   * Gets a dataflow node that refers to this class object.
   */
  cached
  final DataFlow::SourceNode getAClassReference() {
    result = this.getAClassReference(DataFlow::TypeTracker::end())
  }

  /**
   * Gets a dataflow node that refers to an instance of this class.
   *
   * This predicate can be overridden to customize the tracking of class instances.
   */
  DataFlow::SourceNode getAnInstanceReference(DataFlow::TypeTracker t) {
    result = this.getAClassReference(t.continue()).getAnInstantiation()
    or
    t.start() and
    result.(AnalyzedNode).getAValue() = this.getAbstractInstanceValue() and
    not result = any(DataFlow::ClassNode cls).getAReceiverNode()
    or
    t.start() and
    result = this.getAReceiverNode()
    or
    // Use a parameter type as starting point of type tracking.
    // Use `t.call()` to emulate the value being passed in through an unseen
    // call site, but not out of the call again.
    t.call() and
    exists(Parameter param |
      this = param.getTypeAnnotation().getClass() and
      result = DataFlow::parameterNode(param)
    )
    or
    result = this.getAnInstanceReferenceAux(t) and
    // Avoid tracking into the receiver of other classes.
    // Note that this also blocks flows into a property of the receiver,
    // but the `localFieldStep` rule will often compensate for this.
    not result = any(DataFlow::ClassNode cls).getAReceiverNode()
    or
    t.start() and
    PreCallGraphStep::classInstanceSource(this, result)
  }

  pragma[noinline]
  private DataFlow::SourceNode getAnInstanceReferenceAux(DataFlow::TypeTracker t) {
    exists(DataFlow::TypeTracker t2 | result = this.getAnInstanceReference(t2).track(t2, t))
  }

  /**
   * Gets a dataflow node that refers to an instance of this class.
   */
  cached
  final DataFlow::SourceNode getAnInstanceReference() {
    result = this.getAnInstanceReference(DataFlow::TypeTracker::end())
  }

  /**
   * Gets a property read that accesses the property `name` on an instance of this class.
   *
   * Concretely, this holds when the base is an instance of this class or a subclass thereof.
   */
  pragma[nomagic]
  DataFlow::PropRead getAnInstanceMemberAccess(string name, DataFlow::TypeTracker t) {
    result = this.getAnInstanceReference(t.continue()).getAPropertyRead(name)
    or
    exists(DataFlow::ClassNode subclass |
      result = subclass.getAnInstanceMemberAccess(name, t) and
      not exists(subclass.getInstanceMember(name, _)) and
      this = subclass.getADirectSuperClass()
    )
  }

  /**
   * Gets a property read that accesses the property `name` on an instance of this class.
   *
   * Concretely, this holds when the base is an instance of this class or a subclass thereof.
   */
  DataFlow::PropRead getAnInstanceMemberAccess(string name) {
    result = this.getAnInstanceMemberAccess(name, DataFlow::TypeTracker::end())
  }

  /**
   * Gets an access to a static member of this class.
   */
  DataFlow::PropRead getAStaticMemberAccess(string name) {
    result = this.getAClassReference().getAPropertyRead(name)
  }

  /**
   * Holds if this class is exposed in the global scope through the given qualified name.
   */
  pragma[noinline]
  predicate hasQualifiedName(string name) {
    this.getAClassReference().flowsTo(AccessPath::getAnAssignmentTo(name))
  }

  /**
   * Gets the type annotation for the field `fieldName`, if any.
   */
  TypeAnnotation getFieldTypeAnnotation(string fieldName) {
    result = super.getFieldTypeAnnotation(fieldName)
  }

  /**
   * Gets a decorator applied to this class.
   */
  DataFlow::Node getADecorator() { result = super.getADecorator() }
}

module ClassNode {
  /**
   * A dataflow node that should be considered a class node.
   *
   * Subclass this to introduce new kinds of class nodes. If you want to refine
   * the definition of existing class nodes, subclass `DataFlow::ClassNode` instead.
   */
  cached
  abstract class Range extends DataFlow::SourceNode {
    /**
     * Gets the name of the class, if it has one.
     */
    cached
    abstract string getName();

    /**
     * Gets a description of the class.
     */
    cached
    abstract string describe();

    /**
     * Gets the constructor function of this class.
     */
    cached
    abstract FunctionNode getConstructor();

    /**
     * Gets the instance member with the given name and kind.
     */
    cached
    abstract FunctionNode getInstanceMember(string name, MemberKind kind);

    /**
     * Gets an instance member with the given kind.
     */
    cached
    abstract FunctionNode getAnInstanceMember(MemberKind kind);

    /**
     * Gets the static member of this class with the given name and kind.
     */
    cached
    abstract FunctionNode getStaticMember(string name, MemberKind kind);

    /**
     * Gets a static member of this class of the given kind.
     */
    cached
    abstract FunctionNode getAStaticMember(MemberKind kind);

    /**
     * Gets a dataflow node representing a class to be used as the super-class
     * of this node.
     */
    cached
    abstract DataFlow::Node getASuperClassNode();

    /**
     * Gets the type annotation for the field `fieldName`, if any.
     */
    cached
    TypeAnnotation getFieldTypeAnnotation(string fieldName) { none() }

    /** Gets a decorator applied to this class. */
    cached
    DataFlow::Node getADecorator() { none() }
  }

  /**
   * An ES6 class as a `ClassNode` instance.
   */
  private class ES6Class extends Range, DataFlow::ValueNode {
    override ClassDefinition astNode;

    override string getName() { result = astNode.getName() }

    override string describe() { result = astNode.describe() }

    override FunctionNode getConstructor() { result = astNode.getConstructor().getBody().flow() }

    override FunctionNode getInstanceMember(string name, MemberKind kind) {
      exists(MethodDeclaration method |
        method = astNode.getMethod(name) and
        not method.isStatic() and
        kind = MemberKind::of(method) and
        result = method.getBody().flow()
      )
      or
      kind = MemberKind::method() and
      result = this.getConstructor().getReceiver().getAPropertySource(name)
    }

    override FunctionNode getAnInstanceMember(MemberKind kind) {
      exists(MethodDeclaration method |
        method = astNode.getAMethod() and
        not method.isStatic() and
        kind = MemberKind::of(method) and
        result = method.getBody().flow()
      )
      or
      kind = MemberKind::method() and
      result = this.getConstructor().getReceiver().getAPropertySource()
    }

    override FunctionNode getStaticMember(string name, MemberKind kind) {
      exists(MethodDeclaration method |
        method = astNode.getMethod(name) and
        method.isStatic() and
        kind = MemberKind::of(method) and
        result = method.getBody().flow()
      )
      or
      kind.isMethod() and
      result = this.getAPropertySource(name)
    }

    override FunctionNode getAStaticMember(MemberKind kind) {
      exists(MethodDeclaration method |
        method = astNode.getAMethod() and
        method.isStatic() and
        kind = MemberKind::of(method) and
        result = method.getBody().flow()
      )
      or
      kind.isMethod() and
      result = this.getAPropertySource()
    }

    override DataFlow::Node getASuperClassNode() { result = astNode.getSuperClass().flow() }

    override TypeAnnotation getFieldTypeAnnotation(string fieldName) {
      exists(FieldDeclaration field |
        field.getDeclaringClass() = astNode and
        fieldName = field.getName() and
        result = field.getTypeAnnotation()
      )
    }

    override DataFlow::Node getADecorator() {
      result = astNode.getADecorator().getExpression().flow()
    }
  }

  private DataFlow::PropRef getAPrototypeReferenceInFile(string name, File f) {
    result.getBase() = AccessPath::getAReferenceOrAssignmentTo(name) and
    result.getPropertyName() = "prototype" and
    result.getFile() = f
  }

  pragma[nomagic]
  private DataFlow::NewNode getAnInstantiationInFile(string name, File f) {
    result = AccessPath::getAReferenceTo(name).(DataFlow::LocalSourceNode).getAnInstantiation() and
    result.getFile() = f
  }

  /**
   * Gets a reference to the function `func`, where there exists a read/write of the "prototype" property on that reference.
   */
  pragma[noinline]
  private DataFlow::SourceNode getAFunctionValueWithPrototype(AbstractValue func) {
    exists(result.getAPropertyReference("prototype")) and
    result.analyze().getAValue() = pragma[only_bind_into](func) and
    func instanceof AbstractFunction // the join-order goes bad if `func` has type `AbstractFunction`.
  }

  /**
   * A function definition, targeted by a `new`-call or with prototype manipulation, seen as a `ClassNode` instance.
   */
  class FunctionStyleClass extends Range, DataFlow::ValueNode {
    override Function astNode;
    AbstractFunction function;

    FunctionStyleClass() {
      function.getFunction() = astNode and
      (
        exists(getAFunctionValueWithPrototype(function))
        or
        function = any(NewNode new).getCalleeNode().analyze().getAValue()
        or
        exists(string name | this = AccessPath::getAnAssignmentTo(name) |
          exists(getAPrototypeReferenceInFile(name, this.getFile()))
          or
          exists(getAnInstantiationInFile(name, this.getFile()))
        )
      )
    }

    override string getName() { result = astNode.getName() }

    override string describe() { result = astNode.describe() }

    override FunctionNode getConstructor() { result = this }

    private PropertyAccessor getAnAccessor(MemberKind kind) {
      result.getObjectExpr() = this.getAPrototypeReference().asExpr() and
      (
        kind = MemberKind::getter() and
        result instanceof PropertyGetter
        or
        kind = MemberKind::setter() and
        result instanceof PropertySetter
      )
    }

    override FunctionNode getInstanceMember(string name, MemberKind kind) {
      kind = MemberKind::method() and
      result = this.getAPrototypeReference().getAPropertySource(name)
      or
      kind = MemberKind::method() and
      result = this.getConstructor().getReceiver().getAPropertySource(name)
      or
      exists(PropertyAccessor accessor |
        accessor = this.getAnAccessor(kind) and
        accessor.getName() = name and
        result = accessor.getInit().flow()
      )
    }

    override FunctionNode getAnInstanceMember(MemberKind kind) {
      kind = MemberKind::method() and
      result = this.getAPrototypeReference().getAPropertySource()
      or
      kind = MemberKind::method() and
      result = this.getConstructor().getReceiver().getAPropertySource()
      or
      exists(PropertyAccessor accessor |
        accessor = this.getAnAccessor(kind) and
        result = accessor.getInit().flow()
      )
    }

    override FunctionNode getStaticMember(string name, MemberKind kind) {
      kind.isMethod() and
      result = this.getAPropertySource(name)
    }

    override FunctionNode getAStaticMember(MemberKind kind) {
      kind.isMethod() and
      result = this.getAPropertySource()
    }

    /**
     * Gets a reference to the prototype of this class.
     */
    DataFlow::SourceNode getAPrototypeReference() {
      exists(DataFlow::SourceNode base | base = getAFunctionValueWithPrototype(function) |
        result = base.getAPropertyRead("prototype")
        or
        result = base.getAPropertySource("prototype")
      )
      or
      exists(string name |
        this = AccessPath::getAnAssignmentTo(name) and
        result = getAPrototypeReferenceInFile(name, this.getFile())
      )
      or
      exists(ExtendCall call |
        call.getDestinationOperand() = this.getAPrototypeReference() and
        result = call.getASourceOperand()
      )
    }

    override DataFlow::Node getASuperClassNode() {
      // C.prototype = Object.create(D.prototype)
      exists(DataFlow::InvokeNode objectCreate, DataFlow::PropRead superProto |
        this.getAPropertySource("prototype") = objectCreate and
        objectCreate = DataFlow::globalVarRef("Object").getAMemberCall("create") and
        superProto.flowsTo(objectCreate.getArgument(0)) and
        superProto.getPropertyName() = "prototype" and
        result = superProto.getBase()
      )
      or
      // C.prototype = new D()
      exists(DataFlow::NewNode newCall |
        this.getAPropertySource("prototype") = newCall and
        result = newCall.getCalleeNode()
      )
      or
      // util.inherits(C, D);
      exists(DataFlow::CallNode inheritsCall |
        inheritsCall = DataFlow::moduleMember("util", "inherits").getACall()
      |
        this = inheritsCall.getArgument(0).getALocalSource() and
        result = inheritsCall.getArgument(1)
      )
    }
  }
}

/**
 * A data flow node that performs a partial function application.
 *
 * Examples:
 * ```js
 * fn.bind(this)
 * x.method.bind(x)
 * _.partial(fn, x, y, z)
 * ```
 */
class PartialInvokeNode extends DataFlow::Node instanceof PartialInvokeNode::Range {
  /** Gets a node holding a callback invoked by this partial invocation node. */
  DataFlow::Node getACallbackNode() {
    this.isPartialArgument(result, _, _)
    or
    exists(this.getBoundReceiver(result))
  }

  /**
   * Holds if `argument` is passed as argument `index` to the function in `callback`.
   */
  predicate isPartialArgument(DataFlow::Node callback, DataFlow::Node argument, int index) {
    super.isPartialArgument(callback, argument, index)
  }

  /**
   * Gets a node referring to a bound version of `callback` with `boundArgs` arguments bound.
   */
  DataFlow::SourceNode getBoundFunction(DataFlow::Node callback, int boundArgs) {
    result = super.getBoundFunction(callback, boundArgs)
  }

  /**
   * Gets the node holding the receiver to be passed to the bound function, if specified.
   */
  DataFlow::Node getBoundReceiver() { result = super.getBoundReceiver(_) }

  /**
   * Gets the node holding the receiver to be passed to the bound function, if specified.
   */
  DataFlow::Node getBoundReceiver(DataFlow::Node callback) {
    result = super.getBoundReceiver(callback)
  }
}

module PartialInvokeNode {
  /**
   * A data flow node that performs a partial function application.
   */
  abstract class Range extends DataFlow::Node {
    /**
     * Holds if `argument` is passed as argument `index` to the function in `callback`.
     */
    predicate isPartialArgument(DataFlow::Node callback, DataFlow::Node argument, int index) {
      none()
    }

    /**
     * Gets a node referring to a bound version of `callback` with `boundArgs` arguments bound.
     */
    DataFlow::SourceNode getBoundFunction(DataFlow::Node callback, int boundArgs) { none() }

    /**
     * Gets the node holding the receiver to be passed to `callback`.
     */
    DataFlow::Node getBoundReceiver(DataFlow::Node callback) { none() }
  }

  /**
   * A partial call through the built-in `Function.prototype.bind`.
   */
  private class BindPartialCall extends PartialInvokeNode::Range, DataFlow::MethodCallNode {
    BindPartialCall() {
      this.getMethodName() = "bind" and
      // Avoid overlap with angular.bind and goog.bind
      not this = AngularJS::angular().getAMethodCall() and
      not this.getReceiver().accessesGlobal("goog")
    }

    override predicate isPartialArgument(DataFlow::Node callback, DataFlow::Node argument, int index) {
      index >= 0 and
      callback = this.getReceiver() and
      argument = this.getArgument(index + 1)
    }

    override DataFlow::SourceNode getBoundFunction(DataFlow::Node callback, int boundArgs) {
      callback = this.getReceiver() and
      boundArgs = this.getNumArgument() - 1 and
      result = this
    }

    override DataFlow::Node getBoundReceiver(DataFlow::Node callback) {
      callback = this.getReceiver() and
      result = this.getArgument(0)
    }
  }

  /**
   * A partial call through `_.partial`.
   */
  private class LodashPartialCall extends PartialInvokeNode::Range, DataFlow::CallNode {
    LodashPartialCall() { this = LodashUnderscore::member("partial").getACall() }

    override predicate isPartialArgument(DataFlow::Node callback, DataFlow::Node argument, int index) {
      index >= 0 and
      callback = this.getArgument(0) and
      argument = this.getArgument(index + 1)
    }

    override DataFlow::SourceNode getBoundFunction(DataFlow::Node callback, int boundArgs) {
      callback = this.getArgument(0) and
      boundArgs = this.getNumArgument() - 1 and
      result = this
    }
  }

  /**
   * A partial call that behaves like a throttle call, like `require("call-limit")(fs, limit)` or `_.memoize`.
   * Seen as a partial invocation that binds no arguments.
   */
  private class ThrottleLikePartialCall extends PartialInvokeNode::Range, DataFlow::CallNode {
    int callbackIndex;

    ThrottleLikePartialCall() {
      callbackIndex = 0 and
      (
        this = LodashUnderscore::member(["throttle", "debounce", "once", "memoize"]).getACall()
        or
        this = DataFlow::moduleImport(["call-limit", "debounce"]).getACall()
      )
      or
      callbackIndex = 1 and
      (
        this = LodashUnderscore::member(["after", "before"]).getACall()
        or
        // not jQuery: https://github.com/cowboy/jquery-throttle-debounce
        this = DataFlow::globalVarRef("$").getAMemberCall(["throttle", "debounce"])
      )
      or
      callbackIndex = -1 and
      this = DataFlow::moduleMember("throttle-debounce", ["debounce", "throttle"]).getACall()
    }

    override DataFlow::SourceNode getBoundFunction(DataFlow::Node callback, int boundArgs) {
      (
        callbackIndex >= 0 and
        callback = this.getArgument(callbackIndex)
        or
        callbackIndex = -1 and
        callback = this.getLastArgument()
      ) and
      boundArgs = 0 and
      result = this
    }
  }

  /**
   * A partial call through `ramda.partial`.
   */
  private class RamdaPartialCall extends PartialInvokeNode::Range, DataFlow::CallNode {
    RamdaPartialCall() { this = DataFlow::moduleMember("ramda", "partial").getACall() }

    private DataFlow::ArrayCreationNode getArgumentsArray() { result.flowsTo(this.getArgument(1)) }

    override predicate isPartialArgument(DataFlow::Node callback, DataFlow::Node argument, int index) {
      callback = this.getArgument(0) and
      argument = this.getArgumentsArray().getElement(index)
    }

    override DataFlow::SourceNode getBoundFunction(DataFlow::Node callback, int boundArgs) {
      callback = this.getArgument(0) and
      boundArgs = this.getArgumentsArray().getSize() and
      result = this
    }
  }

  /**
   * A call to `for-in` or `for-own`, passing the context parameter to the target function.
   */
  class ForOwnInPartialCall extends PartialInvokeNode::Range, DataFlow::CallNode {
    ForOwnInPartialCall() {
      exists(string name | name = "for-in" or name = "for-own" |
        this = moduleImport(name).getACall()
      )
    }

    override DataFlow::Node getBoundReceiver(DataFlow::Node callback) {
      callback = this.getArgument(1) and
      result = this.getArgument(2)
    }
  }
}

/**
 * An invocation of the `RegExp` constructor.
 *
 * Example:
 * ```js
 * new RegExp("#[a-z]+", "g");
 * RegExp("^\w*$");
 * ```
 */
class RegExpConstructorInvokeNode extends DataFlow::InvokeNode {
  RegExpConstructorInvokeNode() { this = DataFlow::globalVarRef("RegExp").getAnInvocation() }

  /**
   * Gets the AST of the regular expression created here, provided that the
   * first argument is a string literal.
   */
  RegExpTerm getRoot() {
    result = this.getArgument(0).asExpr().(StringLiteral).asRegExp()
    or
    // In case someone writes `new RegExp(/foo/)` for some reason
    result = this.getArgument(0).asExpr().(RegExpLiteral).getRoot()
  }

  /**
   * Gets the flags provided in the second argument, or an empty string if no
   * flags are provided.
   *
   * Has no result if the flags are provided but are not constant.
   */
  string getFlags() {
    result = this.getArgument(1).getStringValue()
    or
    not exists(this.getArgument(1)) and
    result = ""
  }

  /**
   * Gets the flags provided in the second argument, or an empty string if no
   * flags are provided, or the string `"?"` if the provided flags are not known.
   */
  string tryGetFlags() {
    result = this.getFlags()
    or
    not exists(this.getFlags()) and
    result = RegExp::unknownFlag()
  }
}

/**
 * A data flow node corresponding to a regular expression literal or
 * an invocation of the `RegExp` constructor.
 *
 * Examples:
 * ```js
 * new RegExp("#[a-z]+", "g");
 * RegExp("^\w*$");
 * /[a-z]+/i
 * ```
 */
class RegExpCreationNode extends DataFlow::SourceNode {
  RegExpCreationNode() {
    this instanceof RegExpConstructorInvokeNode or
    this instanceof RegExpLiteralNode
  }

  /**
   * Gets the root term of the created regular expression, if it is known.
   *
   * Has no result for calls to `RegExp` with a non-constant argument.
   */
  RegExpTerm getRoot() {
    result = this.(RegExpConstructorInvokeNode).getRoot() or
    result = this.(RegExpLiteralNode).getRoot()
  }

  /**
   * Gets the provided regular expression flags, if they are known.
   */
  string getFlags() {
    result = this.(RegExpConstructorInvokeNode).getFlags() or
    result = this.(RegExpLiteralNode).getFlags()
  }

  /**
   * Gets the flags provided in the second argument, or an empty string if no
   * flags are provided, or the string `"?"` if the provided flags are not known.
   */
  string tryGetFlags() {
    result = this.(RegExpConstructorInvokeNode).tryGetFlags() or
    result = this.(RegExpLiteralNode).getFlags()
  }

  /** Holds if the constructed predicate has the `g` flag. */
  predicate isGlobal() { RegExp::isGlobal(this.getFlags()) }

  /** Holds if the constructed predicate has the `g` flag or unknown flags. */
  predicate maybeGlobal() { RegExp::maybeGlobal(this.tryGetFlags()) }

  /** Gets a data flow node referring to this regular expression. */
  private DataFlow::SourceNode getAReference(DataFlow::TypeTracker t) {
    t.start() and
    result = this
    or
    exists(DataFlow::TypeTracker t2 | result = this.getAReference(t2).track(t2, t))
  }

  /** Gets a data flow node referring to this regular expression. */
  cached
  DataFlow::SourceNode getAReference() {
    Stages::FlowSteps::ref() and
    result = this.getAReference(DataFlow::TypeTracker::end())
  }
}

/**
 * A guard node for a variable in a negative condition, such as `x` in `if(!x)`.
 * Can be added to a `isBarrier` in a data-flow configuration to block flow through such checks.
 */
class VarAccessBarrier extends DataFlow::Node {
  VarAccessBarrier() {
    exists(ConditionGuardNode guard, SsaRefinementNode refinement |
      this = DataFlow::ssaDefinitionNode(refinement) and
      refinement.getGuard() = guard and
      guard.getTest() instanceof VarAccess and
      guard.getOutcome() = false
    )
  }
}

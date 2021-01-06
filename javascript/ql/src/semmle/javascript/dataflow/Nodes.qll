/**
 * Provides classes representing particular kinds of data flow nodes, such
 * as nodes corresponding to function definitions or nodes corresponding to
 * parameters.
 */

private import javascript
private import semmle.javascript.dependencies.Dependencies
private import internal.CallGraphs

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
class InvokeNode extends DataFlow::SourceNode {
  DataFlow::Impl::InvokeNodeDef impl;

  InvokeNode() { this = impl }

  /** Gets the syntactic invoke expression underlying this function invocation. */
  InvokeExpr getInvokeExpr() { result = impl.getInvokeExpr() }

  /** Gets the name of the function or method being invoked, if it can be determined. */
  string getCalleeName() { result = impl.getCalleeName() }

  /** Gets the data flow node specifying the function to be called. */
  DataFlow::Node getCalleeNode() { result = impl.getCalleeNode() }

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
  DataFlow::Node getArgument(int i) { result = impl.getArgument(i) }

  /** Gets the data flow node corresponding to an argument of this invocation. */
  DataFlow::Node getAnArgument() { result = impl.getAnArgument() }

  /** Gets the data flow node corresponding to the last argument of this invocation. */
  DataFlow::Node getLastArgument() { result = getArgument(getNumArgument() - 1) }

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
  DataFlow::Node getASpreadArgument() { result = impl.getASpreadArgument() }

  /** Gets the number of arguments of this invocation, if it can be determined. */
  int getNumArgument() { result = impl.getNumArgument() }

  Function getEnclosingFunction() { result = getBasicBlock().getContainer() }

  /**
   * Gets a function passed as the `i`th argument of this invocation.
   *
   * This predicate only performs local data flow tracking.
   * Consider using `getABoundCallbackParameter` to handle interprocedural flow of callback functions.
   */
  FunctionNode getCallback(int i) { result.flowsTo(getArgument(i)) }

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
        getArgument(callback).getABoundFunctionValue(boundArgs).getParameter(param + boundArgs)
    )
  }

  /**
   * Holds if the `i`th argument of this invocation is an object literal whose property
   * `name` is set to `result`.
   */
  pragma[nomagic]
  DataFlow::ValueNode getOptionArgument(int i, string name) {
    getOptionsArgument(i).hasPropertyWrite(name, result)
  }

  pragma[noinline]
  private ObjectLiteralNode getOptionsArgument(int i) { result.flowsTo(getArgument(i)) }

  /** Gets an abstract value representing possible callees of this call site. */
  final AbstractValue getACalleeValue() { result = getCalleeNode().analyze().getAValue() }

  /**
   * Gets a potential callee of this call site.
   *
   * To alter the call graph as seen by the interprocedural data flow libraries, override
   * the `getACallee(int imprecision)` predicate instead.
   */
  final Function getACallee() { result = getACallee(0) }

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
  predicate isIndefinite(DataFlow::Incompleteness cause) { getACalleeValue().isIndefinite(cause) }

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
    isIndefinite("global") and
    exists(DefiniteAbstractValue v | v = getACalleeValue() | not v instanceof AbstractCallable)
  }

  /**
   * Holds if our approximation of possible callees for this call site is
   * likely to be incomplete.
   */
  predicate isIncomplete() {
    // the flow analysis identifies a source of incompleteness other than
    // global flow (which usually leads to imprecision rather than incompleteness)
    any(DataFlow::Incompleteness cause | isIndefinite(cause)) != "global"
  }

  /**
   * Holds if our approximation of possible callees for this call site is
   * likely to be imprecise or incomplete.
   */
  predicate isUncertain() { isImprecise() or isIncomplete() }

  /**
   * Gets the data flow node representing an exception thrown from this invocation.
   */
  DataFlow::ExceptionalInvocationReturnNode getExceptionalReturn() {
    DataFlow::exceptionalInvocationReturnNode(result, asExpr())
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
class CallNode extends InvokeNode {
  override DataFlow::Impl::CallNodeDef impl;

  /**
   * Gets the data flow node corresponding to the receiver expression of this method call.
   *
   * For example, the receiver of `x.m()` is `x`.
   */
  DataFlow::Node getReceiver() { result = impl.getReceiver() }
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
class MethodCallNode extends CallNode {
  override DataFlow::Impl::MethodCallNodeDef impl;

  /** Gets the name of the invoked method, if it can be determined. */
  string getMethodName() { result = impl.getMethodName() }

  /**
   * Holds if this data flow node calls method `methodName` on receiver node `receiver`.
   */
  predicate calls(DataFlow::Node receiver, string methodName) {
    receiver = getReceiver() and
    methodName = getMethodName()
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
class NewNode extends InvokeNode {
  override DataFlow::Impl::NewNodeDef impl;
}

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
    not sc instanceof Function
  )
  or
  // DOM
  result = globalVarRef("window")
  or
  // Node.js
  result = globalVarRef("global")
  or
  // DOM and service workers
  result = globalVarRef("self")
  or
  // ECMAScript 2020
  result = globalVarRef("globalThis")
  or
  // `require("global")`
  result = moduleImport("global")
  or
  // Closure library - based on AST to avoid recursion with Closure library model
  result = globalVarRef("goog").getAPropertyRead("global")
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
  result.(GlobalVarRefNode).getName() = name
  or
  result = globalObjectRef().getAPropertyReference(name)
  or
  // `require("global/document")` or `require("global/window")`
  (name = "document" or name = "window") and
  result = moduleImport("global/" + name)
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
  ParameterNode getAParameter() { result = getParameter(_) }

  /** Gets the number of parameters declared on this function. */
  int getNumParameter() { result = count(astNode.getAParameter()) }

  /** Gets the last parameter of this function. */
  ParameterNode getLastParameter() { result = getParameter(getNumParameter() - 1) }

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
  FunctionNode getThisBinder() { result.getFunction() = getFunction().getThisBinder() }

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
  ArrayConstructorInvokeNode() { getCalleeNode() = DataFlow::globalVarRef("Array") }

  /** Gets the `i`th initial element of this array, if one is provided. */
  DataFlow::ValueNode getElement(int i) {
    getNumArgument() > 1 and // A single-argument invocation specifies the array length, not an element.
    result = getArgument(i)
  }

  /** Gets an initial element of this array, if one is provided. */
  DataFlow::ValueNode getAnElement() {
    getNumArgument() > 1 and
    result = getAnArgument()
  }

  /** Gets the initial size of the created array, if it can be determined. */
  int getSize() {
    if getNumArgument() = 1
    then result = getArgument(0).getIntValue()
    else result = count(getAnElement())
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
  DataFlow::ValueNode getAnElement() { result = getElement(_) }

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
    exists(SpreadElement arg | arg = getAnElement().getEnclosingExpr() |
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
class ModuleImportNode extends DataFlow::SourceNode {
  ModuleImportNode::Range range;

  ModuleImportNode() { this = range }

  /** Gets the path of the imported module. */
  string getPath() { result = range.getPath() }
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
ModuleImportNode moduleImport(string path) { result.getPath() = path }

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

module MemberKind {
  /** The kind of a method, such as `m() {}` */
  MemberKind method() { result = "method" }

  /** The kind of a getter accessor, such as `get f() {}`. */
  MemberKind getter() { result = "getter" }

  /** The kind of a setter accessor, such as `set f() {}`. */
  MemberKind setter() { result = "setter" }

  /** The `getter` and `setter` kinds. */
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
class ClassNode extends DataFlow::SourceNode {
  ClassNode::Range impl;

  ClassNode() { this = impl }

  /**
   * Gets the unqualified name of the class, if it has one or one can be determined from the context.
   */
  string getName() { result = impl.getName() }

  /**
   * Gets a description of the class.
   */
  string describe() { result = impl.describe() }

  /**
   * Gets the constructor function of this class.
   */
  FunctionNode getConstructor() { result = impl.getConstructor() }

  /**
   * Gets an instance method declared in this class, with the given name, if any.
   *
   * Does not include methods from superclasses.
   */
  FunctionNode getInstanceMethod(string name) {
    result = impl.getInstanceMember(name, MemberKind::method())
  }

  /**
   * Gets an instance method declared in this class.
   *
   * The constructor is not considered an instance method.
   *
   * Does not include methods from superclasses.
   */
  FunctionNode getAnInstanceMethod() { result = impl.getAnInstanceMember(MemberKind::method()) }

  /**
   * Gets the instance method, getter, or setter with the given name and kind.
   *
   * Does not include members from superclasses.
   */
  FunctionNode getInstanceMember(string name, MemberKind kind) {
    result = impl.getInstanceMember(name, kind)
  }

  /**
   * Gets an instance method, getter, or setter with the given kind.
   *
   * Does not include members from superclasses.
   */
  FunctionNode getAnInstanceMember(MemberKind kind) { result = impl.getAnInstanceMember(kind) }

  /**
   * Gets an instance method, getter, or setter declared in this class.
   *
   * Does not include members from superclasses.
   */
  FunctionNode getAnInstanceMember() { result = impl.getAnInstanceMember(_) }

  /**
   * Gets the static method declared in this class with the given name.
   */
  FunctionNode getStaticMethod(string name) { result = impl.getStaticMethod(name) }

  /**
   * Gets a static method declared in this class.
   *
   * The constructor is not considered a static method.
   */
  FunctionNode getAStaticMethod() { result = impl.getAStaticMethod() }

  /**
   * Gets a dataflow node that refers to the superclass of this class.
   */
  DataFlow::Node getASuperClassNode() { result = impl.getASuperClassNode() }

  /**
   * Gets a direct super class of this class.
   *
   * This predicate can be overridden to customize the class hierarchy.
   */
  ClassNode getADirectSuperClass() { result.getAClassReference().flowsTo(getASuperClassNode()) }

  /**
   * Gets a direct subclass of this class.
   */
  final ClassNode getADirectSubClass() { this = result.getADirectSuperClass() }

  /**
   * Gets the receiver of an instance member or constructor of this class.
   */
  DataFlow::SourceNode getAReceiverNode() {
    result = getConstructor().getReceiver()
    or
    result = getAnInstanceMember().getReceiver()
  }

  /**
   * Gets the abstract value representing the class itself.
   */
  AbstractValue getAbstractClassValue() { result = this.(AnalyzedNode).getAValue() }

  /**
   * Gets the abstract value representing an instance of this class.
   */
  AbstractValue getAbstractInstanceValue() { result = AbstractInstance::of(getAstNode()) }

  /**
   * Gets a dataflow node that refers to this class object.
   *
   * This predicate can be overridden to customize the tracking of class objects.
   */
  DataFlow::SourceNode getAClassReference(DataFlow::TypeTracker t) {
    t.start() and
    result.(AnalyzedNode).getAValue() = getAbstractClassValue() and
    (
      not CallGraph::isIndefiniteGlobal(result)
      or
      result.getAstNode().getFile() = this.getAstNode().getFile()
    )
    or
    exists(DataFlow::TypeTracker t2 | result = getAClassReference(t2).track(t2, t))
  }

  /**
   * Gets a dataflow node that refers to this class object.
   */
  cached
  final DataFlow::SourceNode getAClassReference() {
    result = getAClassReference(DataFlow::TypeTracker::end())
  }

  /**
   * Gets a dataflow node that refers to an instance of this class.
   *
   * This predicate can be overridden to customize the tracking of class instances.
   */
  DataFlow::SourceNode getAnInstanceReference(DataFlow::TypeTracker t) {
    result = getAClassReference(t.continue()).getAnInstantiation()
    or
    t.start() and
    result.(AnalyzedNode).getAValue() = getAbstractInstanceValue() and
    not result = any(DataFlow::ClassNode cls).getAReceiverNode()
    or
    t.start() and
    result = getAReceiverNode()
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
    result = getAnInstanceReferenceAux(t) and
    // Avoid tracking into the receiver of other classes.
    // Note that this also blocks flows into a property of the receiver,
    // but the `localFieldStep` rule will often compensate for this.
    not result = any(DataFlow::ClassNode cls).getAReceiverNode()
  }

  pragma[noinline]
  private DataFlow::SourceNode getAnInstanceReferenceAux(DataFlow::TypeTracker t) {
    exists(DataFlow::TypeTracker t2 | result = getAnInstanceReference(t2).track(t2, t))
  }

  /**
   * Gets a dataflow node that refers to an instance of this class.
   */
  cached
  final DataFlow::SourceNode getAnInstanceReference() {
    result = getAnInstanceReference(DataFlow::TypeTracker::end())
  }

  /**
   * Gets an access to a static member of this class.
   */
  DataFlow::PropRead getAStaticMemberAccess(string name) {
    result = getAClassReference().getAPropertyRead(name)
  }

  /**
   * Holds if this class is exposed in the global scope through the given qualified name.
   */
  pragma[noinline]
  predicate hasQualifiedName(string name) {
    getAClassReference().flowsTo(AccessPath::getAnAssignmentTo(name))
  }

  /**
   * Gets the type annotation for the field `fieldName`, if any.
   */
  TypeAnnotation getFieldTypeAnnotation(string fieldName) {
    result = impl.getFieldTypeAnnotation(fieldName)
  }
}

module ClassNode {
  /**
   * A dataflow node that should be considered a class node.
   *
   * Subclass this to introduce new kinds of class nodes. If you want to refine
   * the definition of existing class nodes, subclass `DataFlow::ClassNode` instead.
   */
  abstract class Range extends DataFlow::SourceNode {
    /**
     * Gets the name of the class, if it has one.
     */
    abstract string getName();

    /**
     * Gets a description of the class.
     */
    abstract string describe();

    /**
     * Gets the constructor function of this class.
     */
    abstract FunctionNode getConstructor();

    /**
     * Gets the instance member with the given name and kind.
     */
    abstract FunctionNode getInstanceMember(string name, MemberKind kind);

    /**
     * Gets an instance member with the given kind.
     */
    abstract FunctionNode getAnInstanceMember(MemberKind kind);

    /**
     * Gets the static method of this class with the given name.
     */
    abstract FunctionNode getStaticMethod(string name);

    /**
     * Gets a static method of this class.
     *
     * The constructor is not considered a static method.
     */
    abstract FunctionNode getAStaticMethod();

    /**
     * Gets a dataflow node representing a class to be used as the super-class
     * of this node.
     */
    abstract DataFlow::Node getASuperClassNode();

    /**
     * Gets the type annotation for the field `fieldName`, if any.
     */
    TypeAnnotation getFieldTypeAnnotation(string fieldName) { none() }
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
      result = getConstructor().getReceiver().getAPropertySource(name)
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
      result = getConstructor().getReceiver().getAPropertySource()
    }

    override FunctionNode getStaticMethod(string name) {
      exists(MethodDeclaration method |
        method = astNode.getMethod(name) and
        method.isStatic() and
        result = method.getBody().flow()
      )
      or
      result = getAPropertySource(name)
    }

    override FunctionNode getAStaticMethod() {
      exists(MethodDeclaration method |
        method = astNode.getAMethod() and
        method.isStatic() and
        result = method.getBody().flow()
      )
      or
      result = getAPropertySource()
    }

    override DataFlow::Node getASuperClassNode() { result = astNode.getSuperClass().flow() }

    override TypeAnnotation getFieldTypeAnnotation(string fieldName) {
      exists(FieldDeclaration field |
        field.getDeclaringClass() = astNode and
        fieldName = field.getName() and
        result = field.getTypeAnnotation()
      )
    }
  }

  private DataFlow::PropRef getAPrototypeReferenceInFile(string name, File f) {
    result.getBase() = AccessPath::getAReferenceOrAssignmentTo(name) and
    result.getPropertyName() = "prototype" and
    result.getFile() = f
  }

  /**
   * A function definition with prototype manipulation as a `ClassNode` instance.
   */
  class FunctionStyleClass extends Range, DataFlow::ValueNode {
    override Function astNode;
    AbstractFunction function;

    FunctionStyleClass() {
      function.getFunction() = astNode and
      (
        exists(DataFlow::PropRef read |
          read.getPropertyName() = "prototype" and
          read.getBase().analyze().getAValue() = function
        )
        or
        exists(string name |
          this = AccessPath::getAnAssignmentTo(name) and
          exists(getAPrototypeReferenceInFile(name, getFile()))
        )
      )
    }

    override string getName() { result = astNode.getName() }

    override string describe() { result = astNode.describe() }

    override FunctionNode getConstructor() { result = this }

    private PropertyAccessor getAnAccessor(MemberKind kind) {
      result.getObjectExpr() = getAPrototypeReference().asExpr() and
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
      result = getAPrototypeReference().getAPropertySource(name)
      or
      kind = MemberKind::method() and
      result = getConstructor().getReceiver().getAPropertySource(name)
      or
      exists(PropertyAccessor accessor |
        accessor = getAnAccessor(kind) and
        accessor.getName() = name and
        result = accessor.getInit().flow()
      )
    }

    override FunctionNode getAnInstanceMember(MemberKind kind) {
      kind = MemberKind::method() and
      result = getAPrototypeReference().getAPropertySource()
      or
      kind = MemberKind::method() and
      result = getConstructor().getReceiver().getAPropertySource()
      or
      exists(PropertyAccessor accessor |
        accessor = getAnAccessor(kind) and
        result = accessor.getInit().flow()
      )
    }

    override FunctionNode getStaticMethod(string name) { result = getAPropertySource(name) }

    override FunctionNode getAStaticMethod() { result = getAPropertySource() }

    /**
     * Gets a reference to the prototype of this class.
     */
    DataFlow::SourceNode getAPrototypeReference() {
      exists(DataFlow::SourceNode base | base.analyze().getAValue() = function |
        result = base.getAPropertyRead("prototype")
        or
        result = base.getAPropertySource("prototype")
      )
      or
      exists(string name |
        this = AccessPath::getAnAssignmentTo(name) and
        result = getAPrototypeReferenceInFile(name, getFile())
      )
      or
      exists(ExtendCall call |
        call.getDestinationOperand() = getAPrototypeReference() and
        result = call.getASourceOperand()
      )
    }

    override DataFlow::Node getASuperClassNode() {
      // C.prototype = Object.create(D.prototype)
      exists(DataFlow::InvokeNode objectCreate, DataFlow::PropRead superProto |
        getAPropertySource("prototype") = objectCreate and
        objectCreate = DataFlow::globalVarRef("Object").getAMemberCall("create") and
        superProto.flowsTo(objectCreate.getArgument(0)) and
        superProto.getPropertyName() = "prototype" and
        result = superProto.getBase()
      )
      or
      // C.prototype = new D()
      exists(DataFlow::NewNode newCall |
        getAPropertySource("prototype") = newCall and
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
class PartialInvokeNode extends DataFlow::Node {
  PartialInvokeNode::Range range;

  PartialInvokeNode() { this = range }

  /** Gets a node holding a callback invoked by this partial invocation node. */
  DataFlow::Node getACallbackNode() {
    isPartialArgument(result, _, _)
    or
    exists(getBoundReceiver(result))
  }

  /**
   * Holds if `argument` is passed as argument `index` to the function in `callback`.
   */
  predicate isPartialArgument(DataFlow::Node callback, DataFlow::Node argument, int index) {
    range.isPartialArgument(callback, argument, index)
  }

  /**
   * Gets a node referring to a bound version of `callback` with `boundArgs` arguments bound.
   */
  DataFlow::SourceNode getBoundFunction(DataFlow::Node callback, int boundArgs) {
    result = range.getBoundFunction(callback, boundArgs)
  }

  /**
   * Gets the node holding the receiver to be passed to the bound function, if specified.
   */
  DataFlow::Node getBoundReceiver() { result = range.getBoundReceiver(_) }

  /**
   * Gets the node holding the receiver to be passed to the bound function, if specified.
   */
  DataFlow::Node getBoundReceiver(DataFlow::Node callback) {
    result = range.getBoundReceiver(callback)
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
     * DEPRECATED. Use the one-argument version of `getBoundReceiver` instead.
     *
     * Gets the node holding the receiver to be passed to the bound function, if specified.
     */
    deprecated DataFlow::Node getBoundReceiver() { none() }

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
      getMethodName() = "bind" and
      // Avoid overlap with angular.bind and goog.bind
      not this = AngularJS::angular().getAMethodCall() and
      not getReceiver().accessesGlobal("goog")
    }

    override predicate isPartialArgument(DataFlow::Node callback, DataFlow::Node argument, int index) {
      index >= 0 and
      callback = getReceiver() and
      argument = getArgument(index + 1)
    }

    override DataFlow::SourceNode getBoundFunction(DataFlow::Node callback, int boundArgs) {
      callback = getReceiver() and
      boundArgs = getNumArgument() - 1 and
      result = this
    }

    override DataFlow::Node getBoundReceiver(DataFlow::Node callback) {
      callback = getReceiver() and
      result = getArgument(0)
    }
  }

  /**
   * A partial call through `_.partial`.
   */
  private class LodashPartialCall extends PartialInvokeNode::Range, DataFlow::CallNode {
    LodashPartialCall() { this = LodashUnderscore::member("partial").getACall() }

    override predicate isPartialArgument(DataFlow::Node callback, DataFlow::Node argument, int index) {
      index >= 0 and
      callback = getArgument(0) and
      argument = getArgument(index + 1)
    }

    override DataFlow::SourceNode getBoundFunction(DataFlow::Node callback, int boundArgs) {
      callback = getArgument(0) and
      boundArgs = getNumArgument() - 1 and
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
        callback = getArgument(callbackIndex)
        or
        callbackIndex = -1 and
        callback = getLastArgument()
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

    private DataFlow::ArrayCreationNode getArgumentsArray() { result.flowsTo(getArgument(1)) }

    override predicate isPartialArgument(DataFlow::Node callback, DataFlow::Node argument, int index) {
      callback = getArgument(0) and
      argument = getArgumentsArray().getElement(index)
    }

    override DataFlow::SourceNode getBoundFunction(DataFlow::Node callback, int boundArgs) {
      callback = getArgument(0) and
      boundArgs = getArgumentsArray().getSize() and
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
      callback = getArgument(1) and
      result = getArgument(2)
    }
  }
}

/**
 * DEPRECATED. Subclasses should extend `PartialInvokeNode::Range` instead,
 * and predicates should use `PartialInvokeNode` instead.
 *
 * An invocation that is modeled as a partial function application.
 *
 * This contributes additional argument-passing flow edges that should be added to all data flow configurations.
 */
deprecated class AdditionalPartialInvokeNode = PartialInvokeNode::Range;

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
  RegExpTerm getRoot() { result = getArgument(0).asExpr().(StringLiteral).asRegExp() }

  /**
   * Gets the flags provided in the second argument, or an empty string if no
   * flags are provided.
   *
   * Has no result if the flags are provided but are not constant.
   */
  string getFlags() {
    result = getArgument(1).getStringValue()
    or
    not exists(getArgument(1)) and
    result = ""
  }

  /**
   * Gets the flags provided in the second argument, or an empty string if no
   * flags are provided, or the string `"?"` if the provided flags are not known.
   */
  string tryGetFlags() {
    result = getFlags()
    or
    not exists(getFlags()) and
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

  /** Gets a data flow node referring to this regular expression. */
  private DataFlow::SourceNode getAReference(DataFlow::TypeTracker t) {
    t.start() and
    result = this
    or
    exists(DataFlow::TypeTracker t2 | result = getAReference(t2).track(t2, t))
  }

  /** Gets a data flow node referring to this regular expression. */
  DataFlow::SourceNode getAReference() { result = getAReference(DataFlow::TypeTracker::end()) }
}

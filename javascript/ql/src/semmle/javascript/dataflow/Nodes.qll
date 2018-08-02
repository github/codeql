/**
 * Provides classes representing particular kinds of data flow nodes, such
 * as nodes corresponding to function definitions or nodes corresponding to
 * parameters.
 */

import javascript

/** A data flow node corresponding to a parameter. */
class ParameterNode extends DataFlow::DefaultSourceNode {
  Parameter p;

  ParameterNode() { DataFlow::parameterNode(this, p) }

  /** Gets the parameter to which this data flow node corresponds. */
  Parameter getParameter() { result = p }

  /** Gets the name of this parameter. */
  string getName() { result = p.getName() }
}

/** A data flow node corresponding to a function invocation (with or without `new`). */
class InvokeNode extends DataFlow::ValueNode, DataFlow::DefaultSourceNode {
  override InvokeExpr astNode;

  /** Gets the name of the function or method being invoked, if it can be determined. */
  string getCalleeName() {
    result = astNode.getCalleeName()
  }

  /** Gets the data flow node specifying the function to be called. */
  DataFlow::ValueNode getCallee() {
    result = DataFlow::valueNode(astNode.getCallee())
  }

  /** Gets the data flow node corresponding to the `i`th argument of this invocation. */
  DataFlow::ValueNode getArgument(int i) {
    result = DataFlow::valueNode(astNode.getArgument(i))
  }

  /** Gets the data flow node corresponding to an argument of this invocation. */
  DataFlow::ValueNode getAnArgument() {
    result = getArgument(_)
  }

  /** Gets the number of arguments of this invocation. */
  int getNumArgument() {
    result = astNode.getNumArgument()
  }

  /** Gets a function passed as the `i`th argument of this invocation. */
  FunctionNode getCallback(int i) {
    result.flowsTo(getArgument(i))
  }

  /**
   * Holds if the `i`th argument of this invocation is an object literal whose property
   * `name` is set to `result`.
   */
  DataFlow::ValueNode getOptionArgument(int i, string name) {
    exists (ObjectLiteralNode obj |
      obj.flowsTo(getArgument(i)) and
      obj.hasPropertyWrite(name, result)
    )
  }
}

/** A data flow node corresponding to a function call without `new`. */
class CallNode extends InvokeNode {
  override CallExpr astNode;
}

/** A data flow node corresponding to a method call. */
class MethodCallNode extends CallNode {
  override MethodCallExpr astNode;

  /**
   * Gets the data flow node corresponding to the receiver expression of this method call.
   *
   * For example, the receiver of `x.m()` is `x`.
   */
  DataFlow::Node getReceiver() {
    result = DataFlow::valueNode(astNode.getReceiver())
  }

  /** Gets the name of the invoked method, if it can be determined. */
  string getMethodName() { result = astNode.getMethodName() }

  /**
   * Holds if this data flow node calls method `methodName` on receiver node `receiver`.
   */
  predicate calls(DataFlow::Node receiver, string methodName) {
    receiver = getReceiver() and
    methodName = getMethodName()
  }

}

/** A data flow node corresponding to a `new` expression. */
class NewNode extends InvokeNode {
  override NewExpr astNode;
}

/** A data flow node corresponding to a `this` expression. */
class ThisNode extends DataFlow::ValueNode, DataFlow::DefaultSourceNode {
  override ThisExpr astNode;

  /**
   * Gets the function whose `this` binding this expression refers to,
   * which is the nearest enclosing non-arrow function.
   */
  FunctionNode getBinder() {
    result = DataFlow::valueNode(astNode.getBinder())
  }
}

/** A data flow node corresponding to a global variable access. */
class GlobalVarRefNode extends DataFlow::ValueNode, DataFlow::DefaultSourceNode {
  override GlobalVarAccess astNode;

  /** Gets the name of the global variable. */
  string getName() { result = astNode.getName() }
}

/**
 * Gets a data flow node corresponding to an access to global variable `name`,
 * either directly or through `window` or `global`.
 */
pragma[nomagic]
DataFlow::SourceNode globalVarRef(string name) {
  result.(GlobalVarRefNode).getName() = name or
  // DOM environment
  result = globalVarRef("window").getAPropertyReference(name) or
  // Node.js environment
  result = globalVarRef("global").getAPropertyReference(name)
}

/** A data flow node corresponding to a function definition. */
class FunctionNode extends DataFlow::ValueNode, DataFlow::DefaultSourceNode {
  override Function astNode;

  /** Gets the `i`th parameter of this function. */
  ParameterNode getParameter(int i) {
    result = DataFlow::parameterNode(astNode.getParameter(i))
  }

  /** Gets a parameter of this function. */
  ParameterNode getAParameter() {
    result = getParameter(_)
  }

  /** Gets the name of this function, if it has one. */
  string getName() { result = astNode.getName() }

  /** Gets a data flow node corresponding to a return value of this function. */
  DataFlow::Node getAReturn() {
    result = astNode.getAReturnedExpr().flow()
  }

  /**
   * Gets the function this node corresponds to.
   */
  Function getFunction() {
    result = astNode
  }
}

/** A data flow node corresponding to an object literal expression. */
class ObjectLiteralNode extends DataFlow::ValueNode, DataFlow::DefaultSourceNode {
  override ObjectExpr astNode;
}

/** A data flow node corresponding to an array literal expression. */
class ArrayLiteralNode extends DataFlow::ValueNode, DataFlow::DefaultSourceNode {
  override ArrayExpr astNode;

  /** Gets the `i`th element of this array literal. */
  DataFlow::ValueNode getElement(int i) {
    result = DataFlow::valueNode(astNode.getElement(i))
  }

  /** Gets an element of this array literal. */
  DataFlow::ValueNode getAnElement() {
    result = DataFlow::valueNode(astNode.getAnElement())
  }

}

/**
 * A data flow node corresponding to a `default` import from a module, or a
 * (AMD or CommonJS) `require` of a module.
 *
 * For compatibility with old transpilers, we treat `import * from '...'`
 * as a default import as well.
 */
class ModuleImportNode extends DataFlow::DefaultSourceNode {
  string path;

  ModuleImportNode() {
    // `require("http")`
    exists (Require req | req.getImportedPath().getValue() = path |
      this = DataFlow::valueNode(req)
    )
    or
    // `import http = require("http")`
    exists (ExternalModuleReference req | req.getImportedPath().getValue() = path |
      this = DataFlow::valueNode(req)
    )
    or
    // `import * as http from 'http'` or `import http from `http`'
    exists (ImportDeclaration id, ImportSpecifier is, SsaExplicitDefinition ssa |
      id.getImportedPath().getValue() = path and
      is = id.getASpecifier() and
      ssa.getDef() = is and
      this = DataFlow::ssaDefinitionNode(ssa) |
      is instanceof ImportNamespaceSpecifier and
      count(id.getASpecifier()) = 1
      or
      is.getImportedName() = "default"
    )
    or
    // declared AMD dependency
    exists (AMDModuleDefinition amd, PathExpr dep, Parameter p |
      amd.dependencyParameter(dep, p) and
      path = dep.getValue() and
      this = DataFlow::parameterNode(p)
    )
    or
    // AMD require
    exists (AMDModuleDefinition amd, CallExpr req |
      req = amd.getARequireCall() and
      this = DataFlow::valueNode(req) and
      path = req.getArgument(0).(ConstantString).getStringValue()
    )
  }

  /** Gets the path of the imported module. */
  string getPath() {
    result = path
  }
}

/**
 * Gets a (default) import of the module with the given path.
 */
ModuleImportNode moduleImport(string path) {
  result.getPath() = path
}

/**
 * Gets a data flow node that either imports `m` from the module with
 * the given `path`, or accesses `m` as a member on a default or
 * namespace import from `path`.
 */
DataFlow::SourceNode moduleMember(string path, string m) {
  result = moduleImport(path).getAPropertyRead(m)
  or
  exists (ImportDeclaration id, ImportSpecifier is, SsaExplicitDefinition ssa |
    id.getImportedPath().getValue() = path and
    is = id.getASpecifier() and
    is.getImportedName() = m and
    ssa.getDef() = is and
    result = DataFlow::ssaDefinitionNode(ssa)
  )
}

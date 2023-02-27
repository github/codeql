/**
 * EXPERIMENTAL. This API may change in the future.
 *
 * Provides predicates for working with values exported from a package.
 */

import javascript
private import semmle.javascript.internal.CachedStages

/**
 * Gets a parameter that is a library input to a top-level package.
 */
cached
DataFlow::Node getALibraryInputParameter() {
  Stages::Taint::ref() and
  exists(int bound, DataFlow::FunctionNode func |
    func = getAValueExportedByPackage().getABoundFunctionValue(bound)
  |
    result = func.getParameter(any(int arg | arg >= bound))
    or
    result = func.getFunction().getArgumentsVariable().getAnAccess().flow()
  )
}

private import NodeModuleResolutionImpl as NodeModule

/**
 * Gets a value exported by the main module from a named `package.json` file.
 */
private DataFlow::Node getAValueExportedByPackage() {
  // The base case, an export from a named `package.json` file.
  result =
    getAnExportFromModule(any(PackageJson pack | exists(pack.getPackageName())).getExportedModule(_))
  or
  // module.exports.bar.baz = result;
  exists(DataFlow::PropWrite write |
    write = getAValueExportedByPackage() and
    write.getPropertyName() = publicPropertyName() and
    result = write.getRhs()
  )
  or
  // class Foo {
  //   bar() {} // <- result
  // };
  // module.exports = new Foo();
  exists(DataFlow::SourceNode callee |
    callee = getAValueExportedByPackage().(DataFlow::NewNode).getCalleeNode().getALocalSource()
    or
    callee.(DataFlow::ClassNode).getConstructor() =
      getAValueExportedByPackage().(DataFlow::NewNode).getCalleeNode().getAFunctionValue()
  |
    result = callee.getAPropertyRead("prototype").getAPropertyWrite(publicPropertyName()).getRhs()
    or
    result = callee.(DataFlow::ClassNode).getInstanceMethod(publicPropertyName()) and
    not isPrivateMethodDeclaration(result)
  )
  or
  // module.exports.foo = function () {
  //   return new Foo(); // <- result
  // };
  exists(DataFlow::FunctionNode func, DataFlow::NewNode inst, DataFlow::ClassNode clz |
    func = getAValueExportedByPackage().getALocalSource() and inst = unique( | | func.getAReturn())
  |
    clz.getAnInstanceReference() = inst and
    result = clz.getAnInstanceMember(_)
  )
  or
  result = getAValueExportedByPackage().getALocalSource()
  or
  // Nested property reads.
  result =
    getAValueExportedByPackage().(DataFlow::SourceNode).getAPropertyReference(publicPropertyName())
  or
  // module.exports.foo = require("./other-module.js");
  exists(Module mod |
    mod = getAValueExportedByPackage().getEnclosingExpr().(Import).getImportedModule()
  |
    result = getAnExportFromModule(mod)
  )
  or
  // re-export of a value from another module
  // `module.exports.foo = require("./other").bar;`
  // other.js:
  // `module.exports.bar = function () { ... };`
  exists(DataFlow::PropRead read, Import imp |
    read = getAValueExportedByPackage() and
    read.getBase().getALocalSource() = imp.getImportedModuleNode() and
    result = imp.getImportedModule().getAnExportedValue(read.getPropertyName())
  )
  or
  // require("./other-module.js"); inside an AMD module.
  exists(Module mod, CallExpr call |
    call = getAValueExportedByPackage().asExpr() and
    call = any(AmdModuleDefinition e).getARequireCall() and
    mod = call.getAnArgument().(Import).getImportedModule()
  |
    result = getAnExportFromModule(mod)
  )
  or
  // module.exports = class Foo {
  //   bar() {} // <- result
  //   static baz() {} // <- result
  //   constructor() {} // <- result
  // };
  exists(DataFlow::ClassNode cla |
    cla = getAValueExportedByPackage() and
    not isPrivateMethodDeclaration(result)
  |
    result = cla.getInstanceMethod(publicPropertyName()) or
    result = cla.getStaticMethod(publicPropertyName()) or
    result = cla.getConstructor()
  )
  or
  // One shot closures that define a "factory" function.
  // Recognizes the following pattern:
  // ```Javascript
  // (function (root, factory) {
  //   if (typeof define === 'function' && define.amd) {
  //     define('library-name', factory);
  //   } else if (typeof exports === 'object') {
  //     module.exports = factory();
  //   } else {
  //     root.libraryName = factory();
  //   }
  // }(this, function () {
  //   ....
  // }));
  // ```
  // Such files are not recognized as modules, so we manually use `NodeModule::resolveMainModule` to resolve the file against a `package.json` file.
  exists(ImmediatelyInvokedFunctionExpr func, DataFlow::ParameterNode factory, int i |
    factory.getName() = "factory" and
    func.getParameter(i) = factory.getParameter() and
    DataFlow::globalVarRef("define").getACall().getAnArgument() = factory.getALocalUse() and
    func.getFile() =
      min(int j, File f |
        f =
          NodeModule::resolveMainModule(any(PackageJson pack | exists(pack.getPackageName())), j,
            ".")
      |
        f order by j
      )
  |
    result = func.getInvocation().getArgument(i).flow().getAFunctionValue().getAReturn()
    or
    exists(DataFlow::ParameterNode exports | exports.getName() = "exports" |
      exports = func.getInvocation().getAnArgument().flow().getAFunctionValue().getParameter(0) and
      result = exports.getAPropertyWrite().getRhs()
    )
  )
  or
  // the exported value is a call to a unique callee
  // ```JavaScript
  // module.exports = foo();
  // function foo() {
  //   return result;
  // }
  // ```
  exists(DataFlow::CallNode call | call = getAValueExportedByPackage() |
    result = unique( | | call.getCalleeNode().getAFunctionValue()).getAReturn()
  )
  or
  exists(DataFlow::FunctionNode func |
    func = getAValueExportedByPackage().getABoundFunctionValue(_)
  |
    // the exported value is a function that returns another import.
    // ```JavaScript
    // module.exports = function foo() {
    //   return require("./other-module.js");
    // }
    // ```
    exists(Module mod |
      mod = func.getAReturn().getALocalSource().getEnclosingExpr().(Import).getImportedModule() and
      result = getAnExportFromModule(mod)
    )
    or
    // a function that returns an object of methods. This acts a bit like a class.
    result = func.getAReturn().getALocalSource().getAPropertySource().(DataFlow::FunctionNode)
  )
  or
  // *****
  // Common styles of transforming exported objects.
  // *****
  //
  // Object.defineProperties
  exists(DataFlow::MethodCallNode call |
    call = DataFlow::globalVarRef("Object").getAMethodCall("defineProperties") and
    [call, call.getArgument(0)] = getAValueExportedByPackage() and
    result = call.getArgument(any(int i | i > 0))
  )
  or
  // Object.defineProperty
  exists(CallToObjectDefineProperty call |
    [call, call.getBaseObject()] = getAValueExportedByPackage() and
    call.getPropertyName() = publicPropertyName()
  |
    result = call.getPropertyDescriptor().getALocalSource().getAPropertyReference("value")
    or
    result =
      call.getPropertyDescriptor()
          .getALocalSource()
          .getAPropertyReference("get")
          .(DataFlow::FunctionNode)
          .getAReturn()
  )
  or
  // Object.assign and friends
  exists(ExtendCall assign |
    getAValueExportedByPackage() = [assign, assign.getDestinationOperand().getALocalSource()]
  |
    result = assign.getASourceOperand()
  )
  or
  // Array.prototype.{map, reduce, entries, values}
  exists(DataFlow::MethodCallNode map |
    map.getMethodName() = ["map", "reduce", "entries", "values"] and
    map = getAValueExportedByPackage()
  |
    result = map.getArgument(0).getABoundFunctionValue(_).getAReturn()
    or
    // assuming that the receiver of the call is somehow exported
    result = map.getReceiver()
  )
  or
  // Object.{fromEntries, freeze, seal, entries, values}
  exists(DataFlow::MethodCallNode freeze |
    freeze =
      DataFlow::globalVarRef("Object")
          .getAMethodCall(["fromEntries", "freeze", "seal", "entries", "values"])
  |
    freeze = getAValueExportedByPackage() and
    result = freeze.getArgument(0)
  )
}

/**
 * Gets an exported node from the module `mod`.
 */
private DataFlow::Node getAnExportFromModule(Module mod) {
  result = mod.getAnExportedValue(publicPropertyName())
  or
  result = mod.getABulkExportedNode()
  or
  // exports saved to the global object
  result = DataFlow::globalObjectRef().getAPropertyWrite().getRhs() and
  result.getTopLevel() = mod
  or
  result.analyze().getAValue() = TAbstractModuleObject(mod)
}

/**
 * Gets a property name that we consider to be public.
 *
 * This only allows properties whose first character is a letter or number.
 */
bindingset[result]
private string publicPropertyName() { result.regexpMatch("[a-zA-Z0-9].*") }

/**
 * Holds if the given function is part of a private (or protected) method declaration.
 */
private predicate isPrivateMethodDeclaration(DataFlow::FunctionNode func) {
  exists(MethodDeclaration decl |
    decl.getBody() = func.getFunction() and
    (
      decl.isPrivate()
      or
      decl.isProtected()
    )
  )
}

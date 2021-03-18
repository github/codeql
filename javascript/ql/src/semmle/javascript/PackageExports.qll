/**
 * EXPERIMENTAL. This API may change in the future.
 *
 * Provides predicates for working with values exported from a package.
 */

import javascript

/**
 * Gets a parameter that is a library input to a top-level package.
 */
DataFlow::ParameterNode getALibraryInputParameter() {
  exists(int bound, DataFlow::FunctionNode func |
    func = getAValueExportedByPackage().getABoundFunctionValue(bound) and
    result = func.getParameter(any(int arg | arg >= bound))
  )
}

/**
 * Gets a value exported by the main module from a named `package.json` file.
 * The value is either directly the `module.exports` value, a nested property of `module.exports`, or a method on an exported class.
 */
private DataFlow::Node getAValueExportedByPackage() {
  result =
    getAnExportFromModule(any(PackageJSON pack | exists(pack.getPackageName())).getMainModule())
  or
  result = getAValueExportedByPackage().(DataFlow::PropWrite).getRhs()
  or
  exists(DataFlow::SourceNode callee |
    callee = getAValueExportedByPackage().(DataFlow::NewNode).getCalleeNode().getALocalSource()
  |
    result = callee.getAPropertyRead("prototype").getAPropertyWrite().getRhs()
    or
    result = callee.(DataFlow::ClassNode).getAnInstanceMethod()
  )
  or
  result = getAValueExportedByPackage().getALocalSource()
  or
  result = getAValueExportedByPackage().(DataFlow::SourceNode).getAPropertyReference()
  or
  exists(Module mod |
    mod = getAValueExportedByPackage().getEnclosingExpr().(Import).getImportedModule()
  |
    result = getAnExportFromModule(mod)
  )
  or
  exists(DataFlow::ClassNode cla | cla = getAValueExportedByPackage() |
    result = cla.getAnInstanceMethod() or
    result = cla.getAStaticMethod() or
    result = cla.getConstructor()
  )
}

/**
 * Gets an exported node from the module `mod`.
 */
private DataFlow::Node getAnExportFromModule(Module mod) {
  result.analyze().getAValue() = mod.(NodeModule).getAModuleExportsValue()
  or
  result = mod.(Closure::ClosureModule).getExportsVariable().getAnAssignedExpr().flow()
  or
  result.analyze().getAValue() = mod.(AmdModule).getDefine().getAModuleExportsValue()
  or
  result = mod.getAnExportedValue(_)
}

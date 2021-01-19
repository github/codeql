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
 * Gets the number of occurrences of "/" in `path`.
 */
bindingset[path]
private int countSlashes(string path) { result = count(path.splitAt("/")) - 1 }

/**
 * Gets the topmost named package.json that appears in the project.
 *
 * There can be multiple results if the there exists multiple package.json that are equally deeply nested in the folder structure.
 * Results are limited to package.json files that are at most nested 2 directories deep.
 */
PackageJSON getTopmostPackageJSON() {
  result =
    min(PackageJSON j |
      countSlashes(j.getFile().getRelativePath()) <= 3 and
      exists(j.getPackageName())
    |
      j order by countSlashes(j.getFile().getRelativePath())
    )
}

/**
 * Gets a value exported by the main module from one of the topmost `package.json` files (see `getTopmostPackageJSON`).
 * The value is either directly the `module.exports` value, a nested property of `module.exports`, or a method on an exported class.
 */
private DataFlow::Node getAValueExportedByPackage() {
  result = getAnExportFromModule(getTopmostPackageJSON().getMainModule())
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
  result = mod.getAnExportedValue(_)
}

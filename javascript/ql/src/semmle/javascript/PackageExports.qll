/**
 * EXPERIMENTAL. This API may change in the future.
 *
 * Provides predicates for working with values exported from a package.
 */

import javascript

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
 * Gets a value exported by the main module from the package.json `packageJSON`.
 * The value is either directly the `module.exports` value, a nested property of `module.exports`, or a method on an exported class.
 */
DataFlow::Node getAValueExportedBy(PackageJSON packageJSON) {
  result = getAnExportFromModule(packageJSON.getMainModule())
  or
  result = getAValueExportedBy(packageJSON).(DataFlow::PropWrite).getRhs()
  or
  exists(DataFlow::SourceNode callee |
    callee = getAValueExportedBy(packageJSON).(DataFlow::NewNode).getCalleeNode().getALocalSource()
  |
    result = callee.getAPropertyRead("prototype").getAPropertyWrite().getRhs()
    or
    result = callee.(DataFlow::ClassNode).getAnInstanceMethod()
  )
  or
  result = getAValueExportedBy(packageJSON).getALocalSource()
  or
  result = getAValueExportedBy(packageJSON).(DataFlow::SourceNode).getAPropertyReference()
  or
  exists(Module mod |
    mod = getAValueExportedBy(packageJSON).getEnclosingExpr().(Import).getImportedModule()
  |
    result = getAnExportFromModule(mod)
  )
  or
  exists(DataFlow::ClassNode cla | cla = getAValueExportedBy(packageJSON) |
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
  result = getAnExportedValue(mod, _)
}

/**
 * Gets a value exported from `mod` under `name`.
 */
DataFlow::Node getAnExportedValue(Module mod, string name) {
  exists(Property export | result.asExpr() = export.getInit() | mod.exports(name, export))
  or
  result =
    DataFlow::valueNode(any(ASTNode export | mod.exports(name, export)))
        .(DataFlow::PropWrite)
        .getRhs()
  or
  exists(ExportDeclaration export |
    result = export.getSourceNode(name) and
    mod = export.getEnclosingModule()
  )
}

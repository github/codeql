import python
private import semmle.python.ApiGraphs
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.filters.Tests
private import semmle.python.frameworks.Django
private import semmle.python.frameworks.internal.AutomatedModeling

API::Node newOrExistingModeling(FindSubclassesSpec spec) {
  result = spec.getAlreadyModeledClass()
  or
  exists(string newSubclassName |
    newModel(spec, newSubclassName, _, _, _) and
    result.getPath() = fullyQualifiedToAPIGraphPath(newSubclassName)
  )
}

bindingset[fullyQualifiedName]
predicate alreadyModeled(FindSubclassesSpec spec, string fullyQualifiedName) {
  fullyQualifiedToAPIGraphPath(fullyQualifiedName) = spec.getAlreadyModeledClass().getPath()
  or
  automatedModeledClassData(spec.(string), fullyQualifiedName)
}

predicate isNonTestProjectCode(AstNode ast) {
  not ast.getScope*() instanceof TestScope and
  not ast.getLocation().getFile().getRelativePath().matches("tests/%") and
  exists(ast.getLocation().getFile().getRelativePath())
}

predicate hasAllStatement(Module mod) {
  exists(AssignStmt a, GlobalVariable all |
    a.defines(all) and
    a.getScope() = mod and
    all.getId() = "__all__"
  )
}

/**
 * Holds if `newAliasFullyQualified` describes new alias originating from the import
 * `from <module> import <member> [as <new-name>]`, where `<module>.<member>` belongs to
 * `spec`.
 * So if this import happened in module `foo.bar`, `newAliasFullyQualified` would be
 * `foo.bar.<member>` (or `foo.bar.<new-name>`).
 *
 * Note that this predicate currently respects `__all__` in sort of a backwards fashion.
 * - if `__all__` is defined in module `foo.bar`, we only allow new aliases where the member name is also in `__all__`. (this doesn't map 100% to the semantics of imports though)
 * - If `__all__` is not defined we don't impose any limitations.
 *
 * Also note that we don't currently consider deleting module-attributes at all, so in the code snippet below, we would consider that `my_module.foo` is a
 * reference to `django.foo`, although `my_module.foo` isn't even available at runtime. (there currently also isn't any code to discover that `my_module.bar`
 * is an alias to `django.foo`)
 * ```py
 * # module my_module
 * from django import foo
 * bar = foo
 * del foo
 * ```
 */
predicate newDirectAlias(
  FindSubclassesSpec spec, string newAliasFullyQualified, ImportMember importMember, Module mod,
  Location loc
) {
  importMember = newOrExistingModeling(spec).getAUse().asExpr() and
  importMember.getScope() = mod and
  loc = importMember.getLocation() and
  (
    mod.isPackageInit() and
    newAliasFullyQualified = mod.getPackageName() + "." + importMember.getName()
    or
    not mod.isPackageInit() and
    newAliasFullyQualified = mod.getName() + "." + importMember.getName()
  ) and
  (
    not hasAllStatement(mod)
    or
    mod.declaredInAll(importMember.getName())
  ) and
  not alreadyModeled(spec, newAliasFullyQualified) and
  isNonTestProjectCode(importMember)
}

/** same as `newDirectAlias` predicate, but handling `from <module> import *`, considering all `<member>`, where `<module>.<member>` belongs to `spec`. */
predicate newImportStar(
  FindSubclassesSpec spec, string newAliasFullyQualified, ImportStar importStar, Module mod,
  API::Node relevantClass, string relevantName, Location loc
) {
  relevantClass = newOrExistingModeling(spec) and
  loc = importStar.getLocation() and
  importStar.getScope() = mod and
  // WHAT A HACK :D :D
  relevantClass.getPath() =
    relevantClass.getAPredecessor().getPath() + ".getMember(\"" + relevantName + "\")" and
  relevantClass.getAPredecessor().getAUse().asExpr() = importStar.getModule() and
  (
    mod.isPackageInit() and
    newAliasFullyQualified = mod.getPackageName() + "." + relevantName
    or
    not mod.isPackageInit() and
    newAliasFullyQualified = mod.getName() + "." + relevantName
  ) and
  (
    not hasAllStatement(mod)
    or
    mod.declaredInAll(relevantName)
  ) and
  not alreadyModeled(spec, newAliasFullyQualified) and
  isNonTestProjectCode(importStar)
}

/** Holds if `classExpr` defines a new subclass that belongs to `spec`, which has the fully qualified name `newSubclassQualified`. */
predicate newSubclass(
  FindSubclassesSpec spec, string newSubclassQualified, ClassExpr classExpr, Module mod,
  Location loc
) {
  classExpr = newOrExistingModeling(spec).getASubclass*().getAUse().asExpr() and
  classExpr.getScope() = mod and
  newSubclassQualified = mod.getName() + "." + classExpr.getName() and
  loc = classExpr.getLocation() and
  not alreadyModeled(spec, newSubclassQualified) and
  isNonTestProjectCode(classExpr)
}

/**
 * Holds if `newModelFullyQualified` describes either a new subclass, or a new alias, belonging to `spec` that we should include in our automated modeling.
 * This new element is defined by `ast`, which is defined at `loc` in the module `mod`.
 */
query predicate newModel(
  FindSubclassesSpec spec, string newModelFullyQualified, AstNode ast, Module mod, Location loc
) {
  (
    newSubclass(spec, newModelFullyQualified, ast, mod, loc)
    or
    newDirectAlias(spec, newModelFullyQualified, ast, mod, loc)
    or
    newImportStar(spec, newModelFullyQualified, ast, mod, _, _, loc)
  )
}
// inherint problem with API graphs is that there doesn't need to exist a result for all
// the stuff we have already modeled... as an example, the following query has no
// results when evaluated against Django
//
// select API::moduleImport("django")
//       .getMember("contrib")
//       .getMember("admin")
//       .getMember("views")
//       .getMember("main")
//       .getMember("ChangeListSearchForm")

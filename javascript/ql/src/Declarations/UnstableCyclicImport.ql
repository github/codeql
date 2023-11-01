/**
 * @name Unstable cyclic import
 * @description If the top-level of a module accesses a variable from a cyclic import, its value depends on
 *              which module is globally imported first.
 * @kind problem
 * @problem.severity warning
 * @id js/unstable-cyclic-import
 * @tags maintainability
 * @precision low
 */

import javascript

/**
 * Holds if the contents of the given container are executed as part of the top-level code,
 * and it is unreachable after top-level execution.
 *
 * Some of this code might be conditionally executed, but the fact that it can only execute
 * as part of the top-level means cyclic imports can't be known to be resolved at this stage.
 */
predicate isImmediatelyExecutedContainer(StmtContainer container) {
  container instanceof TopLevel
  or
  // Namespaces are immediately executed (they cannot be declared inside a function).
  container instanceof NamespaceDeclaration
  or
  // IIFEs at the top-level are immediately executed
  exists(ImmediatelyInvokedFunctionExpr function | container = function |
    not function.isAsync() and
    not function.isGenerator() and
    isImmediatelyExecutedContainer(container.getEnclosingContainer())
  )
}

/**
 * Holds if the given import is only used to import type names, hence has no runtime effect.
 */
predicate isAmbientImport(ImportDeclaration decl) {
  decl.getFile().getFileType().isTypeScript() and
  exists(decl.getASpecifier()) and
  not exists(decl.getASpecifier().getLocal().getVariable().getAnAccess())
}

/**
 * Gets an import in `source` that imports `destination` at runtime.
 */
Import getARuntimeImport(Module source, Module destination) {
  result = source.getAnImport() and
  result.getImportedModule() = destination and
  not isAmbientImport(result)
}

predicate isImportedAtRuntime(Module source, Module destination) {
  exists(getARuntimeImport(source, destination))
}

/**
 * A variable access that is executed as part of the top-level and is not part of an export.
 *
 * Exported variables reference the variable itself, as opposed it its current value, so it is not
 * necessarily an error to export it before it has been initialized. Some runtimes and transpilers
 * do not support such name bindings yet, but they are safe according to the spec, so we do not report them.
 */
class CandidateVarAccess extends VarAccess {
  CandidateVarAccess() {
    isImmediatelyExecutedContainer(this.getContainer()) and
    not exists(ExportSpecifier spec | spec.getLocal() = this)
  }
}

/**
 * Gets the first candidate access to a variable imported by the given import declaration.
 *
 * We use this to avoid duplicate alerts about the same underlying cyclic import.
 */
VarAccess getFirstCandidateAccess(ImportDeclaration decl) {
  result =
    min(decl.getASpecifier().getLocal().getVariable().getAnAccess().(CandidateVarAccess) as p
      order by
        p.getLocation().getStartLine(), p.getLocation().getStartColumn()
    )
}

/**
 * This is the main alert definition.
 *
 * The predicate is used to restrict the path construction predicate to just those paths that
 * are relevant for the alerts we found.
 */
predicate cycleAlert(Module mod, ImportDeclaration import_, Module importedModule, VarAccess access) {
  import_ = mod.getAnImport() and
  access = getFirstCandidateAccess(import_) and
  importedModule = import_.getImportedModule() and
  importedModule != mod and // don't report self-imports
  // Suppress warning if this is the unique importer of that module.
  // That's a sufficient and somewhat maintainable safety guarantee.
  exists(Module otherEntry | isImportedAtRuntime(otherEntry, importedModule) and otherEntry != mod)
}

/** Holds if the length of the shortest sequence of runtime imports from `source` to `destination` is `steps`. */
predicate numberOfStepsToModule(Module source, Module destination, int steps) =
  shortestDistances(anyModule/1, isImportedAtRuntime/2)(source, destination, steps)

predicate anyModule(Module m) { any() }

/**
 * Gets the name of the module containing the given import.
 */
string repr(Import import_) { result = import_.getEnclosingModule().getName() }

/**
 * Builds a string visualizing the shortest import path from `source` to `destination`, excluding
 * the destination.
 *
 * For example, the path from `A` to `D` might be:
 * ```
 * A => B => C
 * ```
 * Notice that `D` is not mentioned in the output.
 *
 * The caller will then complete the cycle by putting `D` at the beginning and end:
 * ```
 * D => A => B => C => D
 * ```
 */
string pathToModule(Module source, Module destination, int steps) {
  // Restrict paths to those that are relevant for building a path from the imported module of an alert back to the importer.
  exists(Module m | cycleAlert(destination, _, m, _) and numberOfStepsToModule(m, source, _)) and
  numberOfStepsToModule(source, destination, steps) and
  (
    steps = 1 and
    result = repr(getARuntimeImport(source, destination))
    or
    steps > 1 and
    exists(Module next |
      // Only extend the path to one of the potential successors, as we only need one example.
      next =
        min(Module mod |
          isImportedAtRuntime(source, mod) and
          numberOfStepsToModule(mod, destination, steps - 1)
        |
          mod order by mod.getName()
        ) and
      result =
        repr(getARuntimeImport(source, next)) + " => " + pathToModule(next, destination, steps - 1)
    )
  )
}

from Module mod, ImportDeclaration import_, Module importedModule, VarAccess access
where cycleAlert(mod, import_, importedModule, access)
select access,
  access.getName() + " is uninitialized if $@ is loaded first in the cyclic import:" + " " +
    repr(import_) + " => " + min(pathToModule(importedModule, mod, _)) + " => " + repr(import_) +
    ".", import_.getImportedPath(), importedModule.getName()

/**
 * @name Unresolvable import
 * @description An import that cannot be resolved to a module will
 *              cause an exception at runtime.
 * @kind problem
 * @problem.severity warning
 * @id js/node/unresolvable-import
 * @tags maintainability
 *       frameworks/node.js
 * @precision low
 */

import javascript

/**
 * Gets the `package.json` of the nearest enclosing NPM package to which
 * file `f` belongs.
 */
PackageJson getClosestPackageJson(Folder f) {
  result = f.(NpmPackage).getPackageJson()
  or
  not f instanceof NpmPackage and result = getClosestPackageJson(f.getParentContainer())
}

from Require r, string path, string mod
where
  path = r.getImportedPath().getValue() and
  // the imported module is the initial segment of the path, up to
  // `/` or the end of the string, whichever comes first; we exclude
  // local paths starting with `.` or `/`, since they might refer to files
  // downloaded or generated during the build
  mod = path.regexpCapture("([^./][^/]*)(/.*|$)", 1) and
  // exclude WebPack/Require.js loaders
  not mod.matches("%!%") and
  // import cannot be resolved statically
  not exists(r.getImportedModule()) and
  // no enclosing NPM package declares a dependency on `mod`
  forex(NpmPackage pkg, PackageJson pkgJson |
    pkg.getAModule() = r.getTopLevel() and pkgJson = pkg.getPackageJson()
  |
    not pkgJson.declaresDependency(mod, _) and
    not pkgJson.getPeerDependencies().getADependency(mod, _) and
    // exclude packages depending on `fbjs`, which automatically pulls in many otherwise
    // undeclared dependencies
    not pkgJson.declaresDependency("fbjs", _)
  )
select r, "Module " + mod + " cannot be resolved, and is not declared as a dependency in $@.",
  getClosestPackageJson(r.getFile().getParentContainer()), "package.json"

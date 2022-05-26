import javascript
import semmle.javascript.dependencies.Dependencies

query predicate dependencies(PackageJson pkgjson, string pkg, string version) {
  pkgjson.declaresDependency(pkg, version)
}

query predicate importedFile(Require r, File f) { f = r.getImportedFile() }

query predicate importedModule(Require r, Module m) { m = r.getImportedModule() }

query predicate modules(NpmPackage pkg, string name, Module mod) {
  name = pkg.getPackageName() and
  mod = pkg.getAModule()
}

query predicate npm(PackageJson pkg, string name, string version) {
  name = pkg.getPackageName() and
  version = pkg.getVersion()
}

query predicate getMainModule(PackageJson pkg, string name, Module mod) {
  name = pkg.getPackageName() and
  mod = pkg.getMainModule()
}

query predicate packageJson(PackageJson json) { any() }

query predicate dependencyInfo(Dependency dep, string name, string version) {
  dep.info(name, version)
}

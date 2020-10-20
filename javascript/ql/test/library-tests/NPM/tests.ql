import javascript

query predicate dependencies(PackageJSON pkgjson, string pkg, string version) {
  pkgjson.declaresDependency(pkg, version)
}

query predicate importedFile(Require r, File f) { f = r.getImportedFile() }

query predicate importedModule(Require r, Module m) { m = r.getImportedModule() }

query predicate modules(NPMPackage pkg, string name, Module mod) {
  name = pkg.getPackageName() and
  mod = pkg.getAModule()
}

query predicate npm(PackageJSON pkg, string name, string version) {
  name = pkg.getPackageName() and
  version = pkg.getVersion()
}

query predicate getMainModule(PackageJSON pkg, string name, Module mod) {
  name = pkg.getPackageName() and
  mod = pkg.getMainModule()
}

query predicate packageJSON(PackageJSON json) { any() }

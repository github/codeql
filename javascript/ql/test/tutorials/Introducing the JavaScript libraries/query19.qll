import javascript

query predicate test_query19(PackageDependencies deps, string res) {
  exists(NpmPackage pkg, string name |
    deps = pkg.getPackageJson().getDependencies() and
    exists(deps.getADependency(name)) and
    not exists(Require req | req.getTopLevel() = pkg.getAModule() |
      name = req.getImportedPath().getValue()
    )
  |
    res = "Unused dependency '" + name + "'."
  )
}

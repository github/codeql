import javascript

from NPMPackage pkg, PackageDependencies deps, string name
where deps = pkg.getPackageJSON().getDependencies() and
deps.getADependency(name, _) and
not exists (Require req | req.getTopLevel() = pkg.getAModule() | name = req.getImportedPath().getValue())
select deps, "Unused dependency '" + name + "'."

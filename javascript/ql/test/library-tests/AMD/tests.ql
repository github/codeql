import javascript

class TestAmdModuleRange extends AmdModuleDefinition::Range {
  TestAmdModuleRange() { this.getCallee().(PropAccess).getQualifiedName() = "test.amd.range" }
}

query predicate amoModule_exports(Module m, string name, DataFlow::Node exportValue) {
  exportValue = m.getAnExportedValue(name)
}

query predicate amdModule(AmdModule m, AmdModuleDefinition def) { m.getDefine() = def }

query Parameter getDependencyParameter(AmdModuleDefinition mod, string name) {
  result = mod.getDependencyParameter(name)
}

query predicate amdModuleDefinition(AmdModuleDefinition mod, DataFlow::SourceNode factory) {
  mod.getFactoryNode() = factory
}

query predicate amdModuleDependencies(AmdModuleDefinition mod, PathExpr dependency) {
  dependency = mod.getADependency()
}

query predicate amdModuleExportedSymbol(AmdModule m, string sym) { sym = m.getAnExportedSymbol() }

query predicate amdModuleExpr(AmdModuleDefinition d, Expr expr, DataFlow::SourceNode modSrc) {
  expr = d.getModuleExpr() and
  modSrc = d.getAModuleSource()
}

query predicate amdModuleImportedModule(AmdModule m, Import i, Module imported) {
  i = m.getAnImport() and
  imported = i.getImportedModule()
}

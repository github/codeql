import javascript

query predicate analyzedModule_getAnExportedValue(
  AnalyzedModule m, string n, AbstractValue val, string name
) {
  val = m.getAnExportedValue(n) and
  name = m.getName()
}

query predicate analyzedModule_getAnExportsValue(AnalyzedModule m, string name, AbstractValue val) {
  m.getName() = name and
  m.getAnExportsValue() = val
}

query predicate analyzedModule_getExportsProperty(
  AnalyzedModule m, string name, AbstractProperty prop
) {
  name = m.getName() and prop = m.getExportsProperty()
}

query predicate analyzedModule_getModuleObject(
  AnalyzedModule m, string name, AbstractModuleObject mod
) {
  name = m.getName() and mod = m.getModuleObject()
}

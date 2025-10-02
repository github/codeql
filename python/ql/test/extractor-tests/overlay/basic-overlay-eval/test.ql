import python

query predicate testStringLiterals(StringLiteral l, string text) {
  l.getText() = text and
  (
    not exists(l.getLocation())
    or
    l.getLocation().toString().matches("%_src%")
  )
}

query predicate testModules(Module m) {
  not exists(m.getLocation())
  or
  m.getLocation().toString().matches("%_src%")
}

query predicate testFunctions(Function f) {
  not exists(f.getLocation())
  or
  f.getLocation().toString().matches("%_src%")
}

query predicate testClasses(Class c) {
  not exists(c.getLocation())
  or
  c.getLocation().toString().matches("%_src%")
}

query predicate testLocations(Location l) { l.toString().matches("%_src%") }

query predicate testFiles(File f) { f.toString().matches("%_src%") }

query predicate testCfgNodes(ControlFlowNode n) {
  not exists(n.getLocation())
  or
  n.getLocation().toString().matches("%_src%")
}

query predicate testSsaVars(SsaVariable var) {
  not exists(var.getLocation()) and
  var.getVariable().getScope().getLocation().toString().matches("%_src%")
  or
  var.getLocation().toString().matches("%_src%")
}

query predicate testVars(Variable var, Scope s) {
  s = var.getScope() and
  (
    not exists(s.getLocation())
    or
    s.getLocation().toString().matches("%_src%")
  )
}

import python

query predicate testStringLiterals(StringLiteral l, string text) { l.getText() = text }

query predicate testModules(Module m) { any() }

query predicate testFunctions(Function f) { any() }

query predicate testClasses(Class c) { any() }

query predicate testLocations(Location l) { any() }

query predicate testFiles(File f) { any() }

query predicate testCfgNodes(ControlFlowNode n) { any() }

query predicate testSsaVars(SsaVariable var) { any() }

query predicate testVars(Variable var, Scope s) { s = var.getScope() }

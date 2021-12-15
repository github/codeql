import javascript

query predicate dataFlowModuleImports(string name, DataFlow::SourceNode imp) {
  DataFlow::moduleImport(name) = imp
}

query predicate imports(Import imprt, string path, Module mod) {
  path = imprt.getImportedPath().getValue() and
  mod = imprt.getImportedModule()
}

string getModuleType(TopLevel top) {
  not top instanceof Module and
  result = "non-module"
  or
  top instanceof NodeModule and
  result = "node"
  or
  top instanceof ES2015Module and
  result = "es2015"
  or
  top instanceof AmdModule and
  result = "amd"
}

query predicate moduleTypes(TopLevel top, string file, string modType) {
  not top.isExterns() and
  file = top.getFile().getBaseName() and
  modType = getModuleType(top)
}

query predicate resolution(
  DataFlow::NewNode new, ClassDefinition klass, string newFile, string callee, string klassFile
) {
  klass.getConstructor().getInit() = new.getACallee() and
  newFile = new.getFile().getBaseName() and
  callee = new.getCalleeName() and
  klassFile = klass.getFile().getBaseName()
}

class TaintConfig extends TaintTracking::Configuration {
  TaintConfig() { this = "test taint config" }

  override predicate isSource(DataFlow::Node node) {
    node = DataFlow::moduleImport("externalTaintSource").getACall()
  }

  override predicate isSink(DataFlow::Node node) {
    node = DataFlow::moduleImport("externalTaintSink").getACall().getArgument(0)
  }
}

query predicate taint(TaintConfig cfg, DataFlow::Node source, DataFlow::Node sink) {
  cfg.hasFlow(source, sink)
}

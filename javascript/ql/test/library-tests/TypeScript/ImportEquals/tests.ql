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

module TestConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) {
    node = DataFlow::moduleImport("externalTaintSource").getACall()
  }

  predicate isSink(DataFlow::Node node) {
    node = DataFlow::moduleImport("externalTaintSink").getACall().getArgument(0)
  }
}

module TestFlow = TaintTracking::Global<TestConfig>;

query predicate taint = TestFlow::flow/2;

deprecated class LegacyConfig extends TaintTracking::Configuration {
  LegacyConfig() { this = "LegacyConfig" }

  override predicate isSource(DataFlow::Node source) { TestConfig::isSource(source) }

  override predicate isSink(DataFlow::Node sink) { TestConfig::isSink(sink) }
}

deprecated import utils.test.LegacyDataFlowDiff::DataFlowDiff<TestFlow, LegacyConfig>

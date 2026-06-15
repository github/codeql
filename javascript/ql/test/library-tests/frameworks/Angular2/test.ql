import javascript
private import semmle.javascript.security.dataflow.DomBasedXssCustomizations

query Angular2::PipeRefExpr pipeRef() { any() }

query CallExpr pipeCall() { result.getCallee() instanceof Angular2::PipeRefExpr }

query CallExpr pipeCallArg(int i, Expr arg) {
  result.getCallee() instanceof Angular2::PipeRefExpr and
  result.getArgument(i) = arg
}

query Angular2::PipeClass pipeClass() { any() }

query DataFlow::Node pipeClassRef(Angular2::PipeClass cls) { result = cls.getAPipeRef() }

module TestConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.(DataFlow::CallNode).getCalleeName() = "source"
  }

  predicate isSink(DataFlow::Node sink) { sink instanceof DomBasedXss::Sink }
}

module TestFlow = TaintTracking::Global<TestConfig>;

query predicate taintFlow(DataFlow::Node source, DataFlow::Node sink) {
  TestFlow::flow(source, sink)
}

query predicate testAttrSourceLocation(HTML::Attribute attrib, Angular2::TemplateTopLevel top) {
  attrib.getName() = "[testAttr]" and
  top = attrib.getCodeInAttribute()
}

deprecated class LegacyConfig extends TaintTracking::Configuration {
  LegacyConfig() { this = "LegacyConfig" }

  override predicate isSource(DataFlow::Node source) { TestConfig::isSource(source) }

  override predicate isSink(DataFlow::Node sink) { TestConfig::isSink(sink) }
}

deprecated import utils.test.LegacyDataFlowDiff::DataFlowDiff<TestFlow, LegacyConfig>

query predicate threatModelSource(ThreatModelSource source, string kind) {
  kind = source.getThreatModel()
}

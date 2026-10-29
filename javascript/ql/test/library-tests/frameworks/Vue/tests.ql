import javascript
import semmle.javascript.security.dataflow.DomBasedXssCustomizations

module TestConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.(DataFlow::CallNode).getCalleeName() = "source"
  }

  predicate isSink(DataFlow::Node sink) {
    sink = any(DataFlow::CallNode call | call.getCalleeName() = "sink").getAnArgument()
  }
}

module TestDataFlow = DataFlow::Global<TestConfig>;

module TestTaintFlow = TaintTracking::Global<TestConfig>;

query predicate compositionApiDataFlow = TestDataFlow::flow/2;

query predicate compositionApiTaintFlow = TestTaintFlow::flow/2;

query predicate component_getAPropertyValue(Vue::Component c, string name, DataFlow::Node prop) {
  c.getAPropertyValue(name) = prop
}

query predicate component_getOption(Vue::Component c, string name, DataFlow::Node prop) {
  c.getOption(name) = prop
}

query predicate component(Vue::Component c) { any() }

query predicate viewComponentStep(DataFlow::Node pred, DataFlow::Node succ) {
  TaintTracking::viewComponentStep(pred, succ)
}

query predicate templateElement(Vue::Template::Element template) { any() }

query predicate xssSink(DomBasedXss::Sink s) { any() }

query RemoteFlowSource remoteFlowSource() { any() }

query predicate parseErrors(JSParseError err) { exists(err) }

query predicate attribute(HTML::Attribute attrib, string name) { attrib.getName() = name }

query predicate threatModelSource(ThreatModelSource source, string kind) {
  kind = source.getThreatModel()
}

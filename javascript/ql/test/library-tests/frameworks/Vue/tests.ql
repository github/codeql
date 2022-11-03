import javascript
import semmle.javascript.security.dataflow.Xss

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

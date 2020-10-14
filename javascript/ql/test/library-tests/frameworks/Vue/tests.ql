import javascript

query predicate instance_getAPropertyValue(Vue::Instance i, string name, DataFlow::Node prop) {
  i.getAPropertyValue(name) = prop
}

query predicate instance_getOption(Vue::Instance i, string name, DataFlow::Node prop) {
  i.getOption(name) = prop
}

query predicate instance(Vue::Instance i) { any() }

query predicate instance_heapStep(
  Vue::InstanceHeapStep step, DataFlow::Node pred, DataFlow::Node succ
) {
  step.step(pred, succ)
}

query predicate templateElement(Vue::Template::Element template) { any() }

import semmle.javascript.security.dataflow.DomBasedXss

query predicate vhtmlSourceWrite(
  DomBasedXss::VHtmlSourceWrite w, DataFlow::Node pred, DataFlow::Node succ
) {
  w.step(pred, succ)
}

import semmle.javascript.security.dataflow.DomBasedXss

query predicate xssSink(DomBasedXss::Sink s) { any() }

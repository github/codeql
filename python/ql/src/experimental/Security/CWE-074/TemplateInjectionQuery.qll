/**
 * Provides a taint-tracking configuration for detecting "template injection" vulnerabilities.
 */

private import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import TemplateInjectionCustomizations::TemplateInjection

module TemplateInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof Source }

  predicate isSink(DataFlow::Node node) { node instanceof Sink }

  predicate isBarrierIn(DataFlow::Node node) { node instanceof Sanitizer }
}

module TemplateInjectionFlow = TaintTracking::Global<TemplateInjectionConfig>;

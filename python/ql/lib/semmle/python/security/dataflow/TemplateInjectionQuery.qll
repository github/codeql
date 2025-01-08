/**
 * Provides a taint-tracking configuration for detecting "template injection" vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `TemplateInjectionFlow` is needed, otherwise
 * `TemplateInjectionCustomizations` should be imported instead.
 */

private import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import TemplateInjectionCustomizations::TemplateInjection

private module TemplateInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof Source }

  predicate isSink(DataFlow::Node node) { node instanceof Sink }

  predicate isBarrierIn(DataFlow::Node node) { node instanceof Sanitizer }
}

/** Global taint-tracking for detecting "template injection" vulnerabilities. */
module TemplateInjectionFlow = TaintTracking::Global<TemplateInjectionConfig>;

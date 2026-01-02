private import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import PromptInjectionCustomizations::PromptInjection

private module PromptInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof Source }

  predicate isSink(DataFlow::Node node) {
    node instanceof Sink
    //any()
  }

  predicate isBarrierIn(DataFlow::Node node) { node instanceof Sanitizer }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/** Global taint-tracking for detecting "prompt injection" vulnerabilities. */
module PromptInjectionFlow = TaintTracking::Global<PromptInjectionConfig>;

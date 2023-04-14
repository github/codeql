import java
import semmle.code.java.security.PathSanitizer
import TestUtilities.InlineFlowTest

module PathSanitizerConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { DefaultFlowConfig::isSource(source) }

  predicate isSink(DataFlow::Node sink) { DefaultFlowConfig::isSink(sink) }

  predicate isBarrier(DataFlow::Node sanitizer) { sanitizer instanceof PathInjectionSanitizer }
}

module PathSanitizerFlow = TaintTracking::Global<PathSanitizerConfig>;

class Test extends InlineFlowTest {
  override predicate hasValueFlow(DataFlow::Node src, DataFlow::Node sink) { none() }

  override predicate hasTaintFlow(DataFlow::Node src, DataFlow::Node sink) {
    PathSanitizerFlow::flow(src, sink)
  }
}

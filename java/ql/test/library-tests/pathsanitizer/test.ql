import java
import semmle.code.java.security.PathSanitizer
import utils.test.InlineFlowTest

module PathSanitizerConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { DefaultFlowConfig::isSource(source) }

  predicate isSink(DataFlow::Node sink) { DefaultFlowConfig::isSink(sink) }

  predicate isBarrier(DataFlow::Node sanitizer) { sanitizer instanceof PathInjectionSanitizer }
}

import TaintFlowTest<PathSanitizerConfig>

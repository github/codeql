import experimental.meta.InlineTaintTest
import semmle.python.dataflow.new.BarrierGuards

module CustomSanitizerOverridesConfig implements DataFlow::ConfigSig {
  predicate isSource = TestTaintTrackingConfig::isSource/1;

  predicate isSink = TestTaintTrackingConfig::isSink/1;

  predicate isBarrier(DataFlow::Node node) { node instanceof ConstCompareBarrier }
}

import MakeInlineTaintTest<CustomSanitizerOverridesConfig>

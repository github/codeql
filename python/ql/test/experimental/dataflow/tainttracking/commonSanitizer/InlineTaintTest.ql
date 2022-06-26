import experimental.meta.InlineTaintTest
import semmle.python.dataflow.new.BarrierGuards

class CustomSanitizerOverrides extends TestTaintTrackingConfiguration {
  override predicate isSanitizer(DataFlow::Node node) { node instanceof StringConstCompareBarrier }
}

import experimental.dataflow.tainttracking.TestTaintLib
import semmle.python.dataflow.new.BarrierGuards

class CustomSanitizerOverrides extends TestTaintTrackingConfiguration {
  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof StringConstCompare
  }
}

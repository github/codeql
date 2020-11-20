import experimental.dataflow.tainttracking.TestTaintLib

class CustomSanitizerOverrides extends TestTaintTrackingConfiguration {
  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof DataFlow::BarrierGuard::StringConstCompare
  }
}

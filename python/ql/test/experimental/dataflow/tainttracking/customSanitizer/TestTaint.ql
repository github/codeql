import experimental.dataflow.tainttracking.TestTaintLib

class CustomSanitizerOverrides extends TestTaintTrackingConfiguration {
  override predicate isSanitizer(DataFlow::Node node) {
    exists(Call call |
      call.getFunc().(Name).getId() = "emulated_authentication_check" and
      call.getArg(0) = node.asExpr()
    )
    or
    node.asExpr().(Call).getFunc().(Name).getId() = "emulated_escaping"
  }

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    // TODO: Future work for when BarrierGuard is implemented properly
    // exists(Call call |
    //   call.getFunc().(Name).getId() = "emulated_is_safe" and
    // )
    none()
  }
}

query predicate isSanitizer(TestTaintTrackingConfiguration conf, DataFlow::Node node) {
  exists(node.getLocation().getFile().getRelativePath()) and
  conf.isSanitizer(node)
}

query predicate isSanitizerGuard(TestTaintTrackingConfiguration conf, DataFlow::BarrierGuard guard) {
  exists(guard.getLocation().getFile().getRelativePath()) and
  conf.isSanitizerGuard(guard)
}

import javascript

class CheckPathSanitizerGuard extends DataFlow::CallNode {
  CheckPathSanitizerGuard() { this.getCalleeName() = "checkPath" }

  predicate blocksExpr(boolean outcome, Expr e) {
    outcome = true and
    e = this.getArgument(0).asExpr()
  }
}

module CommandLineFileNameConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    DataFlow::globalVarRef("process").getAPropertyRead("argv").getAPropertyRead() = source
  }

  predicate isSink(DataFlow::Node sink) {
    DataFlow::moduleMember("fs", "readFile").getACall().getArgument(0) = sink
  }

  predicate isBarrier(DataFlow::Node node) {
    node = DataFlow::MakeBarrierGuard<CheckPathSanitizerGuard>::getABarrierNode()
  }
}

module CommandLineFileNameFlow = TaintTracking::Global<CommandLineFileNameConfig>;

from DataFlow::Node source, DataFlow::Node sink
where CommandLineFileNameFlow::flow(source, sink)
select source, sink

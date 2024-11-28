import javascript

module CommandLineFileNameConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    DataFlow::globalVarRef("process").getAPropertyRead("argv").getAPropertyRead() = source
  }

  predicate isSink(DataFlow::Node sink) {
    DataFlow::moduleMember("fs", "readFile").getACall().getArgument(0) = sink
  }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(DataFlow::CallNode c |
      c = DataFlow::moduleImport("resolve-symlinks").getACall() and
      pred = c.getArgument(0) and
      succ = c
    )
  }
}

module CommandLineFileNameFlow = TaintTracking::Global<CommandLineFileNameConfig>;

from DataFlow::Node source, DataFlow::Node sink
where CommandLineFileNameFlow::flow(source, sink)
select source, sink

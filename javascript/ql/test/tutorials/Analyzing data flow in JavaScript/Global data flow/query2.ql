import javascript

module CommandLineFileNameConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    DataFlow::globalVarRef("process").getAPropertyRead("argv").getAPropertyRead() = source
  }

  predicate isSink(DataFlow::Node sink) {
    DataFlow::moduleMember("fs", "readFile").getACall().getArgument(0) = sink
  }

  predicate isBarrier(DataFlow::Node nd) { nd.(DataFlow::CallNode).getCalleeName() = "checkPath" }
}

module CommandLineFileNameFlow = TaintTracking::Global<CommandLineFileNameConfig>;

from DataFlow::Node source, DataFlow::Node sink
where CommandLineFileNameFlow::flow(source, sink)
select source, sink

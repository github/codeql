import javascript

class CommandLineFileNameConfiguration extends TaintTracking::Configuration {
  CommandLineFileNameConfiguration() { this = "CommandLineFileNameConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    DataFlow::globalVarRef("process").getAPropertyRead("argv").getAPropertyRead() = source
  }

  override predicate isSink(DataFlow::Node sink) {
    DataFlow::moduleMember("fs", "readFile").getACall().getArgument(0) = sink
  }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(DataFlow::CallNode c |
      c = DataFlow::moduleImport("resolve-symlinks").getACall() and
      pred = c.getArgument(0) and
      succ = c
    )
  }
}

from CommandLineFileNameConfiguration cfg, DataFlow::Node source, DataFlow::Node sink
where cfg.hasFlow(source, sink)
select source, sink

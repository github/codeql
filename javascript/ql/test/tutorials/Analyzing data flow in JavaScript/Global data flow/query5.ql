import javascript

class StepThroughResolveSymlinks extends TaintTracking::AdditionalTaintStep, DataFlow::CallNode {
  StepThroughResolveSymlinks() { this = DataFlow::moduleImport("resolve-symlinks").getACall() }

  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    pred = this.getArgument(0) and
    succ = this
  }
}

class CommandLineFileNameConfiguration extends TaintTracking::Configuration {
  CommandLineFileNameConfiguration() { this = "CommandLineFileNameConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    DataFlow::globalVarRef("process").getAPropertyRead("argv").getAPropertyRead() = source
  }

  override predicate isSink(DataFlow::Node sink) {
    DataFlow::moduleMember("fs", "readFile").getACall().getArgument(0) = sink
  }
}

from CommandLineFileNameConfiguration cfg, DataFlow::Node source, DataFlow::Node sink
where cfg.hasFlow(source, sink)
select source, sink

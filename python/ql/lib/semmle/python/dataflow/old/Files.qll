import python
import semmle.python.dataflow.TaintTracking

deprecated class OpenFile extends TaintKind {
  OpenFile() { this = "file.open" }

  override string repr() { result = "an open file" }
}

deprecated class OpenFileConfiguration extends TaintTracking::Configuration {
  OpenFileConfiguration() { this = "Open file configuration" }

  override predicate isSource(DataFlow::Node src, TaintKind kind) {
    src.asCfgNode() = Value::named("open").getACall() and
    kind instanceof OpenFile
  }

  override predicate isSink(DataFlow::Node sink, TaintKind kind) { none() }
}

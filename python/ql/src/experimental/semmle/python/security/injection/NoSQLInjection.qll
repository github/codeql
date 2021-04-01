import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.DataFlow2
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.TaintTracking2
import experimental.semmle.python.Concepts
import semmle.python.dataflow.new.RemoteFlowSources
import semmle.python.ApiGraphs
// temporary imports (change after query normalization)
import semmle.python.security.dataflow.ChainedConfigs12

class JsonLoadsCall extends DataFlow::CallCfgNode {
  JsonLoadsCall() { this = API::moduleImport("json").getMember("loads").getACall() }

  DataFlow::Node getLoadNode() { result = this.getArg(0) }
}

class XmlToDictParseCall extends DataFlow::CallCfgNode {
  XmlToDictParseCall() { this = API::moduleImport("xmltodict").getMember("parse").getACall() }

  DataFlow::Node getParseNode() { result = this.getArg(0) }
}

class UltraJsonLoadsCall extends DataFlow::CallCfgNode {
  UltraJsonLoadsCall() { this = API::moduleImport("ujson").getMember("loads").getACall() }

  DataFlow::Node getLoadNode() { result = this.getArg(0) }
}

// better name?
class JSONRelatedSink extends DataFlow::Node {
  JSONRelatedSink() {
    this = any(JsonLoadsCall jsonLoads).getLoadNode() or
    this = any(XmlToDictParseCall jsonLoads).getParseNode() or
    this = any(UltraJsonLoadsCall jsonLoads).getLoadNode()
  }
}

class RFStoJSON extends TaintTracking::Configuration {
  RFStoJSON() { this = "RFStoJSON" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof JSONRelatedSink }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer = any(NoSQLSanitizer noSQLSanitizer).getSanitizerNode()
  }
}

// better name?
class FromJSONtoSink extends TaintTracking2::Configuration {
  FromJSONtoSink() { this = "FromJSONtoSink" }

  override predicate isSource(DataFlow::Node source) { source instanceof JSONRelatedSink }

  override predicate isSink(DataFlow::Node sink) {
    sink = any(NoSQLQuery noSQLQuery).getQueryNode()
  }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer = any(NoSQLSanitizer noSQLSanitizer).getSanitizerNode()
  }
}

predicate noSQLInjectionFlow(CustomPathNode source, CustomPathNode sink) {
  exists(
    RFStoJSON config, DataFlow::PathNode mid1, DataFlow2::PathNode mid2, FromJSONtoSink config2
  |
    config.hasFlowPath(source.asNode1(), mid1) and
    config2.hasFlowPath(mid2, sink.asNode2()) and
    mid1.getNode().asCfgNode() = mid2.getNode().asCfgNode()
  )
}

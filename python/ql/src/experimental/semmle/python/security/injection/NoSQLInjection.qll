import python
import experimental.semmle.python.Concepts
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
// https://ghsecuritylab.slack.com/archives/CQJU6RN49/p1617022135088100
import semmle.python.dataflow.new.TaintTracking2
import semmle.python.dataflow.new.RemoteFlowSources
import semmle.python.ApiGraphs

// custom no-Concepts classes
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

class NoSQLInjectionConfig extends TaintTracking::Configuration {
  NoSQLInjectionConfig() { this = "NoSQLInjectionConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof JSONRelatedSink }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer = any(NoSQLSanitizer noSQLSanitizer).getSanitizerNode()
  }
}

// I hate the name ObjectBuilderFunctionConfig so this can be renamed
class ObjectBuilderFunctionConfig extends TaintTracking2::Configuration {
  ObjectBuilderFunctionConfig() { this = "ObjectBuilderFunctionConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof JSONRelatedSink }

  override predicate isSink(DataFlow::Node sink) {
    sink = any(NoSQLQuery noSQLQuery).getQueryNode()
  }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer = any(NoSQLSanitizer noSQLSanitizer).getSanitizerNode()
  }
}

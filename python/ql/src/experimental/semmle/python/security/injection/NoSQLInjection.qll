import python
import experimental.semmle.python.Concepts
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.RemoteFlowSources
import semmle.python.ApiGraphs

// custom no-Concepts classes
class JsonLoadsCall extends DataFlow::CallCfgNode {
  DataFlow::Node loadNode;

  JsonLoadsCall() { this = API::moduleImport("json").getMember("loads").getACall() }

  DataFlow::Node getLoadNode() { result = this.getArg(0) }
}

class XmlToDictParseCall extends DataFlow::CallCfgNode {
  DataFlow::Node parseNode;

  XmlToDictParseCall() { this = API::moduleImport("xmltodict").getMember("parse").getACall() }

  DataFlow::Node getParseNode() { result = this.getArg(0) }
}

class UltraJsonLoadsCall extends DataFlow::CallCfgNode {
  DataFlow::Node loadNode;

  UltraJsonLoadsCall() { this = API::moduleImport("ujson").getMember("loads").getACall() }

  DataFlow::Node getLoadNode() { result = this.getArg(0) }
}

// configs
class XmlToDictParseConfig extends TaintTracking::Configuration {
  XmlToDictParseConfig() { this = "XmlToDictParseConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    sink = any(XmlToDictParseCall xmlToDictParse).getParseNode()
  }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer = any(NoSQLSanitizer noSQLSanitizer).getSanitizerNode()
  }
}

// Must be passed through json.loads(here) since otherwise it would be a string instead of a dict.
class JsonLoadsConfig extends TaintTracking::Configuration {
  JsonLoadsConfig() { this = "JsonLoadsConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    sink = any(JsonLoadsCall jsonLoads).getLoadNode()
  }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer = any(NoSQLSanitizer noSQLSanitizer).getSanitizerNode()
  }
}

// Must be passed through json.loads(here) since otherwise it would be a string instead of a dict.
class UltraJsonLoadsConfig extends TaintTracking::Configuration {
  UltraJsonLoadsConfig() { this = "UltraJsonLoadsConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    sink = any(UltraJsonLoadsCall ultraCall).getLoadNode()
  }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer = any(NoSQLSanitizer noSQLSanitizer).getSanitizerNode()
  }
}

// This predicate should handle args passed to json, xmltodict, ujson, etc.
class ObjectBuilderMethodArg extends DataFlow::Node {
  ObjectBuilderMethodArg() {
    this in [
        any(JsonLoadsCall jsonLoads).getLoadNode(),
        any(XmlToDictParseCall xmlToDictParse).getParseNode(),
        any(UltraJsonLoadsCall ultraCall).getLoadNode()
      ]
  }
}

// I don't think this is possible, we should do something like this in the main query:
/**
 * config1.hasFlowPath(source, sink) or config2.hasFlowPath(source, sink) or config3.hasFlowPath(source, sink)
 * where configs are variables declared from the configs in the list below.
 *
 * class ObjectBuilderMethod extends DataFlow::Node {
 *  ObjectBuilderMethod() { this in [JsonLoadsConfig, XmlToDictParseConfig, UltraJsonLoadsConfig] }
 *}
 */
class NoSQLInjection extends TaintTracking::Configuration {
  NoSQLInjection() { this = "NoSQLInjection" }

  override predicate isSource(DataFlow::Node source) { source instanceof ObjectBuilderMethodArg } // Will be JsonLoadsArg

  override predicate isSink(DataFlow::Node sink) { sink instanceof MongoSinks }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer = any(NoSQLSanitizer noSQLSanitizer).getSanitizerNode()
  }
}

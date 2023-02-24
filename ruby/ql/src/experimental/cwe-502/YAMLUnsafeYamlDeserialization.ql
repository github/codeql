/**
 * @name Deserialization of user-controlled data by YAML
 * @description Deserializing user-controlled data may allow attackers to
 *              execute arbitrary code.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 9.8
 * @precision high
 * @id rb/YAML-unsafe-deserialization
 * @tags security
 *       experimental
 *       external/cwe/cwe-502
 */

import codeql.ruby.ApiGraphs
import codeql.ruby.DataFlow
import codeql.ruby.TaintTracking
import DataFlow::PathGraph
import codeql.ruby.security.UnsafeDeserializationCustomizations

abstract class YamlSink extends DataFlow::Node { }

class YamlUnsafeLoadArgument extends YamlSink {
  YamlUnsafeLoadArgument() {
    this =
      API::getTopLevelMember(["YAML", "Psych"])
          .getAMethodCall(["unsafe_load_file", "unsafe_load", "load_stream"])
          .getArgument(0)
    or
    this =
      API::getTopLevelMember(["YAML", "Psych"])
          .getAMethodCall(["unsafe_load", "load_stream"])
          .getKeywordArgument("yaml")
    or
    this =
      API::getTopLevelMember(["YAML", "Psych"])
          .getAMethodCall("unsafe_load_file")
          .getKeywordArgument("filename")
    or
    this =
      API::getTopLevelMember(["YAML", "Psych"])
          .getAMethodCall(["parse", "parse_stream", "parse_file"])
          .getAMethodCall("to_ruby")
  }
}

class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "UnsafeYAMLDeserialization" }

  override predicate isSource(DataFlow::Node source) {
    // to detect CVE-2022-32224, we should uncomment following line instead of current UnsafeDeserialization::Source
    // source instanceof DataFlow::LocalSourceNode
    source instanceof UnsafeDeserialization::Source
  }

  override predicate isSink(DataFlow::Node sink) {
    // after changing the isSource for detecting CVE-2022-32224
    // uncomment the following line only see the CVE sink not other files similar sinks
    // sink.getLocation().getFile().toString().matches("%yaml_column%") and
    sink instanceof YamlSink
  }

  override predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    exists(DataFlow::CallNode yaml_parser_methods |
      yaml_parser_methods =
        API::getTopLevelMember(["YAML", "Psych"]).getAMethodCall(["parse", "parse_stream"]) and
      (
        nodeFrom = yaml_parser_methods.getArgument(0) or
        nodeFrom = yaml_parser_methods.getKeywordArgument("yaml")
      ) and
      nodeTo = yaml_parser_methods.getAMethodCall("to_ruby")
    )
    or
    exists(DataFlow::CallNode yaml_parser_methods |
      yaml_parser_methods = API::getTopLevelMember(["YAML", "Psych"]).getAMethodCall("parse_file") and
      (
        nodeFrom = yaml_parser_methods.getArgument(0) or
        nodeFrom = yaml_parser_methods.getKeywordArgument("filename")
      ) and
      nodeTo = yaml_parser_methods.getAMethodCall("to_ruby")
    )
  }
}

from Configuration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "This file extraction depends on a $@.", source.getNode(),
  "potentially untrusted source"

/**
 * add additional steps for to_ruby method of YAML/Psych library
 */

private import codeql.ruby.dataflow.FlowSteps
private import codeql.ruby.DataFlow
private import codeql.ruby.ApiGraphs

private class YamlParseStep extends AdditionalTaintStep {
  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    exists(DataFlow::CallNode yaml_parser_methods |
      yaml_parser_methods =
        API::getTopLevelMember(["YAML", "Psych"]).getAMethodCall(["parse", "parse_stream"]) and
      (
        pred = yaml_parser_methods.getArgument(0) or
        pred = yaml_parser_methods.getKeywordArgument("yaml")
      ) and
      succ = yaml_parser_methods.getAMethodCall("to_ruby")
    )
    or
    exists(DataFlow::CallNode yaml_parser_methods |
      yaml_parser_methods = API::getTopLevelMember(["YAML", "Psych"]).getAMethodCall("parse_file") and
      (
        pred = yaml_parser_methods.getArgument(0) or
        pred = yaml_parser_methods.getKeywordArgument("filename")
      ) and
      succ = yaml_parser_methods.getAMethodCall("to_ruby")
    )
  }
}

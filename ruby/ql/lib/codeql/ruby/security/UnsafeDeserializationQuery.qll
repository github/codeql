/**
 * Provides a taint-tracking configuration for reasoning about unsafe deserialization.
 *
 * Note, for performance reasons: only import this file if
 * `UnsafeDeserialization::Configuration` is needed, otherwise
 * `UnsafeDeserializationCustomizations` should be imported instead.
 */

private import codeql.ruby.AST
private import codeql.ruby.DataFlow
private import codeql.ruby.TaintTracking
private import codeql.ruby.ApiGraphs
import UnsafeDeserializationCustomizations

/**
 * A taint-tracking configuration for reasoning about unsafe deserialization.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "UnsafeDeserialization" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof UnsafeDeserialization::Source
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof UnsafeDeserialization::Sink }

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

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof UnsafeDeserialization::Sanitizer
  }
}

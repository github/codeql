/**
 * Provides modeling for the `YAML` and `Psych` libraries.
 */

private import codeql.ruby.dataflow.FlowSteps
private import codeql.ruby.DataFlow
private import codeql.ruby.ApiGraphs

/**
 * Gets A Node ends with YAML parse, parse_stream, parse_file methods
 */
API::Node yamlParseNode(API::Node yamlParseInstance) {
  result = yamlParseInstance
  or
  result = yamlParseNode(yamlParseInstance).getReturn()
  or
  result = yamlParseNode(yamlParseInstance).getBlock()
  or
  result = yamlParseNode(yamlParseInstance).getAnElement()
  or
  result = yamlParseNode(yamlParseInstance).getParameter(_)
  or
  result = yamlParseNode(yamlParseInstance).getMethod(_)
  or
  result = yamlParseNode(yamlParseInstance).getMember(_)
  or
  result = yamlParseNode(yamlParseInstance).getArgument(_)
}

/**
 * Gets A YAML module instance
 */
API::Node yamlLibrary() { result = API::getTopLevelMember(["YAML", "Psych"]) }

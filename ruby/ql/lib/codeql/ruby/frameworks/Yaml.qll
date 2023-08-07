/**
 * Provides modeling for the `YAML` and `Psych` libraries.
 */

private import codeql.ruby.dataflow.FlowSteps
private import codeql.ruby.DataFlow
private import codeql.ruby.ApiGraphs

/**
 * A taint step related to the result of `YAML.parse` calls, or similar.
 * In the following example, this step will propagate taint from
 * `source` to `sink`:
 * this contains two seperate steps:
 * ```rb
 * x = source
 * sink = YAML.parse(x)
 * ```
 * By second step
 * source is a Successor of `YAML.parse(x)`
 * which ends with `to_ruby` or an Element of `to_ruby`
 * ```ruby
 * sink source.to_ruby # Unsafe call
 * ```
 */
private class YamlParseStep extends AdditionalTaintStep {
  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    exists(API::Node yamlParserMethod |
      succ = yamlParserMethod.getReturn().asSource() and
      (
        yamlParserMethod = yamlLibrary().getMethod(["parse", "parse_stream"]) and
        pred =
          [yamlParserMethod.getParameter(0), yamlParserMethod.getKeywordParameter("yaml")].asSink()
        or
        yamlParserMethod = yamlLibrary().getMethod("parse_file") and
        pred =
          [yamlParserMethod.getParameter(0), yamlParserMethod.getKeywordParameter("filename")]
              .asSink()
      )
    )
    or
    exists(API::Node parseSuccessors | parseSuccessors = yamlNode() |
      succ =
        [
          parseSuccessors.getMethod(["to_ruby", "transform"]).getReturn().asSource(),
          parseSuccessors.getMethod(["to_ruby", "transform"]).getReturn().getAnElement().asSource()
        ] and
      pred = parseSuccessors.asSource()
    )
    or
    exists(API::Node parseSuccessors | parseSuccessors = yamlNode() |
      succ =
        [
          parseSuccessors.getMethod(_).getBlock().getParameter(_).asSource(),
          parseSuccessors.getMethod(_).getReturn().asSource()
        ] and
      pred = parseSuccessors.asSource()
    )
  }
}

/**
 * Gets A Node ends with YAML parse, parse_stream, parse_file methods
 */
API::Node yamlNode() {
  result = yamlLibrary().getMethod(["parse", "parse_stream", "parse_file"]).getReturn()
  or
  result = yamlNode().getMethod(_).getReturn()
  or
  result = yamlNode().getMethod(_).getBlock().getParameter(_)
  or
  result = yamlNode().getAnElement()
}

/**
 * Gets A YAML module instance
 */
API::Node yamlLibrary() { result = API::getTopLevelMember(["YAML", "Psych"]) }

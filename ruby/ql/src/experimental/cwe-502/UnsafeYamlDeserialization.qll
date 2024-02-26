/**
 * Provides a taint-tracking configuration for reasoning about unsafe deserialization.
 *
 * Note, for performance reasons: only import this file if
 * `UnsafeYamlDeserializationFlow` is needed, otherwise
 * `UnsafeYamlDeserializationCustomizations` should be imported instead.
 */

private import codeql.ruby.AST
private import codeql.ruby.DataFlow
private import codeql.ruby.TaintTracking
private import codeql.ruby.ApiGraphs
import UnsafeYamlDeserializationCustomizations::UnsafeYamlDeserialization
import Yaml

private module UnsafeYamlDeserializationConfig implements DataFlow::StateConfigSig {
  class FlowState = FlowState::State;

  predicate isSource(DataFlow::Node source, FlowState state) {
    source instanceof Source and
    (state instanceof FlowState::Parse or state instanceof FlowState::Load)
  }

  predicate isSink(DataFlow::Node sink, FlowState state) {
    sink instanceof Sink and
    (state instanceof FlowState::Parse or state instanceof FlowState::Load)
  }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  /**
   * Holds if taint with state `stateFrom` can flow from `pred` to `succ` with state `stateTo`.
   *
   * This is a taint step related to the result of `YAML.parse` calls, or similar.
   * In the following example, this step will propagate taint from
   * `source` to `sink`:
   * this contains two separate steps:
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
  predicate isAdditionalFlowStep(
    DataFlow::Node pred, FlowState stateFrom, DataFlow::Node succ, FlowState stateTo
  ) {
    (
      exists(API::Node parseSuccessors, API::Node parseMethod |
        parseMethod = yamlLibrary().getMethod(["parse", "parse_stream", "parse_file"]) and
        parseSuccessors = yamlParseNode(parseMethod)
      |
        succ = parseSuccessors.getMethod("to_ruby").getReturn().asSource() and
        pred = parseMethod.getArgument(0).asSink()
      )
      or
      exists(API::Node parseMethod |
        parseMethod = yamlLibrary().getMethod(["parse", "parse_stream", "parse_file"])
      |
        succ = parseMethod.getReturn().asSource() and
        pred = parseMethod.getArgument(0).asSink()
      )
    ) and
    stateFrom instanceof FlowState::Parse and
    stateTo instanceof FlowState::Parse
  }
}

predicate isAdditionalFlowStepTest(DataFlow::Node pred, DataFlow::Node succ) {
  exists(API::Node parseMethod |
    parseMethod = yamlLibrary().getMethod(["parse", "parse_stream", "parse_file"])
  |
    succ = parseMethod.getReturn().asSource() and
    pred = parseMethod.getArgument(0).asSink()
  )
}

/**
 * Taint-tracking for reasoning about unsafe deserialization.
 */
module UnsafeCodeConstructionFlow = TaintTracking::GlobalWithState<UnsafeYamlDeserializationConfig>;

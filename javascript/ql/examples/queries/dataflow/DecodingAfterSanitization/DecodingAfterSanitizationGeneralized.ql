/**
 * @name Decoding after sanitization (generalized)
 * @description Tracks the return value of an HTML sanitizer into an escape-sequence decoder,
 *              indicating an ineffective sanitization attempt.
 * @kind path-problem
 * @problem.severity error
 * @tags security
 * @id js/examples/decoding-after-sanitization-generalized
 */

import javascript

/**
 * A call to a function that may introduce HTML meta-characters by
 * replacing `%3C` or `\u003C` with `<`.
 */
class DecodingCall extends DataFlow::CallNode {
  string kind;
  DataFlow::Node input;

  DecodingCall() {
    this.getCalleeName().matches("decodeURI%") and
    input = this.getArgument(0) and
    kind = "URI decoding"
    or
    input = this.(JsonParserCall).getInput() and
    kind = "JSON parsing"
  }

  /** Gets the decoder kind, to be used in the alert message. */
  string getKind() { result = kind }

  /** Gets the input being decoded. */
  DataFlow::Node getInput() { result = input }
}

module DecodingAfterSanitizationConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof HtmlSanitizerCall }

  predicate isSink(DataFlow::Node node) { node = any(DecodingCall c).getInput() }
}

module DecodingAfterSanitizationFlow = TaintTracking::Global<DecodingAfterSanitizationConfig>;

import DecodingAfterSanitizationFlow::PathGraph

from
  DecodingAfterSanitizationFlow::PathNode source, DecodingAfterSanitizationFlow::PathNode sink,
  DecodingCall decoder
where
  DecodingAfterSanitizationFlow::flowPath(source, sink) and
  decoder.getInput() = sink.getNode()
select sink.getNode(), source, sink, decoder.getKind() + " invalidates $@.", source.getNode(),
  "this HTML sanitization"

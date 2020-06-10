/**
 * @name Improper code sanitization
 * @description Escaping code as HTML does not provide protection against code-injection.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id js/bad-code-sanitization
 * @tags security
 *       external/cwe/cwe-094
 *       external/cwe/cwe-079
 *       external/cwe/cwe-116
 */

// TODO: Proper customizations module, Source class Sink class etc. and qldoc.
import javascript
import DataFlow::PathGraph
private import semmle.javascript.heuristics.HeuristicSinks
private import semmle.javascript.security.dataflow.CodeInjectionCustomizations

/**
 * A taint-tracking configuration for reasoning about improper code sanitization vulnerabilities.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "ImproperCodeSanitization" }

  override predicate isSource(DataFlow::Node source) { source = source() }

  override predicate isSink(DataFlow::Node sink) { sink = sink() }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer instanceof StringReplaceCall // any string-replace that happens after the bad-sanitizer, is assumed to be a good sanitizer.
    // TODO: Specialize? This regexp sanitizes: /[<>\b\f\n\r\t\0\u2028\u2029]/g
  }
}

private DataFlow::CallNode source() {
  result instanceof HtmlSanitizerCall
  or
  result = DataFlow::globalVarRef("JSON").getAMemberCall("stringify")
}

private StringOps::ConcatenationLeaf sink() {
  exists(StringOps::ConcatenationRoot root, int i |
    root.getOperand(i) = result and
    not exists(result.getStringValue())
  |
    exists(StringOps::ConcatenationLeaf functionLeaf |
      functionLeaf = root.getOperand(any(int j | j < i))
    |
      functionLeaf
          .getStringValue()
          .regexpMatch([".*function( )?([a-zA-Z0-9]+)?( )?\\(.*", ".*eval\\(.*",
                ".*new Function\\(.*", "(^|.*[^a-zA-Z0-9])\\(.*\\)( )?=>.*"])
    )
  )
}

DataFlow::SourceNode remoteFlow(DataFlow::TypeTracker t) {
  t.start() and
  result instanceof RemoteFlowSource
  or
  exists(DataFlow::TypeTracker t2 | result = remoteFlow(t2).track(t2, t))
}

DataFlow::SourceNode remoteFlow() { result = remoteFlow(DataFlow::TypeTracker::end()) }

private DataFlow::Node endsInCodeInjectionSink(DataFlow::TypeBackTracker t) {
  t.start() and
  (
    result instanceof CodeInjection::Sink
    or
    result instanceof HeuristicCodeInjectionSink and
    not result instanceof StringOps::ConcatenationRoot // the heuristic CodeInjection sink looks for string-concats, we are not interrested in those here.
  )
  or
  exists(DataFlow::TypeBackTracker t2 | t = t2.smallstep(result, endsInCodeInjectionSink(t2)))
}

DataFlow::Node endsInCodeInjectionSink() {
  result = endsInCodeInjectionSink(DataFlow::TypeBackTracker::end()) and
  result.getFile().getBaseName() = "bad-code-sanitization.js" // TODO: TMp
}

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where
  cfg.hasFlowPath(source, sink) and
  // Basic detection of duplicate results with `js/code-injection`.
  not (
    sink.getNode().(StringOps::ConcatenationLeaf).getRoot() = endsInCodeInjectionSink() and
    remoteFlow().flowsTo(source.getNode().(DataFlow::InvokeNode).getAnArgument())
  )
select sink.getNode(), source, sink, "$@ flows to here and is used to construct code.",
  source.getNode(), "Improperly sanitized value"

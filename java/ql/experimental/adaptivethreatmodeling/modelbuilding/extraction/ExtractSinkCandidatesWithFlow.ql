/**
 * Surfaces the endpoints that pass the endpoint filters and have flow from a source for each query config, and are
 * therefore used as candidates for classification with an ML model.
 *
 * Note: This query does not actually classify the endpoints using the model.
 *
 * @name Sink candidates with flow (experimental)
 * @description Sink candidates with flow from a source
 * @kind problem
 * @id java/ml-powered/sink-candidates-with-flow
 * @tags experimental security
 */

private import java
import semmle.code.java.dataflow.TaintTracking
private import experimental.adaptivethreatmodeling.ATMConfig as AtmConfig
private import experimental.adaptivethreatmodeling.SqlTaintedATM as SqlTaintedAtm
private import experimental.adaptivethreatmodeling.TaintedPathATM as TaintedPathAtm
private import experimental.adaptivethreatmodeling.RequestForgeryATM as RequestForgeryAtm

from
  DataFlow::Node sink, string message, string package, string type, boolean subtypes, string name,
  string signature, string ext, string input, string provenance
where
  exists(Callable callee, Call call, int index |
    sink.asExpr() = call.getArgument(index) and
    callee = call.getCallee() and
    package = callee.getDeclaringType().getPackage().getName() and
    type = callee.getDeclaringType().getName() and //TODO: Will this work for inner classes? Will it produce X$Y? What about lambdas? What about enums? What about interfaces? What about annotations?
    subtypes = true and // TODO
    name = callee.getName() and // TODO: Will this work for constructors?
    signature = callee.paramsString() and
    ext = "" and // TODO
    input = "Argument[" + index + "]" and // TODO: why are slashes added?
    provenance = "manual" // TODO
  ) and
  // The message is the concatenation of all relevant configs, and we surface only sinks that have at least one relevant
  // config.
  message =
    strictconcat(AtmConfig::AtmConfig config, DataFlow::PathNode sinkPathNode |
        config.isSinkCandidateWithFlow(sinkPathNode) and
        sinkPathNode.getNode() = sink
      |
        config.getASinkEndpointType().getDescription(), ", "
      ) + "\n{'package': '" + package + "', 'type': '" + type + "', 'subtypes': " + subtypes +
      ", 'name': '" + name + "', 'signature': '" + signature + "', 'ext': '" + ext + "', 'input': '"
      + input + "', 'provenance': '" + provenance + "'}" // TODO: Why are the curly braces added twice?
select sink, message

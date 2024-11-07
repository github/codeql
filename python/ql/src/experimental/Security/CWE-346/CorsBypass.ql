/**
 * @name Cross Origin Resource Sharing(CORS) Policy Bypass
 * @description Checking user supplied origin headers using weak comparators like 'string.startswith' may lead to CORS policy bypass.
 * @kind path-problem
 * @problem.severity warning
 * @id py/cors-bypass
 * @tags security
 *       externa/cwe/CWE-346
 */

import python
import semmle.python.ApiGraphs
import semmle.python.dataflow.new.TaintTracking
import semmle.python.Flow
import semmle.python.dataflow.new.RemoteFlowSources

/**
 * Returns true if the control flow node may be useful in the current context.
 *
 * Ideally for more completeness, we should alert on every `startswith` call and every remote flow source which gets partailly checked. But, as this can lead to lots of FPs, we apply heuristics to filter some calls. This predicate provides logic for this filteration.
 */
private predicate maybeInteresting(ControlFlowNode c) {
  // Check if the name of the variable which calls the function matches the heuristic.
  // This would typically occur at the sink.
  // This should deal with cases like
  // `origin.startswith("bla")`
  heuristics(c.(CallNode).getFunction().(AttrNode).getObject().(NameNode).getId())
  or
  // Check if the name of the variable passed as an argument to the functions matches the heuristic. This would typically occur at the sink.
  // This should deal with cases like
  // `bla.startswith(origin)`
  heuristics(c.(CallNode).getArg(0).(NameNode).getId())
  or
  // Check if the value gets written to any interesting variable. This would typically occur at the source.
  // This should deal with cases like
  // `origin = request.headers.get('My-custom-header')`
  exists(Variable v | heuristics(v.getId()) | c.getASuccessor*().getNode() = v.getAStore())
}

private class StringStartswithCall extends ControlFlowNode {
  StringStartswithCall() { this.(CallNode).getFunction().(AttrNode).getName() = "startswith" }
}

bindingset[s]
predicate heuristics(string s) { s.matches(["%origin%", "%cors%"]) }

/**
 * A member of the `cherrypy.request` class taken as a `RemoteFlowSource`.
 */
class CherryPyRequest extends RemoteFlowSource::Range {
  CherryPyRequest() {
    this =
      API::moduleImport("cherrypy")
          .getMember("request")
          .getMember([
              "charset", "content_type", "filename", "fp", "name", "params", "headers", "length",
            ])
          .asSource()
  }

  override string getSourceType() { result = "cherrypy.request" }
}

module CorsBypassConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node node) {
    exists(StringStartswithCall s |
      node.asCfgNode() = s.(CallNode).getArg(0) or
      node.asCfgNode() = s.(CallNode).getFunction().(AttrNode).getObject()
    )
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(API::CallNode c, API::Node n |
      n = API::moduleImport("cherrypy").getMember("request").getMember("headers") and
      c = n.getMember("get").getACall()
    |
      c.getReturn().asSource() = node2 and n.asSource() = node1
    )
  }
}

module CorsFlow = TaintTracking::Global<CorsBypassConfig>;

import CorsFlow::PathGraph

from CorsFlow::PathNode source, CorsFlow::PathNode sink
where
  CorsFlow::flowPath(source, sink) and
  (
    maybeInteresting(source.getNode().asCfgNode())
    or
    maybeInteresting(sink.getNode().asCfgNode())
  )
select sink, source, sink,
  "Potentially incorrect string comparison which could lead to a CORS bypass."

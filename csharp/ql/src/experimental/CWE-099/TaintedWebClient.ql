/**
 * @name Uncontrolled data used in a WebClient
 * @description The WebClient class allows developers to request resources,
 *              accessing resources influenced by users can allow an attacker to access local files.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id cs/webclient-path-injection
 * @tags security
 *       experimental
 *       external/cwe/cwe-099
 *       external/cwe/cwe-023
 *       external/cwe/cwe-036
 *       external/cwe/cwe-073
 */

import csharp
deprecated import TaintedWebClientLib
deprecated import TaintedWebClient::PathGraph

deprecated query predicate problems(
  DataFlow::Node sinkNode, TaintedWebClient::PathNode source, TaintedWebClient::PathNode sink,
  string message1, DataFlow::Node sourceNode, string message2
) {
  TaintedWebClient::flowPath(source, sink) and
  sinkNode = sink.getNode() and
  message1 = "A method of WebClient depepends on a $@." and
  sourceNode = source.getNode() and
  message2 = "user-provided value"
}

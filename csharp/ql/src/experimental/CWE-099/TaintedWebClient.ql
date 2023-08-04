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
import TaintedWebClientLib
import TaintedWebClient::PathGraph

from TaintedWebClient::PathNode source, TaintedWebClient::PathNode sink
where TaintedWebClient::flowPath(source, sink)
select sink.getNode(), source, sink, "A method of WebClient depepends on a $@.", source.getNode(),
  "user-provided value"

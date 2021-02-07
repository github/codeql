/**
 * @name Uncontrolled data used in a WebClient
 * @description The WebClient class allows developers to request resources,
 *              accessing resources influenced by users can allow an attacker to access local files.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id cs/request-forgery
 * @tags security
 *       external/cwe/cwe-918
 */

import csharp
import RequestForgery::RequestForgery
import semmle.code.csharp.dataflow.DataFlow::DataFlow::PathGraph

from RequestForgeryConfiguration c, DataFlow::PathNode source, DataFlow::PathNode sink
where c.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ flows to here and is used in a method of WebClient.",
  source.getNode(), "User-provided value"

/**
 * @name Denial of Service from comparison of user input against expensive regex
 * @description User input should not be matched against a regular expression that could require
 *              exponential time on certain input.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id cs/redos
 * @tags security
 *       external/cwe/cwe-730
 *       external/cwe/cwe-400
 */

import csharp
import semmle.code.csharp.security.dataflow.ReDoS::ReDoS
import semmle.code.csharp.frameworks.system.text.RegularExpressions
import semmle.code.csharp.dataflow.DataFlow::DataFlow::PathGraph

from TaintTrackingConfiguration c, DataFlow::PathNode source, DataFlow::PathNode sink
where
  c.hasFlowPath(source, sink) and
  // No global timeout set
  not exists(RegexGlobalTimeout r) and
  (
    sink.getNode() instanceof Sink
    or
    sink.getNode() instanceof ExponentialRegexSink
  )
select sink.getNode(), source, sink,
  "$@ flows to regular expression operation with dangerous regex.", source.getNode(),
  "User-provided value"

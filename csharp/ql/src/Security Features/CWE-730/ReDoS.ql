/**
 * @name Denial of Service from comparison of user input against expensive regex
 * @description User input should not be matched against a regular expression that could require
 *              exponential time on certain input.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id cs/redos
 * @tags security
 *       external/cwe/cwe-1333
 *       external/cwe/cwe-730
 *       external/cwe/cwe-400
 */

import csharp
import semmle.code.csharp.security.dataflow.ReDoSQuery
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
  "This regex operation with dangerous complexity depends on a $@.", source.getNode(),
  "user-provided value"

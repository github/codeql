/**
 * @name Denial of Service from comparison of user input against expensive regex
 * @description User input should not be matched against a regular expression that could require
 *              exponential time on certain input.
 * @kind problem
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

from TaintTrackingConfiguration c, Source source, DataFlow::Node sink
where c.hasFlow(source, sink)
  // No global timeout set
  and not exists(RegexGlobalTimeout r)
select sink, "$@ flows to regular expression operation with dangerous regex.", source, "User-provided value"

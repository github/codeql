/**
 * @name Regular expression injection
 * @description User input should not be used in regular expressions without first being escaped,
 *              otherwise a malicious user may be able to provide a regex that could require
 *              exponential time on certain inputs.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cs/regex-injection
 * @tags security
 *       external/cwe/cwe-730
 *       external/cwe/cwe-400
 */
import csharp
import semmle.code.csharp.security.dataflow.RegexInjection::RegexInjection
import semmle.code.csharp.frameworks.system.text.RegularExpressions

from TaintTrackingConfiguration c, Source source, Sink sink
where c.hasFlow(source, sink)
  // No global timeout set
  and not exists(RegexGlobalTimeout r)
select sink, "$@ flows to the construction of a regular expression.", source, "User-provided value"

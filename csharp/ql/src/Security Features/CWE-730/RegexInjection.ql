/**
 * @name Regular expression injection
 * @description User input should not be used in regular expressions without first being escaped,
 *              otherwise a malicious user may be able to provide a regex that could require
 *              exponential time on certain inputs.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id cs/regex-injection
 * @tags security
 *       external/cwe/cwe-730
 *       external/cwe/cwe-400
 */

import csharp
import semmle.code.csharp.security.dataflow.RegexInjectionQuery
import semmle.code.csharp.frameworks.system.text.RegularExpressions
import RegexInjection::PathGraph

from RegexInjection::PathNode source, RegexInjection::PathNode sink
where
  RegexInjection::flowPath(source, sink) and
  // No global timeout set
  not exists(RegexGlobalTimeout r)
select sink.getNode(), source, sink, "This regular expression is constructed from a $@.",
  source.getNode(), "user-provided value"

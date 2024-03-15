/**
 * @name Regular expression injection with additional heuristic sources
 * @description User input should not be used in regular expressions without first being escaped,
 *              otherwise a malicious user may be able to inject an expression that could require
 *              exponential time on certain inputs.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id js/regex-injection-more-sources
 * @tags experimental
 *       security
 *       external/cwe/cwe-730
 *       external/cwe/cwe-400
 */

import javascript
import semmle.javascript.security.dataflow.RegExpInjectionQuery
import RegExpInjectionFlow::PathGraph
import semmle.javascript.heuristics.AdditionalSources

from RegExpInjectionFlow::PathNode source, RegExpInjectionFlow::PathNode sink
where RegExpInjectionFlow::flowPath(source, sink) and source.getNode() instanceof HeuristicSource
select sink.getNode(), source, sink, "This regular expression is constructed from a $@.",
  source.getNode(), "user-provided value"

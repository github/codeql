/**
 * @name Regular expression injection
 * @description User input should not be used in regular expressions without
 *              first being escaped. Otherwise, a malicious user may be able to
 *              inject an expression that could require exponential time on
 *              certain inputs.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id rb/regexp-injection
 * @tags security
 *       external/cwe/cwe-1333
 *       external/cwe/cwe-730
 *       external/cwe/cwe-400
 */

import ruby
import DataFlow::PathGraph
import codeql.ruby.DataFlow
import codeql.ruby.security.performance.RegExpInjectionQuery

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "This regular expression is constructed from a $@.",
  source.getNode(), "user-provided value"

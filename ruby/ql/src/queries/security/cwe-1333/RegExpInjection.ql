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

import codeql.ruby.security.regexp.RegExpInjectionQuery
import RegExpInjectionFlow::PathGraph

from RegExpInjectionFlow::PathNode source, RegExpInjectionFlow::PathNode sink
where RegExpInjectionFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This regular expression depends on a $@.", source.getNode(),
  "user-provided value"

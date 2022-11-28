/**
 * @name Regular expression injection
 * @description User input should not be used in regular expressions without first being escaped,
 *              otherwise a malicious user may be able to provide a regex that could require
 *              exponential time on certain inputs.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id java/regex-injection
 * @tags security
 *       external/cwe/cwe-730
 *       external/cwe/cwe-400
 */

import java
import semmle.code.java.security.regexp.RegexInjectionQuery
import DataFlow::PathGraph

from DataFlow::PathNode source, DataFlow::PathNode sink, RegexInjectionConfiguration c
where c.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "This regular expression is constructed from a $@.",
  source.getNode(), "user-provided value"

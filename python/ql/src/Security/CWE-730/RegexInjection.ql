/**
 * @name Regular expression injection
 * @description User input should not be used in regular expressions without first being escaped,
 *              otherwise a malicious user may be able to inject an expression that could require
 *              exponential time on certain inputs.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id py/regex-injection
 * @tags security
 *       external/cwe/cwe-730
 *       external/cwe/cwe-400
 */

import python
private import semmle.python.Concepts
import semmle.python.security.dataflow.RegexInjectionQuery
import RegexInjectionFlow::PathGraph

from
  RegexInjectionFlow::PathNode source, RegexInjectionFlow::PathNode sink,
  RegexExecution regexExecution
where
  RegexInjectionFlow::flowPath(source, sink) and
  regexExecution = sink.getNode().(Sink).getRegexExecution()
select sink.getNode(), source, sink,
  "This regular expression depends on a $@ and is executed by $@.", source.getNode(),
  "user-provided value", regexExecution, regexExecution.getName()

/**
 * @name Regular expression injection
 * @description User input should not be used in regular expressions without first being escaped,
 *              otherwise a malicious user may be able to inject an expression that could require
 *              exponential time on certain inputs.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id py/regex-injection
 * @tags security
 *       external/cwe/cwe-730
 *       external/cwe/cwe-400
 */

import python
private import semmle.python.Concepts
import semmle.python.security.dataflow.RegexInjection
import DataFlow::PathGraph

from
  RegexInjection::Configuration config, DataFlow::PathNode source, DataFlow::PathNode sink,
  RegexExecution regexExecution
where
  config.hasFlowPath(source, sink) and
  regexExecution = sink.getNode().(RegexInjection::Sink).getRegexExecution()
select sink.getNode(), source, sink,
  "$@ regular expression is constructed from a $@ and executed by $@.", sink.getNode(), "This",
  source.getNode(), "user-provided value", regexExecution, regexExecution.getName()

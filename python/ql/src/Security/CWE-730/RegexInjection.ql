/**
 * @name Regular expression injection
 * @description User input should not be used in regular expressions without first being escaped,
 *              otherwise a malicious user may be able to inject an expression that could require
 *              exponential time on certain inputs.
 * @kind path-problem
 * @problem.severity error
 * @id py/regex-injection
 * @tags security
 *       external/cwe/cwe-730
 *       external/cwe/cwe-400
 */

// determine precision above
import python
import semmle.python.security.injection.RegexInjection
import DataFlow::PathGraph

from
  RegexInjection::Configuration config, DataFlow::PathNode source, DataFlow::PathNode sink,
  RegexInjection::Sink regexInjectionSink
where
  config.hasFlowPath(source, sink) and
  regexInjectionSink = sink.getNode()
select sink.getNode(), source, sink,
  "$@ regular expression is constructed from a $@ and executed by $@.",
  regexInjectionSink.getRegexNode(), "This", source.getNode(), "user-provided value",
  regexInjectionSink, regexInjectionSink.getName()

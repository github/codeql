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
import experimental.semmle.python.security.injection.RegexInjection
import DataFlow::PathGraph

from
  RegexInjectionFlowConfig config, DataFlow::PathNode source, DataFlow::PathNode sink,
  RegexInjectionSink regexInjectionSink, Attribute methodAttribute
where
  config.hasFlowPath(source, sink) and
  regexInjectionSink = sink.getNode() and
  methodAttribute = regexInjectionSink.getRegexMethod()
select sink.getNode(), source, sink,
  "$@ regular expression is constructed from a $@ and executed by $@.", sink.getNode(), "This",
  source.getNode(), "user-provided value", methodAttribute,
  regexInjectionSink.getRegexModule() + "." + methodAttribute.getName()

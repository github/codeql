/**
 * @name XML injection
 * @description User input should not be parsed without security options enabled.
 * @kind path-problem
 * @problem.severity error
 * @id py/xml-injection
 * @tags security
 *       external/cwe/cwe-611
 *       external/cwe/cwe-776
 *       external/cwe/cwe-827
 */

// determine precision above
import python
import experimental.semmle.python.security.dataflow.XmlInjection
import DataFlow::PathGraph

from DataFlow::PathNode source, DataFlow::PathNode sink, string kind
where XmlInjection::xmlInjectionVulnerable(source, sink, kind)
select sink.getNode(), source, sink,
  "$@ XML input is constructed from a $@ and is vulnerable to " + kind + ".", sink.getNode(),
  "This", source.getNode(), "user-provided value"

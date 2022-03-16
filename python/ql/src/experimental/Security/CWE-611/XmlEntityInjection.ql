/**
 * @name XML Entity injection
 * @description User input should not be parsed allowing the injection of entities.
 * @kind path-problem
 * @problem.severity error
 * @id py/xml-entity-injection
 * @tags security
 *       external/cwe/cwe-611
 *       external/cwe/cwe-776
 *       external/cwe/cwe-827
 */

// determine precision above
import python
import experimental.semmle.python.security.dataflow.XmlEntityInjection
import DataFlow::PathGraph

from
  XmlEntityInjection::XmlEntityInjectionConfiguration config, DataFlow::PathNode source,
  DataFlow::PathNode sink, string kinds
where
  config.hasFlowPath(source, sink) and
  kinds =
    strictconcat(string kind |
      kind = sink.getNode().(XmlEntityInjection::Sink).getVulnerableKind()
    |
      kind, ", "
    )
select sink.getNode(), source, sink,
  "$@ XML input is constructed from a $@ and is vulnerable to: " + kinds + ".", sink.getNode(),
  "This", source.getNode(), "user-provided value"

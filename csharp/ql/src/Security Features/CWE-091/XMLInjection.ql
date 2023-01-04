/**
 * @name XML injection
 * @description Building an XML document from user-controlled sources is vulnerable to insertion of
 *              malicious code by the user.
 * @kind path-problem
 * @id cs/xml-injection
 * @problem.severity error
 * @security-severity 8.8
 * @precision high
 * @tags security
 *       external/cwe/cwe-091
 */

import csharp
import DataFlow::PathGraph
import semmle.code.csharp.security.dataflow.flowsources.Remote
import semmle.code.csharp.frameworks.system.Xml

/**
 * A taint-tracking configuration for untrusted user input used in XML.
 */
class TaintTrackingConfiguration extends TaintTracking::Configuration {
  TaintTrackingConfiguration() { this = "XMLInjection" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc |
      mc.getTarget().hasName("WriteRaw") and
      mc.getTarget().getDeclaringType().getABaseType*().hasQualifiedName("System.Xml", "XmlWriter")
    |
      mc.getArgument(0) = sink.asExpr()
    )
  }

  override predicate isSanitizer(DataFlow::Node node) {
    exists(MethodCall mc |
      mc.getTarget().hasName("Escape") and
      mc.getTarget()
          .getDeclaringType()
          .getABaseType*()
          .hasQualifiedName("System.Security", "SecurityElement")
    |
      mc = node.asExpr()
    )
  }
}

from TaintTrackingConfiguration c, DataFlow::PathNode source, DataFlow::PathNode sink
where c.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "This XML element depends on a $@.", source.getNode(),
  "user-provided value"

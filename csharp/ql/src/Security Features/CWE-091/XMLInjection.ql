/**
 * @name XML injection
 * @description Building an XML document from user-controlled sources is vulnerable to insertion of
 *              malicious code by the user.
 * @kind problem
 * @id cs/xml-injection
 * @problem.severity error
 * @precision high
 * @tags security
 *       external/cwe/cwe-091
 */

import csharp
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
      mc.getTarget().getDeclaringType().getABaseType*().hasQualifiedName("System.Xml.XmlWriter")
    |
      mc.getArgument(0) = sink.asExpr()
    )
  }

  override predicate isSanitizer(DataFlow::Node node) {
    exists(MethodCall mc |
      mc.getTarget().hasName("Escape") and
      mc
          .getTarget()
          .getDeclaringType()
          .getABaseType*()
          .hasQualifiedName("System.Security.SecurityElement")
    |
      mc = node.asExpr()
    )
  }
}

from TaintTrackingConfiguration c, DataFlow::Node source, DataFlow::Node sink
where c.hasFlow(source, sink)
select sink, "$@ flows to here and is inserted as XML.", source, "User-provided value"

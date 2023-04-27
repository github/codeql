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
import semmle.code.csharp.security.dataflow.flowsources.Remote
import semmle.code.csharp.frameworks.system.Xml
import XmlInjection::PathGraph

/**
 * A taint-tracking configuration for untrusted user input used in XML.
 */
module XmlInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc |
      mc.getTarget().hasName("WriteRaw") and
      mc.getTarget().getDeclaringType().getABaseType*().hasQualifiedName("System.Xml", "XmlWriter")
    |
      mc.getArgument(0) = sink.asExpr()
    )
  }

  predicate isBarrier(DataFlow::Node node) {
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

/**
 * A taint-tracking module for untrusted user input used in XML.
 */
module XmlInjection = TaintTracking::Global<XmlInjectionConfig>;

from XmlInjection::PathNode source, XmlInjection::PathNode sink
where XmlInjection::flowPath(source, sink)
select sink.getNode(), source, sink, "This XML element depends on a $@.", source.getNode(),
  "user-provided value"

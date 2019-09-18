/**
 * @name Untrusted XML is read insecurely
 * @description Untrusted XML is read with an insecure resolver and DTD processing enabled.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id cs/xml/insecure-dtd-handling
 * @tags security
 *       external/cwe/cwe-611
 *       external/cwe/cwe-827
 *       external/cwe/cwe-776
 */

import csharp
import semmle.code.csharp.security.dataflow.XMLEntityInjection::XMLEntityInjection
import semmle.code.csharp.dataflow.DataFlow::DataFlow::PathGraph

from TaintTrackingConfiguration c, DataFlow::PathNode source, DataFlow::PathNode sink
where c.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "$@ flows to here and is loaded insecurely as XML (" + sink.getNode().(Sink).getReason() + ").",
  source.getNode(), "User-provided value"

/**
 * @name Untrusted XML is read insecurely
 * @description Untrusted XML is read with an insecure resolver and DTD processing enabled.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.1
 * @precision high
 * @id cs/xml/insecure-dtd-handling
 * @tags security
 *       external/cwe/cwe-611
 *       external/cwe/cwe-827
 *       external/cwe/cwe-776
 */

import csharp
import semmle.code.csharp.security.dataflow.XMLEntityInjectionQuery
import semmle.code.csharp.dataflow.DataFlow::DataFlow::PathGraph

from TaintTrackingConfiguration c, DataFlow::PathNode source, DataFlow::PathNode sink
where c.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "This insecure XML processing depends on a $@ (" + sink.getNode().(Sink).getReason() + ").",
  source.getNode(), "user-provided value"

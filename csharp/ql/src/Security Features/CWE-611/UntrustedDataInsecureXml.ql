/**
 * @name Untrusted XML is read insecurely
 * @description Untrusted XML is read with an insecure resolver and DTD processing enabled.
 * @kind problem
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

from TaintTrackingConfiguration c, Source source, Sink sink
where c.hasFlow(source, sink)
select sink, "$@ flows to here and is loaded insecurely as XML (" + sink.getReason() +").", source, "User-provided value"

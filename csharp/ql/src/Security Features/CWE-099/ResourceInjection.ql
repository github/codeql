/**
 * @name Resource injection
 * @description Building a resource descriptor from untrusted user input is vulnerable to a
 *              malicious user providing an unintended resource.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cs/resource-injection
 * @tags security
 *       external/cwe/cwe-099
 */
import csharp
import semmle.code.csharp.security.dataflow.ResourceInjection::ResourceInjection

from TaintTrackingConfiguration c, Source source, Sink sink
where c.hasFlow(source, sink)
select sink, "$@ flows to here and is used in a resource descriptor.", source, "User-provided value"

/**
 * @name XPath injection
 * @description Building an XPath expression from user-controlled sources is vulnerable to insertion of
 *              malicious code by the user.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cs/xml/xpath-injection
 * @tags security
 *       external/cwe/cwe-643
 */
import csharp
import semmle.code.csharp.security.dataflow.XPathInjection::XPathInjection

from TaintTrackingConfiguration c, Source source, Sink sink
where c.hasFlow(source, sink)
select sink, "$@ flows to here and is used in an XPath expression.", source, "User-provided value"

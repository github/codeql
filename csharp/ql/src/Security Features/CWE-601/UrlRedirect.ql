/**
 * @name URL redirection from remote source
 * @description URL redirection based on unvalidated user input
 *              may cause redirection to malicious web sites.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cs/web/unvalidated-url-redirection
 * @tags security
 *       external/cwe/cwe-601
 */
import csharp
import semmle.code.csharp.security.dataflow.UrlRedirect::UrlRedirect

from TaintTrackingConfiguration c, Source source, Sink sink
where c.hasFlow(source, sink)
select sink, "Untrusted URL redirection due to $@.", source, "user-provided value"

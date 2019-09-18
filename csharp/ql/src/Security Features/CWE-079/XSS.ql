/**
 * @name Cross-site scripting
 * @description Writing user input directly to a web page
 *              allows for a cross-site scripting vulnerability.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id cs/web/xss
 * @tags security
 *       external/cwe/cwe-079
 *       external/cwe/cwe-116
 */

import csharp
import semmle.code.csharp.security.dataflow.XSS::XSS
import PathGraph

from XssNode source, XssNode sink, string message
where xssFlow(source, sink, message)
select sink, source, sink, "$@ flows to here and " + message, source, "User-provided value"

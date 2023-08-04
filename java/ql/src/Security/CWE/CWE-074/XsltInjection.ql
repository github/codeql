/**
 * @name XSLT transformation with user-controlled stylesheet
 * @description Performing an XSLT transformation with user-controlled stylesheets can lead to
 *              information disclosure or execution of arbitrary code.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision high
 * @id java/xslt-injection
 * @tags security
 *       external/cwe/cwe-074
 */

import java
import semmle.code.java.security.XsltInjectionQuery
import XsltInjectionFlow::PathGraph

from XsltInjectionFlow::PathNode source, XsltInjectionFlow::PathNode sink
where XsltInjectionFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "XSLT transformation might include stylesheet from $@.",
  source.getNode(), "this user input"

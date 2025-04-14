/**
 * @name Failure to use HTTPS URLs
 * @description Non-HTTPS connections can be intercepted by third parties.
 * @kind path-problem
 * @problem.severity recommendation
 * @security-severity 7.5
 * @precision medium
 * @id java/non-https-url
 * @tags security
 *       external/cwe/cwe-319
 *       external/cwe/cwe-345
 */

import java
import semmle.code.java.security.HttpsUrlsQuery
import HttpStringToUrlOpenMethodFlow::PathGraph

from HttpStringToUrlOpenMethodFlow::PathNode source, HttpStringToUrlOpenMethodFlow::PathNode sink
where HttpStringToUrlOpenMethodFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "URL may have been constructed with HTTP protocol, using $@.",
  source.getNode(), "this HTTP URL"

/**
 * @kind path-problem
 */

import java
import semmle.code.java.security.HttpsUrlsQuery
import codeql.dataflow.test.ProvenancePathGraph
import semmle.code.java.dataflow.ExternalFlow
import ShowProvenance<interpretModelForTest/2, HttpStringToUrlOpenMethodFlow::PathNode, HttpStringToUrlOpenMethodFlow::PathGraph>

from HttpStringToUrlOpenMethodFlow::PathNode source, HttpStringToUrlOpenMethodFlow::PathNode sink
where HttpStringToUrlOpenMethodFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "URL may have been constructed with HTTP protocol, using $@.",
  source.getNode(), "this HTTP URL"

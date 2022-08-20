/**
 * @name URL redirection from remote source
 * @description URL redirection based on unvalidated user input
 *              may cause redirection to malicious web sites.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 6.1
 * @sub-severity low
 * @id rb/url-redirection
 * @tags security
 *       external/cwe/cwe-601
 * @precision high
 */

import ruby
import codeql.ruby.security.UrlRedirectQuery
import codeql.ruby.DataFlow::DataFlow::PathGraph

from Configuration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Untrusted URL redirection due to $@.", source.getNode(),
  "a user-provided value"

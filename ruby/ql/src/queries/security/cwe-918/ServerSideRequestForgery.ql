/**
 * @name Server Side Request Forgery
 * @description Making a request to a URL that is controlled by user input
 *              can allow an attacker to forge requests to internal services.
 * @kind path-problem
 * @problem.severity error
 * @security-severity TODO
 * @precision medium
 * @id rb/server-side-request-forgery
 * @tags security
 *       external/cwe/cwe-918
 */

import ruby
import codeql.ruby.Concepts
import codeql.ruby.DataFlow
import codeql.ruby.TaintTracking
import codeql.ruby.dataflow.RemoteFlowSources
import codeql.ruby.security.ServerSideRequestForgeryQuery

from Configuration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Untrusted HTTP request due to $@.", source.getNode(),
  "a user-provided value"

/**
 * @name Making a request to untrusted input
 * @description By using user-controlled data in requests, attackers can make it appear that the server is sending the request, possibly bypassing access controls such as firewalls that prevent the attackers from accessing the URLs directly. The server can be used as a proxy to conduct port scanning of hosts in internal networks, use other URLs such as that can access documents on the system (using file://), or use other protocols such as gopher:// or tftp://, which may provide greater control over the contents of requests. 
 * @kind path-problem
 * @id py/request-forgery
 * @problem.severity error
 * @sub-severity high
 * @precision high
 * @tags external/cwe/cwe-918
 *       security
 */

import semmle.python.web.HttpRequest
import semmle.python.security.Paths

import semmle.python.security.TaintTracking

import semmle.python.security.strings.Untrusted

import semmle.python.security.injection.Urllib
import semmle.python.security.injection.Requests
import semmle.python.security.injection.Httplib

class SSRFConfiguration  extends TaintTracking::Configuration {

    SSRFConfiguration() { this = "SSRF injection configuration" }

    override predicate isSource(TaintTracking::Source source) { source instanceof HttpRequestTaintSource }

    override predicate isSink(TaintTracking::Sink sink) { sink instanceof SSRFSink }

}

from SSRFConfiguration config, TaintedPathSource src, TaintedPathSink sink
where config.hasFlowPath(src, sink)
select sink.getSink(), src, sink, "Making a request to host of $@.", src.getSource(), "untrusted input"

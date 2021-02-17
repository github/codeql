/**
 * @name URL redirection from remote source
 * @description URL redirection based on unvalidated user input
 *              may cause redirection to malicious web sites.
 * @kind path-problem
 * @problem.severity error
 * @sub-severity low
 * @id py/url-redirection
 * @tags security
 *       external/cwe/cwe-601
 * @precision high
 */

import python
import semmle.python.security.Paths
import semmle.python.web.HttpRedirect
import semmle.python.web.HttpRequest
import semmle.python.security.strings.Untrusted

/** Url redirection is a problem only if the user controls the prefix of the URL */
class UntrustedPrefixStringKind extends UntrustedStringKind {
  override TaintKind getTaintForFlowStep(ControlFlowNode fromnode, ControlFlowNode tonode) {
    result = UntrustedStringKind.super.getTaintForFlowStep(fromnode, tonode) and
    not tonode.(BinaryExprNode).getRight() = fromnode
  }
}

class UrlRedirectConfiguration extends TaintTracking::Configuration {
  UrlRedirectConfiguration() { this = "URL redirect configuration" }

  override predicate isSource(TaintTracking::Source source) {
    source instanceof HttpRequestTaintSource
  }

  override predicate isSink(TaintTracking::Sink sink) { sink instanceof HttpRedirectTaintSink }
}

from UrlRedirectConfiguration config, TaintedPathSource src, TaintedPathSink sink
where config.hasFlowPath(src, sink)
select sink.getSink(), src, sink, "Untrusted URL redirection due to $@.", src.getSource(),
  "a user-provided value"

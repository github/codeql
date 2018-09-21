/**
 * @name Host header poisoning in email generation
 * @description Using the HTTP Host header to construct a link in an email can facilitate phishing attacks and leak password reset tokens.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id js/host-header-forgery-in-email-generation
 * @tags security
 *       external/cwe/cwe-640
 */
import javascript

class TaintedHostHeader extends TaintTracking::Configuration {
  TaintedHostHeader() { this = "TaintedHostHeader" }

  override predicate isSource(DataFlow::Node node) {
    exists (HTTP::RequestInputAccess input | node = input |
      input.getKind() = "header" and
      input.getAHeaderName() = "host")
  }

  override predicate isSink(DataFlow::Node node) {
    exists (EmailSender email | node = email.getABody())
  }
}

from TaintedHostHeader taint, DataFlow::Node src, DataFlow::Node sink
where taint.hasFlow(src, sink)
select sink, "Links in this email can be hijacked by poisoning the HTTP host header $@.", src, "here"

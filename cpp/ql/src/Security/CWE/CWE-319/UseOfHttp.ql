/**
 * @name Failure to use HTTPS URLs
 * @description Non-HTTPS connections can be intercepted by third parties.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 8.1
 * @precision high
 * @id cpp/non-https-url
 * @tags security
 *       external/cwe/cwe-319
 *       external/cwe/cwe-345
 */

import cpp
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.valuenumbering.GlobalValueNumbering
import HttpStringToUrlOpen::PathGraph

/**
 * A string matching private host names of IPv4 and IPv6, which only matches
 * the host portion therefore checking for port is not necessary.
 * Several examples are localhost, reserved IPv4 IP addresses including
 * 127.0.0.1, 10.x.x.x, 172.16.x,x, 192.168.x,x, and reserved IPv6 addresses
 * including [0:0:0:0:0:0:0:1] and [::1]
 */
class PrivateHostName extends string {
  bindingset[this]
  PrivateHostName() {
    this.regexpMatch("(?i)localhost(?:[:/?#].*)?|127\\.0\\.0\\.1(?:[:/?#].*)?|10(?:\\.[0-9]+){3}(?:[:/?#].*)?|172\\.16(?:\\.[0-9]+){2}(?:[:/?#].*)?|192.168(?:\\.[0-9]+){2}(?:[:/?#].*)?|\\[?0:0:0:0:0:0:0:1\\]?(?:[:/?#].*)?|\\[?::1\\]?(?:[:/?#].*)?")
  }
}

pragma[nomagic]
predicate privateHostNameFlowsToExpr(Expr e) {
  TaintTracking::localExprTaint(any(StringLiteral p | p.getValue() instanceof PrivateHostName), e)
}

/**
 * A string containing an HTTP URL not in a private domain.
 */
class HttpStringLiteral extends StringLiteral {
  HttpStringLiteral() {
    exists(string s | this.getValue() = s |
      s = "http"
      or
      exists(string tail |
        tail = s.regexpCapture("http://(.*)", 1) and not tail instanceof PrivateHostName
      )
    ) and
    not privateHostNameFlowsToExpr(this.getParent*())
  }
}

/**
 * Taint tracking configuration for HTTP connections.
 */
module HttpStringToUrlOpenConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) {
    // Sources are strings containing an HTTP URL not in a private domain.
    src.asIndirectExpr() instanceof HttpStringLiteral and
    // block taint starting at `strstr`, which is likely testing an existing URL, rather than constructing an HTTP URL.
    not exists(FunctionCall fc |
      fc.getTarget().getName() = ["strstr", "strcasestr"] and
      fc.getArgument(1) = globalValueNumber(src.asIndirectExpr()).getAnExpr()
    )
  }

  predicate isSink(DataFlow::Node sink) {
    // Sinks can be anything that demonstrates the string is likely to be
    // accessed as a URL, for example using it in a network access. Some
    // URLs are only ever displayed or used for data processing.
    exists(FunctionCall fc |
      fc.getTarget()
          .hasGlobalOrStdName([
              "system", "gethostbyname", "gethostbyname2", "gethostbyname_r", "getaddrinfo",
              "X509_load_http", "X509_CRL_load_http"
            ]) and
      sink.asIndirectExpr() = fc.getArgument(0)
      or
      fc.getTarget().hasGlobalOrStdName(["send", "URLDownloadToFile", "URLDownloadToCacheFile"]) and
      sink.asIndirectExpr() = fc.getArgument(1)
      or
      fc.getTarget().hasGlobalOrStdName(["curl_easy_setopt", "getnameinfo"]) and
      sink.asIndirectExpr() = fc.getArgument(2)
      or
      fc.getTarget().hasGlobalOrStdName(["ShellExecute", "ShellExecuteA", "ShellExecuteW"]) and
      sink.asIndirectExpr() = fc.getArgument(3)
    )
  }
}

module HttpStringToUrlOpen = TaintTracking::Global<HttpStringToUrlOpenConfig>;

from HttpStringToUrlOpen::PathNode source, HttpStringToUrlOpen::PathNode sink, HttpStringLiteral str
where
  HttpStringToUrlOpen::flowPath(source, sink) and
  str = source.getNode().asIndirectExpr()
select str, source, sink, "This URL may be constructed with the HTTP protocol."

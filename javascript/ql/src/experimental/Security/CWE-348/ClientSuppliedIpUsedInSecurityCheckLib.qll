private import javascript
private import DataFlow::PathGraph
private import semmle.javascript.dataflow.DataFlow

/**
 * A data flow source of the client ip obtained according to the remote endpoint identifier specified
 * (`X-Forwarded-For`, `X-Real-IP`, `Proxy-Client-IP`, etc.) in the header.
 *
 * For example: `req.headers["X-Forwarded-For"]`.
 */
abstract class ClientSuppliedIp extends DataFlow::Node { }

private class GenericClientSuppliedIp extends ClientSuppliedIp {
  GenericClientSuppliedIp() {
    exists(DataFlow::SourceNode source, DataFlow::PropRead read |
      this.(RemoteFlowSource).getSourceType() = "Server request header" and source = this
    |
      read.getPropertyName().toLowerCase() = clientIpParameterName() and
      source.flowsTo(read)
    )
  }
}

private string clientIpParameterName() {
  result in [
      "x-forwarded-for", "x_forwarded_for", "x-real-ip", "x_real_ip", "proxy-client-ip",
      "proxy_client_ip", "wl-proxy-client-ip", "wl_proxy_client_ip", "http_x_forwarded_for",
      "http-x-forwarded-for", "http_x_forwarded", "http_x_cluster_client_ip", "http_client_ip",
      "http_forwarded_for", "http_forwarded", "http_via", "remote_addr"
    ]
}

/** A data flow sink for ip address forgery vulnerabilities. */
abstract class PossibleSecurityCheck extends DataFlow::Node { }

/**
 * A data flow sink for remote client ip comparison.
 *
 * For example: `if !ip.startsWith("10.")` determine whether the client ip starts
 * with `10.`, and the program can be deceived by forging the ip address.
 */
private class CompareSink extends PossibleSecurityCheck {
  CompareSink() {
    // ip.startsWith("10.") or ip.includes("10.")
    exists(CallExpr call |
      call.getAChild() = this.asExpr() and
      call.getCalleeName() in ["startsWith", "includes"] and
      call.getArgument(0).getStringValue().regexpMatch(getIpAddressRegex()) and
      not call.getArgument(0).getStringValue() = "0:0:0:0:0:0:0:1"
    )
    or
    // ip === "127.0.0.1" or ip !== "127.0.0.1" or ip == "127.0.0.1" or or ip != "127.0.0.1"
    exists(Comparison compare |
      compare instanceof EqualityTest and
      (
        [compare, compare.getAnOperand()] = this.asExpr() and
        compare.getAnOperand().getStringValue() instanceof PrivateHostName and
        not compare.getAnOperand().getStringValue() = "0:0:0:0:0:0:0:1"
      )
    )
  }
}

string getIpAddressRegex() {
  result =
    "^((10\\.((1\\d{2})?|(2[0-4]\\d)?|(25[0-5])?|([1-9]\\d|[0-9])?)(\\.)?)|(192\\.168\\.)|172\\.(1[6789]|2[0-9]|3[01])\\.)((1\\d{2})?|(2[0-4]\\d)?|(25[0-5])?|([1-9]\\d|[0-9])?)(\\.)?((1\\d{2})?|(2[0-4]\\d)?|(25[0-5])?|([1-9]\\d|[0-9])?)$"
}

/**
 * A string matching private host names of IPv4 and IPv6, which only matches the host portion therefore checking for port is not necessary.
 * Several examples are localhost, reserved IPv4 IP addresses including 127.0.0.1, 10.x.x.x, 172.16.x,x, 192.168.x,x, and reserved IPv6 addresses including [0:0:0:0:0:0:0:1] and [::1]
 */
private class PrivateHostName extends string {
  bindingset[this]
  PrivateHostName() {
    this.regexpMatch("(?i)localhost(?:[:/?#].*)?|127\\.0\\.0\\.1(?:[:/?#].*)?|10(?:\\.[0-9]+){3}(?:[:/?#].*)?|172\\.16(?:\\.[0-9]+){2}(?:[:/?#].*)?|192.168(?:\\.[0-9]+){2}(?:[:/?#].*)?|\\[?0:0:0:0:0:0:0:1\\]?(?:[:/?#].*)?|\\[?::1\\]?(?:[:/?#].*)?")
  }
}

private import semmle.code.csharp.security.dataflow.flowsources.Remote
private import semmle.code.csharp.frameworks.microsoft.AspNetCore
private import semmle.code.csharp.frameworks.System
private import semmle.code.csharp.security.dataflow.SqlInjectionQuery

/** A data flow source for ip address forgery vulnerabilities. */
abstract class ClientSuppliedIpUsedInSecurityCheckSource extends DataFlow::Node { }

/** A data flow sink for ip address forgery vulnerabilities. */
abstract class ClientSuppliedIpUsedInSecurityCheckSink extends DataFlow::ExprNode { }

/** A data flow sanitizer for ip address forgery vulnerabilities. */
abstract class ClientSuppliedIpUsedInSecurityCheckSanitizer extends DataFlow::ExprNode { }

/**
 * A data flow source of the client ip obtained according to the remote endpoint identifier specified
 * (`X-Forwarded-For`, `X-Real-IP`, `Proxy-Client-IP`, etc.) in the header.
 *
 * For example: `Request.Headers["X-Forwarded-For"]` or `request.ServerVariables["HTTP_X_FORWARDED_FOR"]`.
 */
private class AspNetQueryStringSource extends ClientSuppliedIpUsedInSecurityCheckSource,
  DataFlow::ExprNode {
  AspNetQueryStringSource() {
    exists(RemoteFlowSource rfs, RefType rt, IndexerAccess ia, Call c |
      rfs.getSourceType() in [
          "ASP.NET Core query string", "ASP.NET query string", "ASP.NET web service input"
        ] and
      this.getExpr() = c
    |
      rfs.asExpr() = ia.getQualifier() and
      ia.getTarget() = rt.getAnIndexer() and
      c.getTarget() = rt.getAnIndexer().getGetter() and
      c.getArgument(0).(StringLiteral).getValue().toLowerCase() = clientIpParameterName()
    )
  }
}

/**
 * A data flow source of the client ip obtained according to the remote endpoint identifier specified
 * (`X-Forwarded-For`, `X-Real-IP`, `Proxy-Client-IP`, etc.) in the header.
 *
 * For example: `[FromHeader(Name = "X-Forwarded-For")]`.
 */
private class AspNetCoreActionMethodParameterSource extends ClientSuppliedIpUsedInSecurityCheckSource,
  DataFlow::ParameterNode {
  AspNetCoreActionMethodParameterSource() {
    exists(RemoteFlowSource rfs, Parameter p |
      rfs.getSourceType() = "ASP.NET Core MVC action method parameter" and
      this.getParameter() = p
    |
      rfs.asParameter() = p and
      p.getAnAttribute().getType().hasQualifiedName("Microsoft.AspNetCore.Mvc.FromHeaderAttribute") and
      p.getAnAttribute().getNamedArgument("Name").(StringLiteral).getValue().toLowerCase() =
        clientIpParameterName()
    )
  }
}

/**
 * A data flow source of the client ip obtained according to the remote endpoint identifier specified
 * (`X-Forwarded-For`, `X-Real-IP`, `Proxy-Client-IP`, etc.) in the header.
 *
 * For example: `Request.Headers.TryGetValue("X-Forwarded-For", out var xHeader)`.
 */
private class AspNetCoreQueryStringSource extends ClientSuppliedIpUsedInSecurityCheckSource,
  DataFlow::ExprNode {
  AspNetCoreQueryStringSource() {
    exists(RemoteFlowSource rfs, MethodCall mc |
      rfs.getSourceType() = "ASP.NET Core query string" and
      this.getExpr() = mc
    |
      rfs.asExpr() = mc.getQualifier() and
      mc.getArgument(0).(StringLiteral).getValue().toLowerCase() = clientIpParameterName()
    )
  }
}

/**
 * A data flow sink for remote client ip comparison.
 *
 * For example: `if (!ip.StartsWith("192.168."))` determine whether the client ip starts
 * with `192.168.`, and the program can be deceived by forging the ip address.
 */
private class CompareSink extends ClientSuppliedIpUsedInSecurityCheckSink {
  CompareSink() {
    exists(MethodCall mc |
      mc.getTarget().hasQualifiedName("System.String", ["Equals", "Contains"]) and
      mc.getTarget().getDeclaringType() instanceof StringType and
      (
        // ip.Equals("127.0.0.1")
        this.getExpr() = mc.getQualifier() and
        mc.getArgument(0).getValue() instanceof PrivateHostName and
        not mc.getArgument(0).getValue() = "0:0:0:0:0:0:0:1"
        or
        // "127.0.0.1".Equals(ip)
        this.getExpr() = mc.getArgument(0) and
        mc.getQualifier().(StringLiteral).getValue() instanceof PrivateHostName and
        not mc.getQualifier().(StringLiteral).getValue() = "0:0:0:0:0:0:0:1"
      )
    )
    or
    exists(ComparisonOperation co |
      (co instanceof EQExpr or co instanceof NEExpr) and
      this.getExpr() = co and
      if co.getRightOperand().hasValue()
      then (
        // ip == "127.0.0.1"
        co.getRightOperand().getType() instanceof StringType and
        co.getRightOperand().(StringLiteral).getValue() instanceof PrivateHostName and
        not co.getRightOperand().(StringLiteral).getValue() = "0:0:0:0:0:0:0:1"
      ) else (
        // "127.0.0.1" == ip
        co.getLeftOperand().getType() instanceof StringType and
        co.getLeftOperand().(StringLiteral).getValue() instanceof PrivateHostName and
        not co.getLeftOperand().(StringLiteral).getValue() = "0:0:0:0:0:0:0:1"
      )
    )
    or
    exists(MethodCall mc |
      mc.getTarget().hasQualifiedName("System.String", ["StartsWith", "Contains"]) and
      mc.getTarget().getDeclaringType() instanceof StringType and
      (
        // ip.StartsWith("192.168.")
        this.getExpr() = mc.getQualifier() and
        mc.getArgument(0).(StringLiteral).getValue().regexpMatch(getIpAddressRegex())
        or
        // "192.168.".StartsWith(ip)
        this.getExpr() = mc.getArgument(0) and
        mc.getQualifier().(StringLiteral).getValue().regexpMatch(getIpAddressRegex())
      )
    )
  }
}

/** A data flow sink for sql operation. */
private class SqlOperationSink extends ClientSuppliedIpUsedInSecurityCheckSink {
  SqlOperationSink() { this instanceof SqlInjectionExprSink }
}

/**
 * Splitting a header value by `,` and taking an entry other than the first is sanitizing, because
 * later entries may originate from more-trustworthy intermediate proxies, not the original client.
 */
private class SplitMethodSanitizer extends ClientSuppliedIpUsedInSecurityCheckSanitizer {
  SplitMethodSanitizer() {
    // Split(',')[0]
    exists(ArrayAccess aa, MethodCall mc, SystemStringClass s |
      this.getExpr() = aa.getQualifier() and
      mc = aa.getQualifier() and
      mc.getTarget() = s.getSplitMethod() and
      not aa.getAnIndex().(IntLiteral).getValue() = "0"
    )
    or
    // Split(',').FirstOrDefault()
    exists(MethodCall mc, SystemStringClass s |
      this.getExpr() = mc and
      mc.getTarget() instanceof ExtensionMethod and
      mc.getArgument(0).(MethodCall).getTarget() = s.getSplitMethod() and
      not mc.getTarget()
          .hasQualifiedName("System.Linq.Enumerable",
            ["FirstOrDefault<System.String>", "First<System.String>"])
    )
  }
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

string clientIpParameterName() {
  result in [
      "x-forwarded-for", "x-real-ip", "proxy-client-ip", "wl-proxy-client-ip",
      "http_x_forwarded_for", "http_x_forwarded", "http_x_cluster_client_ip", "http_client_ip",
      "http_forwarded_for", "http_forwarded", "http_via", "remote_addr"
    ]
}

string getIpAddressRegex() {
  result =
    "^((10\\.((1\\d{2})?|(2[0-4]\\d)?|(25[0-5])?|([1-9]\\d|[0-9])?)(\\.)?)|(192\\.168\\.)|172\\.(1[6789]|2[0-9]|3[01])\\.)((1\\d{2})?|(2[0-4]\\d)?|(25[0-5])?|([1-9]\\d|[0-9])?)(\\.)?((1\\d{2})?|(2[0-4]\\d)?|(25[0-5])?|([1-9]\\d|[0-9])?)$"
}

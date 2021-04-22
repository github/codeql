import java
import DataFlow
import semmle.code.java.security.QueryInjection
import experimental.semmle.code.java.Logging

/**
 * A data flow source of the client ip obtained according to the remote endpoint identifier specified
 * (`X-Forwarded-For`, `X-Real-IP`, `Proxy-Client-IP`, etc.) in the header.
 *
 * For example: `ServletRequest.getHeader("X-Forwarded-For")`.
 */
class UseOfLessTrustedSource extends DataFlow::Node {
  UseOfLessTrustedSource() {
    exists(MethodAccess ma |
      ma.getMethod().hasName("getHeader") and
      ma.getArgument(0).(CompileTimeConstantExpr).getStringValue().toLowerCase() in [
          "x-forwarded-for", "x-real-ip", "proxy-client-ip", "wl-proxy-client-ip",
          "http_x_forwarded_for", "http_x_forwarded", "http_x_cluster_client_ip", "http_client_ip",
          "http_forwarded_for", "http_forwarded", "http_via", "remote_addr"
        ] and
      ma = this.asExpr()
    )
  }
}

/** A data flow sink for ip address forgery vulnerabilities. */
abstract class UseOfLessTrustedSink extends DataFlow::Node { }

/**
 * A data flow sink for remote client ip comparison.
 *
 * For example: `if (!StringUtils.startsWith(ipAddr, "192.168.")){...` determine whether the client ip starts
 * with `192.168.`, and the program can be deceived by forging the ip address.
 */
private class CompareSink extends UseOfLessTrustedSink {
  CompareSink() {
    exists(MethodAccess ma |
      ma.getMethod().getName() in ["equals", "equalsIgnoreCase"] and
      ma.getMethod().getDeclaringType() instanceof TypeString and
      ma.getMethod().getNumberOfParameters() = 1 and
      (
        ma.getArgument(0) = this.asExpr() and
        not ma.getQualifier().(CompileTimeConstantExpr).getStringValue().toLowerCase() in [
            "", "unknown", ":"
          ]
        or
        ma.getQualifier() = this.asExpr() and
        not ma.getArgument(0).(CompileTimeConstantExpr).getStringValue().toLowerCase() in [
            "", "unknown", ":"
          ]
      )
    )
    or
    exists(MethodAccess ma |
      ma.getMethod().getName() in ["contains", "startsWith"] and
      ma.getMethod().getDeclaringType() instanceof TypeString and
      ma.getMethod().getNumberOfParameters() = 1 and
      ma.getQualifier() = this.asExpr() and
      not ma.getArgument(0).(CompileTimeConstantExpr).getStringValue().toLowerCase() in [
          "", "unknown"
        ]
    )
    or
    exists(MethodAccess ma |
      ma.getMethod().hasName("startsWith") and
      ma.getMethod()
          .getDeclaringType()
          .hasQualifiedName(["org.apache.commons.lang3", "org.apache.commons.lang"], "StringUtils") and
      ma.getMethod().getNumberOfParameters() = 2 and
      ma.getAnArgument() = this.asExpr() and
      ma.getAnArgument().(CompileTimeConstantExpr).getStringValue() != ""
    )
    or
    exists(MethodAccess ma |
      ma.getMethod().getName() in ["equals", "equalsIgnoreCase"] and
      ma.getMethod()
          .getDeclaringType()
          .hasQualifiedName(["org.apache.commons.lang3", "org.apache.commons.lang"], "StringUtils") and
      ma.getMethod().getNumberOfParameters() = 2 and
      ma.getAnArgument() = this.asExpr() and
      not ma.getAnArgument().(CompileTimeConstantExpr).getStringValue().toLowerCase() in [
          "", "unknown", ":"
        ]
    )
  }
}

/** A data flow sink for sql operation. */
private class SqlOperationSink extends UseOfLessTrustedSink {
  SqlOperationSink() { this instanceof QueryInjectionSink }
}

/** A data flow sink for log operation. */
private class LogOperationSink extends UseOfLessTrustedSink {
  LogOperationSink() { exists(LoggingCall lc | lc.getAnArgument() = this.asExpr()) }
}

/** A data flow sink for local output. */
private class PrintSink extends UseOfLessTrustedSink {
  PrintSink() {
    exists(MethodAccess ma |
      ma.getMethod().getName() in ["print", "println"] and
      ma.getMethod().getDeclaringType().hasQualifiedName("java.io", ["PrintWriter", "PrintStream"]) and
      ma.getAnArgument() = this.asExpr()
    )
  }
}

/** A method that split string. */
class SplitMethod extends Method {
  SplitMethod() {
    this.getNumberOfParameters() = 1 and
    this.hasQualifiedName("java.lang", "String", "split")
  }
}

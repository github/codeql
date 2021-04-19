import java
import DataFlow
import semmle.code.java.dataflow.TaintTracking2
import semmle.code.java.security.QueryInjection
import experimental.semmle.code.java.Logging

/**
 * A data flow source of the client ip obtained according to the remote endpoint identifier specified
 * in the header (`X-Forwarded-For`, `X-Real-IP`, `Proxy-Client-IP`, etc.).
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
 * A data flow sink for the if condition, which does not include the null judgment of the remote client ip address.
 *
 * For example: `if (!StringUtils.startsWith(ipAddr, "192.168.")){...` determine whether the client ip starts
 * with `192.168.`, and the program can be deceived by forging the ip address.
 * `if (remoteAddr == null || "".equals(remoteAddr)) {...` judging whether the client ip is a null value,
 * it needs to be excluded
 */
private class IfConditionSink extends UseOfLessTrustedSink {
  IfConditionSink() {
    exists(IfStmt is |
      is.getCondition() = this.asExpr() and
      not exists(EQExpr eqe |
        eqe.getAnOperand() instanceof NullLiteral and
        is.getCondition() = eqe.getParent*()
      ) and
      not exists(NEExpr nee |
        nee.getAnOperand() instanceof NullLiteral and
        is.getCondition() = nee.getParent*()
      ) and
      not exists(MethodAccess ma |
        ma.getMethod().hasName("equals") and
        ma.getMethod().getNumberOfParameters() = 1 and
        (
          ma.getQualifier().(CompileTimeConstantExpr).getStringValue() = "" or
          ma.getArgument(0).(CompileTimeConstantExpr).getStringValue() = ""
        ) and
        is.getCondition() = ma.getParent*()
      ) and
      not exists(MethodAccess ma |
        ma.getMethod().hasName("equalsIgnoreCase") and
        ma.getMethod().getNumberOfParameters() = 1 and
        (
          ma.getQualifier().(CompileTimeConstantExpr).getStringValue() = "unknown" or
          ma.getArgument(0).(CompileTimeConstantExpr).getStringValue() = "unknown"
        ) and
        is.getCondition() = ma.getParent*()
      ) and
      not exists(MethodAccess ma |
        ma.getMethod().getName() in ["isEmpty", "isNotEmpty"] and
        ma.getMethod().getNumberOfParameters() = 1 and
        is.getCondition() = ma.getParent*()
      ) and
      not exists(MethodAccess ma |
        (
          ma.getMethod().hasQualifiedName("org.apache.commons.lang3", "StringUtils", "isBlank") or
          ma.getMethod().hasQualifiedName("org.apache.commons.lang3", "StringUtils", "isNotBlank")
        ) and
        is.getCondition() = ma.getParent*()
      ) and
      not exists(MethodAccess ma |
        ma.getMethod()
            .hasQualifiedName("org.apache.commons.lang3", "StringUtils", "equalsIgnoreCase") and
        ma.getAnArgument().(CompileTimeConstantExpr).getStringValue() = "unknown" and
        is.getCondition() = ma.getParent*()
      )
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
      (
        ma.getMethod().getDeclaringType().hasQualifiedName("java.io", "PrintWriter") or
        ma.getMethod().getDeclaringType().hasQualifiedName("java.io", "PrintStream")
      ) and
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

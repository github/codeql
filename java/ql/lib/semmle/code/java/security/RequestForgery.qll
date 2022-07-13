/** Provides classes to reason about server-side request forgery (SSRF) attacks. */

import java
import semmle.code.java.frameworks.Networking
import semmle.code.java.frameworks.ApacheHttp
import semmle.code.java.frameworks.spring.Spring
import semmle.code.java.frameworks.JaxWS
import semmle.code.java.frameworks.javase.Http
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.frameworks.Properties
private import semmle.code.java.dataflow.StringPrefixes
private import semmle.code.java.dataflow.ExternalFlow

/**
 * A unit class for adding additional taint steps that are specific to server-side request forgery (SSRF) attacks.
 *
 * Extend this class to add additional taint steps to the SSRF query.
 */
class RequestForgeryAdditionalTaintStep extends Unit {
  /**
   * Holds if the step from `pred` to `succ` should be considered a taint
   * step for server-side request forgery.
   */
  abstract predicate propagatesTaint(DataFlow::Node pred, DataFlow::Node succ);
}

private class DefaultRequestForgeryAdditionalTaintStep extends RequestForgeryAdditionalTaintStep {
  override predicate propagatesTaint(DataFlow::Node pred, DataFlow::Node succ) {
    // propagate to a URI when its host is assigned to
    exists(UriCreation c | c.getHostArg() = pred.asExpr() | succ.asExpr() = c)
    or
    // propagate to a URL when its host is assigned to
    exists(UrlConstructorCall c | c.getHostArg() = pred.asExpr() | succ.asExpr() = c)
  }
}

private class TypePropertiesRequestForgeryAdditionalTaintStep extends RequestForgeryAdditionalTaintStep {
  override predicate propagatesTaint(DataFlow::Node pred, DataFlow::Node succ) {
    exists(MethodAccess ma |
      // Properties props = new Properties();
      // props.setProperty("jdbcUrl", tainted);
      // Propagate tainted value to the qualifier `props`
      ma.getMethod() instanceof PropertiesSetPropertyMethod and
      ma.getArgument(0).(CompileTimeConstantExpr).getStringValue() = "jdbcUrl" and
      pred.asExpr() = ma.getArgument(1) and
      succ.asExpr() = ma.getQualifier()
    )
  }
}

/** A data flow sink for server-side request forgery (SSRF) vulnerabilities. */
abstract class RequestForgerySink extends DataFlow::Node { }

private class UrlOpenSinkAsRequestForgerySink extends RequestForgerySink {
  UrlOpenSinkAsRequestForgerySink() { sinkNode(this, "open-url") }
}

private class JdbcUrlSinkAsRequestForgerySink extends RequestForgerySink {
  JdbcUrlSinkAsRequestForgerySink() { sinkNode(this, "jdbc-url") }
}

/** A sanitizer for request forgery vulnerabilities. */
abstract class RequestForgerySanitizer extends DataFlow::Node { }

private class PrimitiveSanitizer extends RequestForgerySanitizer {
  PrimitiveSanitizer() {
    this.getType() instanceof PrimitiveType or
    this.getType() instanceof BoxedType or
    this.getType() instanceof NumberType
  }
}

private class HostnameSanitizingPrefix extends InterestingPrefix {
  int offset;

  HostnameSanitizingPrefix() {
    // Matches strings that look like when prepended to untrusted input, they will restrict
    // the host or entity addressed: for example, anything containing `?` or `#`, or a slash that
    // doesn't appear to be a protocol specifier (e.g. `http://` is not sanitizing), or specifically
    // the string "/".
    exists(
      this.getStringValue()
          .regexpFind(".*([?#]|[^?#:/\\\\][/\\\\]).*|[/\\\\][^/\\\\].*|^/$", 0, offset)
    )
  }

  override int getOffset() { result = offset }
}

/**
 * A value that is the result of prepending a string that prevents any value from controlling the
 * host of a URL.
 */
private class HostnameSantizer extends RequestForgerySanitizer {
  HostnameSantizer() { this.asExpr() = any(HostnameSanitizingPrefix hsp).getAnAppendedExpression() }
}

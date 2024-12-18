/** Provides classes to reason about server-side request forgery (SSRF) attacks. */

import java
import semmle.code.java.frameworks.Networking
import semmle.code.java.frameworks.ApacheHttp
import semmle.code.java.frameworks.spring.Spring
import semmle.code.java.frameworks.JaxWS
import semmle.code.java.frameworks.javase.Http
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.frameworks.Properties
private import semmle.code.java.controlflow.Guards
private import semmle.code.java.dataflow.StringPrefixes
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.security.Sanitizers

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

private class TypePropertiesRequestForgeryAdditionalTaintStep extends RequestForgeryAdditionalTaintStep
{
  override predicate propagatesTaint(DataFlow::Node pred, DataFlow::Node succ) {
    exists(MethodCall ma |
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

private class DefaultRequestForgerySink extends RequestForgerySink {
  DefaultRequestForgerySink() { sinkNode(this, "request-forgery") }
}

/** A sanitizer for request forgery vulnerabilities. */
abstract class RequestForgerySanitizer extends DataFlow::Node { }

private class PrimitiveSanitizer extends RequestForgerySanitizer instanceof SimpleTypeSanitizer { }

/**
 * A string constant that contains a prefix which looks like when it is prepended to untrusted
 * input, it will restrict the host or entity addressed.
 *
 * For example, anything containing `?` or `#`, or a slash that doesn't appear to be a protocol
 * specifier (e.g. `http://` is not sanitizing), or specifically the string "/".
 */
class HostnameSanitizingPrefix extends InterestingPrefix {
  int offset;

  HostnameSanitizingPrefix() {
    exists(this.getStringValue().regexpFind("([?#]|[^?#:/\\\\][/\\\\])|^/$", 0, offset))
  }

  override int getOffset() { result = offset }
}

/**
 * A value that is the result of prepending a string that prevents any value from controlling the
 * host of a URL.
 */
private class HostnameSanitizer extends RequestForgerySanitizer {
  HostnameSanitizer() {
    this.asExpr() = any(HostnameSanitizingPrefix hsp).getAnAppendedExpression()
  }
}

/**
 * An argument to a call to a `.contains()` method that is a sanitizer for URL redirects.
 *
 * Matches any method call where the method is named `contains`.
 */
private predicate isContainsUrlSanitizer(Guard guard, Expr e, boolean branch) {
  guard =
    any(MethodCall method |
      method.getMethod().getName() = "contains" and
      e = method.getArgument(0) and
      branch = true
    )
}

/**
 * An URL argument to a call to `.contains()` that is a sanitizer for URL redirects.
 *
 * This `contains` method is usually called on a list, but the sanitizer matches any call to a method
 * called `contains`, so other methods with the same name will also be considered sanitizers.
 */
private class ContainsUrlSanitizer extends RequestForgerySanitizer {
  ContainsUrlSanitizer() {
    this = DataFlow::BarrierGuard<isContainsUrlSanitizer/3>::getABarrierNode()
  }
}

/**
 * A check that the URL is relative, and therefore safe for URL redirects.
 */
private predicate isRelativeUrlSanitizer(Guard guard, Expr e, boolean branch) {
  guard =
    any(MethodCall call |
      call.getMethod().hasQualifiedName("java.net", "URI", "isAbsolute") and
      e = call.getQualifier() and
      branch = false
    )
}

/**
 * A check that the URL is relative, and therefore safe for URL redirects.
 */
private class RelativeUrlSanitizer extends RequestForgerySanitizer {
  RelativeUrlSanitizer() {
    this = DataFlow::BarrierGuard<isRelativeUrlSanitizer/3>::getABarrierNode()
  }
}

/**
 * A comparison on the host of a url, that is a sanitizer for URL redirects.
 * E.g. `"example.org".equals(url.getHost())"`
 */
private predicate isHostComparisonSanitizer(Guard guard, Expr e, boolean branch) {
  guard =
    any(MethodCall equalsCall |
      equalsCall.getMethod().getName() = "equals" and
      branch = true and
      exists(MethodCall hostCall |
        hostCall = [equalsCall.getQualifier(), equalsCall.getArgument(0)] and
        hostCall.getMethod().hasQualifiedName("java.net", "URI", "getHost") and
        e = hostCall.getQualifier()
      )
    )
}

/**
 * A comparison on the `Host` property of a url, that is a sanitizer for URL redirects.
 */
private class HostComparisonSanitizer extends RequestForgerySanitizer {
  HostComparisonSanitizer() {
    this = DataFlow::BarrierGuard<isHostComparisonSanitizer/3>::getABarrierNode()
  }
}

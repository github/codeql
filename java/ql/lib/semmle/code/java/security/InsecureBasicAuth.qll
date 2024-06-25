/** Provides classes and predicates to reason about Insecure Basic Authentication vulnerabilities. */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.HttpsUrls
private import semmle.code.java.dataflow.FlowSinks

/**
 * A source that represents HTTP URLs.
 * Extend this class to add your own Insecure Basic Authentication sources.
 */
abstract class InsecureBasicAuthSource extends DataFlow::Node { }

/** A default source representing HTTP strings, URLs or URIs. */
private class DefaultInsecureBasicAuthSource extends InsecureBasicAuthSource {
  DefaultInsecureBasicAuthSource() { this.asExpr() instanceof HttpStringLiteral }
}

/**
 * A sink that represents a method that sets Basic Authentication.
 * Extend this class to add your own Insecure Basic Authentication sinks.
 */
abstract class InsecureBasicAuthSink extends ApiSinkNode { }

/** A default sink representing methods that set an Authorization header. */
private class DefaultInsecureBasicAuthSink extends InsecureBasicAuthSink {
  DefaultInsecureBasicAuthSink() {
    exists(MethodCall ma |
      ma.getMethod().hasName("addHeader") or
      ma.getMethod().hasName("setHeader") or
      ma.getMethod().hasName("setRequestProperty")
    |
      this.asExpr() = ma.getQualifier() and
      ma.getArgument(0).(CompileTimeConstantExpr).getStringValue() = "Authorization" and
      TaintTracking::localExprTaint(any(BasicAuthString b), ma.getArgument(1))
    )
  }
}

/**
 * String pattern of basic authentication.
 */
private class BasicAuthString extends StringLiteral {
  BasicAuthString() { exists(string s | this.getValue() = s | s.matches("Basic %")) }
}

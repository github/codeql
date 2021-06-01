/** Provides classes and predicates to reason about Insecure Basic Authentication vulnerabilities. */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.ExternalFlow
import semmle.code.java.frameworks.Networking
import semmle.code.java.frameworks.ApacheHttp

/**
 * A source that represents HTTP URLs.
 * Extend this class to add your own Insecure Basic Authentication sources.
 */
abstract class InsecureBasicAuthSource extends DataFlow::Node { }

/** A default source representing HTTP strings, URLs or URIs. */
private class DefaultInsecureBasicAuthSource extends InsecureBasicAuthSource {
  DefaultInsecureBasicAuthSource() {
    this.asExpr() instanceof HttpString
    or
    exists(URLConstructor uc |
      uc.hasHttpStringArg() and
      this.asExpr() = uc.getArgument(0)
    )
    or
    exists(URIConstructor uc |
      uc.hasHttpStringArg() and
      this.asExpr() = uc.getArgument(0)
    )
  }
}

/**
 * A sink that represents a method that set Basic Authentication.
 * Extend this class to add your own Insecure Basic Authentication sinks.
 */
abstract class InsecureBasicAuthSink extends DataFlow::Node { }

/** A default sink representing methods that set an Authorization header. */
private class DefaultInsecureBasicAuthSink extends InsecureBasicAuthSink {
  DefaultInsecureBasicAuthSink() {
    exists(MethodAccess ma |
      ma.getMethod().hasName("addHeader") or
      ma.getMethod().hasName("setHeader") or
      ma.getMethod().hasName("setRequestProperty")
    |
      this.asExpr() = ma.getQualifier() and
      ma.getArgument(0).(CompileTimeConstantExpr).getStringValue() = "Authorization" and
      builtFromBasicAuthStringConcat(ma.getArgument(1))
    )
  }
}

/**
 * A unit class for adding additional taint steps.
 *
 * Extend this class to add additional taint steps that should apply to the `BasicAuthFlowConfig`.
 */
class InsecureBasicAuthAdditionalTaintStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a taint
   * step for the `BasicAuthFlowConfig` configuration.
   */
  abstract predicate step(DataFlow::Node n1, DataFlow::Node n2);
}

/** A set of additional taint steps to consider when taint tracking LDAP related data flows. */
private class DefaultInsecureBasicAuthAdditionalTaintStep extends InsecureBasicAuthAdditionalTaintStep {
  override predicate step(DataFlow::Node n1, DataFlow::Node n2) {
    apacheHttpRequestStep(n1, n2) or
    createUriStep(n1, n2) or
    basicRequestLineStep(n1, n2) or
    createUrlStep(n1, n2) or
    urlOpenStep(n1, n2)
  }
}

/**
 * Class of Java URL constructor.
 */
private class URLConstructor extends ClassInstanceExpr {
  URLConstructor() { this.getConstructor().getDeclaringType() instanceof TypeUrl }

  predicate hasHttpStringArg() {
    this.getConstructor().getParameter(0).getType() instanceof TypeString and
    (
      // URLs constructed with any of the three string constructors below:
      // `URL(String protocol, String host, int port, String file)`,
      // `URL(String protocol, String host, int port, String file, URLStreamHandler handler)`,
      // `URL(String protocol, String host, String file)`
      this.getConstructor().getNumberOfParameters() > 1 and
      concatHttpString(this.getArgument(0), this.getArgument(1)) // First argument contains the protocol part and the second argument contains the host part.
      or
      // URLs constructed with the string constructor `URL(String spec)`
      this.getConstructor().getNumberOfParameters() = 1 and
      this.getArgument(0) instanceof HttpString // First argument contains the whole spec.
    )
  }
}

/**
 * Class of Java URI constructor.
 */
private class URIConstructor extends ClassInstanceExpr {
  URIConstructor() { this.getConstructor().getDeclaringType() instanceof TypeUri }

  predicate hasHttpStringArg() {
    (
      this.getNumArgument() = 1 and
      this.getArgument(0) instanceof HttpString // `URI(String str)`
      or
      this.getNumArgument() = 4 and
      concatHttpString(this.getArgument(0), this.getArgument(1)) // `URI(String scheme, String host, String path, String fragment)`
      or
      this.getNumArgument() = 5 and
      concatHttpString(this.getArgument(0), this.getArgument(1)) // `URI(String scheme, String authority, String path, String query, String fragment)` without user-info in authority
      or
      this.getNumArgument() = 7 and
      concatHttpString(this.getArgument(0), this.getArgument(2)) // `URI(String scheme, String userInfo, String host, int port, String path, String query, String fragment)`
    )
  }
}

/**
 * String of HTTP URLs not in private domains.
 */
private class HttpStringLiteral extends StringLiteral {
  HttpStringLiteral() {
    // Match URLs with the HTTP protocol and without private IP addresses to reduce false positives.
    exists(string s | this.getRepresentedString() = s |
      s.regexpMatch("(?i)http://[\\[a-zA-Z0-9].*") and
      not s.substring(7, s.length()) instanceof PrivateHostName
    )
  }
}

/**
 * Checks both parts of protocol and host.
 */
private predicate concatHttpString(Expr protocol, Expr host) {
  (
    protocol.(CompileTimeConstantExpr).getStringValue().regexpMatch("(?i)http(://)?") or
    protocol
        .(VarAccess)
        .getVariable()
        .getAnAssignedValue()
        .(CompileTimeConstantExpr)
        .getStringValue()
        .regexpMatch("(?i)http(://)?")
  ) and
  not exists(string hostString |
    hostString = host.(CompileTimeConstantExpr).getStringValue() or
    hostString =
      host.(VarAccess).getVariable().getAnAssignedValue().(CompileTimeConstantExpr).getStringValue()
  |
    hostString.length() = 0 or // Empty host is loopback address
    hostString instanceof PrivateHostName
  )
}

/** Gets the leftmost operand in a concatenated string */
private Expr getLeftmostConcatOperand(Expr expr) {
  if expr instanceof AddExpr
  then result = getLeftmostConcatOperand(expr.(AddExpr).getLeftOperand())
  else result = expr
}

/**
 * String concatenated with `HttpStringLiteral`.
 */
private class HttpString extends Expr {
  HttpString() {
    this instanceof HttpStringLiteral
    or
    concatHttpString(this.(AddExpr).getLeftOperand(),
      getLeftmostConcatOperand(this.(AddExpr).getRightOperand()))
  }
}

/**
 * String pattern of basic authentication.
 */
private class BasicAuthString extends StringLiteral {
  BasicAuthString() { exists(string s | this.getRepresentedString() = s | s.matches("Basic %")) }
}

/**
 * String concatenated with `BasicAuthString`.
 */
private predicate builtFromBasicAuthStringConcat(Expr expr) {
  expr instanceof BasicAuthString
  or
  builtFromBasicAuthStringConcat(expr.(AddExpr).getLeftOperand())
  or
  exists(Expr other | builtFromBasicAuthStringConcat(other) |
    exists(Variable var | var.getAnAssignedValue() = other and var.getAnAccess() = expr)
  )
}

/** The `openConnection` method of Java URL. Not to include `openStream` since it won't be used in this query. */
private class HttpURLOpenMethod extends Method {
  HttpURLOpenMethod() {
    this.getDeclaringType() instanceof TypeUrl and
    this.getName() = "openConnection"
  }
}

/** Constructor of `ApacheHttpRequest` */
private predicate apacheHttpRequestStep(DataFlow::Node node1, DataFlow::Node node2) {
  exists(ConstructorCall cc |
    cc.getConstructedType() instanceof ApacheHttpRequest and
    node2.asExpr() = cc and
    cc.getAnArgument() = node1.asExpr()
  )
}

/** `URI` methods */
private predicate createUriStep(DataFlow::Node node1, DataFlow::Node node2) {
  exists(
    URIConstructor cc // new URI
  |
    node2.asExpr() = cc and
    cc.getArgument(0) = node1.asExpr()
  )
  or
  exists(
    StaticMethodAccess ma // URI.create
  |
    ma.getMethod().getDeclaringType() instanceof TypeUri and
    ma.getMethod().hasName("create") and
    node1.asExpr() = ma.getArgument(0) and
    node2.asExpr() = ma
  )
}

/** Constructors of `URL` */
private predicate createUrlStep(DataFlow::Node node1, DataFlow::Node node2) {
  exists(URLConstructor cc |
    node2.asExpr() = cc and
    cc.getArgument(0) = node1.asExpr()
  )
}

/** Method call of `HttpURLOpenMethod` */
private predicate urlOpenStep(DataFlow::Node node1, DataFlow::Node node2) {
  exists(MethodAccess ma |
    ma.getMethod() instanceof HttpURLOpenMethod and
    node1.asExpr() = ma.getQualifier() and
    ma = node2.asExpr()
  )
}

/** Constructor of `BasicRequestLine` */
private predicate basicRequestLineStep(DataFlow::Node node1, DataFlow::Node node2) {
  exists(ConstructorCall mcc |
    mcc.getConstructedType().hasQualifiedName("org.apache.http.message", "BasicRequestLine") and
    mcc.getArgument(1) = node1.asExpr() and // BasicRequestLine(String method, String uri, ProtocolVersion version)
    node2.asExpr() = mcc
  )
}

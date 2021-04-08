/**
 * @name Insecure basic authentication
 * @description Basic authentication only obfuscates username/password in Base64 encoding, which can be easily recognized and reversed. Transmission of sensitive information not over HTTPS is vulnerable to packet sniffing.
 * @kind path-problem
 * @id java/insecure-basic-auth
 * @tags security
 *       external/cwe-522
 *       external/cwe-319
 */

import java
import semmle.code.java.frameworks.Networking
import semmle.code.java.dataflow.TaintTracking
import DataFlow::PathGraph

/**
 * Gets a regular expression for matching private hosts, which only matches the host portion therefore checking for port is not necessary.
 */
private string getPrivateHostRegex() {
  result =
    "(?i)localhost(?:[:/?#].*)?|127\\.0\\.0\\.1(?:[:/?#].*)?|10(?:\\.[0-9]+){3}(?:[:/?#].*)?|172\\.16(?:\\.[0-9]+){2}(?:[:/?#].*)?|192.168(?:\\.[0-9]+){2}(?:[:/?#].*)?|\\[?0:0:0:0:0:0:0:1\\]?(?:[:/?#].*)?|\\[?::1\\]?(?:[:/?#].*)?"
}

/**
 * The Java class `org.apache.http.client.methods.HttpRequestBase`. Popular subclasses include `HttpGet`, `HttpPost`, and `HttpPut`.
 * And the Java class `org.apache.http.message.BasicHttpRequest`.
 */
class ApacheHttpRequest extends RefType {
  ApacheHttpRequest() {
    this
        .getASourceSupertype*()
        .hasQualifiedName("org.apache.http.client.methods", "HttpRequestBase") or
    this.getASourceSupertype*().hasQualifiedName("org.apache.http.message", "BasicHttpRequest")
  }
}

/**
 * Class of Java URL constructor.
 */
class URLConstructor extends ClassInstanceExpr {
  URLConstructor() { this.getConstructor().getDeclaringType() instanceof TypeUrl }

  predicate hasHttpStringArg() {
    this.getConstructor().getParameter(0).getType() instanceof TypeString and
    (
      // URLs constructed with any of the three string constructors below:
      // `URL(String protocol, String host, int port, String file)`,
      // `URL(String protocol, String host, int port, String file, URLStreamHandler handler)`,
      // `URL(String protocol, String host, String file)`
      this.getConstructor().getNumberOfParameters() > 1 and
      concatHttpString(getArgument(0), this.getArgument(1)) // First argument contains the protocol part and the second argument contains the host part.
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
class URIConstructor extends ClassInstanceExpr {
  URIConstructor() { this.getConstructor().getDeclaringType().hasQualifiedName("java.net", "URI") }

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
class HttpStringLiteral extends StringLiteral {
  HttpStringLiteral() {
    // Match URLs with the HTTP protocol and without private IP addresses to reduce false positives.
    exists(string s | this.getRepresentedString() = s |
      s.regexpMatch("(?i)http://[\\[a-zA-Z0-9].*") and
      not s.substring(7, s.length()).regexpMatch(getPrivateHostRegex())
    )
  }
}

/**
 * Checks both parts of protocol and host.
 */
predicate concatHttpString(Expr protocol, Expr host) {
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
    hostString.regexpMatch(getPrivateHostRegex())
  )
}

/** Gets the leftmost operand in a concatenated string */
Expr getLeftmostConcatOperand(Expr expr) {
  if expr instanceof AddExpr
  then result = getLeftmostConcatOperand(expr.(AddExpr).getLeftOperand())
  else result = expr
}

/**
 * String concatenated with `HttpStringLiteral`.
 */
class HttpString extends Expr {
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
class BasicAuthString extends StringLiteral {
  BasicAuthString() { exists(string s | this.getRepresentedString() = s | s.matches("Basic %")) }
}

/**
 * String concatenated with `BasicAuthString`.
 */
predicate builtFromBasicAuthStringConcat(Expr expr) {
  expr instanceof BasicAuthString
  or
  builtFromBasicAuthStringConcat(expr.(AddExpr).getLeftOperand())
  or
  exists(Expr other | builtFromBasicAuthStringConcat(other) |
    exists(Variable var | var.getAnAssignedValue() = other and var.getAnAccess() = expr)
  )
}

/** The `openConnection` method of Java URL. Not to include `openStream` since it won't be used in this query. */
class HttpURLOpenMethod extends Method {
  HttpURLOpenMethod() {
    this.getDeclaringType() instanceof TypeUrl and
    this.getName() = "openConnection"
  }
}

/** Constructor of `ApacheHttpRequest` */
predicate apacheHttpRequest(DataFlow::Node node1, DataFlow::Node node2) {
  exists(ConstructorCall cc |
    cc.getConstructedType() instanceof ApacheHttpRequest and
    node2.asExpr() = cc and
    cc.getAnArgument() = node1.asExpr()
  )
}

/** `URI` methods */
predicate createURI(DataFlow::Node node1, DataFlow::Node node2) {
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
    ma.getMethod().getDeclaringType().hasQualifiedName("java.net", "URI") and
    ma.getMethod().hasName("create") and
    node1.asExpr() = ma.getArgument(0) and
    node2.asExpr() = ma
  )
}

/** Constructors of `URL` */
predicate createURL(DataFlow::Node node1, DataFlow::Node node2) {
  exists(URLConstructor cc |
    node2.asExpr() = cc and
    cc.getArgument(0) = node1.asExpr()
  )
}

/** Method call of `HttpURLOpenMethod` */
predicate urlOpen(DataFlow::Node node1, DataFlow::Node node2) {
  exists(MethodAccess ma |
    ma.getMethod() instanceof HttpURLOpenMethod and
    node1.asExpr() = ma.getQualifier() and
    ma = node2.asExpr()
  )
}

/** Constructor of `BasicRequestLine` */
predicate basicRequestLine(DataFlow::Node node1, DataFlow::Node node2) {
  exists(ConstructorCall mcc |
    mcc.getConstructedType().hasQualifiedName("org.apache.http.message", "BasicRequestLine") and
    mcc.getArgument(1) = node1.asExpr() and // `BasicRequestLine(String method, String uri, ProtocolVersion version)
    node2.asExpr() = mcc
  )
}

class BasicAuthFlowConfig extends TaintTracking::Configuration {
  BasicAuthFlowConfig() { this = "InsecureBasicAuth::BasicAuthFlowConfig" }

  override predicate isSource(DataFlow::Node src) {
    src.asExpr() instanceof HttpString
    or
    exists(URLConstructor uc |
      uc.hasHttpStringArg() and
      src.asExpr() = uc.getArgument(0)
    )
    or
    exists(URIConstructor uc |
      uc.hasHttpStringArg() and
      src.asExpr() = uc.getArgument(0)
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      sink.asExpr() = ma.getQualifier() and
      (
        ma.getMethod().hasName("addHeader") or
        ma.getMethod().hasName("setHeader") or
        ma.getMethod().hasName("setRequestProperty")
      ) and
      ma.getArgument(0).(CompileTimeConstantExpr).getStringValue() = "Authorization" and
      builtFromBasicAuthStringConcat(ma.getArgument(1))
    )
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    apacheHttpRequest(node1, node2) or
    createURI(node1, node2) or
    basicRequestLine(node1, node2) or
    createURL(node1, node2) or
    urlOpen(node1, node2)
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, BasicAuthFlowConfig config
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Insecure basic authentication from $@.", source.getNode(),
  "HTTP url"

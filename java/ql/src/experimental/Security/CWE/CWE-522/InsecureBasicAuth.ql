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

  // URLs constructed with the string constructor `URL(String spec)`
  Expr specArg() {
    this.getConstructor().getParameter(0).getType() instanceof TypeString and
    (
      this.getConstructor().getNumberOfParameters() = 1 and
      result = this.getArgument(0) // First argument contains the whole spec.
    )
  }

  // URLs constructed with any of the three string constructors below:
  // `URL(String protocol, String host, int port, String file)`,
  // `URL(String protocol, String host, int port, String file, URLStreamHandler handler)`,
  // `URL(String protocol, String host, String file)`
  Expr protocolArg() {
    this.getConstructor().getParameter(0).getType() instanceof TypeString and
    (
      this.getConstructor().getNumberOfParameters() > 1 and
      result = this.getArgument(0) // First argument contains the protocol part.
    )
  }

  Expr hostArg() {
    this.getConstructor().getParameter(0).getType() instanceof TypeString and
    (
      this.getConstructor().getNumberOfParameters() > 1 and
      result = this.getArgument(1) // Second argument contains the host part.
    )
  }
}

/**
 * Gets a regular expression for matching private hosts.
 */
private string getPrivateHostRegex() {
  result = "localhost(/.*)?" or
  result = "127\\.0\\.0\\.1(/.*)?" or // IPv4 patterns
  result = "10(\\.[0-9]+){3}(/.*)?" or
  result = "172\\.16(\\.[0-9]+){2}(/.*)?" or
  result = "192.168(\\.[0-9]+){2}(/.*)?" or
  result = "\\[0:0:0:0:0:0:0:1\\](/.*)?" or // IPv6 patterns
  result = "\\[::1\\](/.*)?"
}

/**
 * String of HTTP URLs not in private domains.
 */
class HttpString extends StringLiteral {
  HttpString() {
    // Match URLs with the HTTP protocol and without private IP addresses to reduce false positives.
    exists(string s | this.getRepresentedString() = s |
      s.regexpMatch("(?i)http")
      or
      s.regexpMatch("(?i)http://.*") and
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
  not (
    host.(CompileTimeConstantExpr).getStringValue().regexpMatch(getPrivateHostRegex()) or
    host
        .(VarAccess)
        .getVariable()
        .getAnAssignedValue()
        .(CompileTimeConstantExpr)
        .getStringValue()
        .regexpMatch(getPrivateHostRegex())
  )
}

/**
 * String concatenated with `HttpString`.
 */
predicate builtFromHttpStringConcat(Expr expr) {
  expr instanceof HttpString
  or
  expr.(VarAccess).getVariable().getAnAssignedValue() instanceof HttpString
  or
  concatHttpString(expr.(AddExpr).getLeftOperand(), expr.(AddExpr).getRightOperand())
  or
  concatHttpString(expr.(AddExpr).getLeftOperand().(AddExpr).getLeftOperand(),
    expr.(AddExpr).getLeftOperand().(AddExpr).getRightOperand())
  or
  concatHttpString(expr.(AddExpr).getLeftOperand(),
    expr.(AddExpr).getRightOperand().(AddExpr).getLeftOperand())
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

class BasicAuthFlowConfig extends TaintTracking::Configuration {
  BasicAuthFlowConfig() { this = "InsecureBasicAuth::BasicAuthFlowConfig" }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof HttpString }

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
    exists(ConstructorCall cc |
      cc.getConstructedType() instanceof ApacheHttpRequest and
      node2.asExpr() = cc and
      (
        cc.getAnArgument() = node1.asExpr() and
        builtFromHttpStringConcat(cc.getAnArgument())
        or
        exists(ConstructorCall mcc |
          (
            mcc.getConstructedType().hasQualifiedName("org.apache.http.message", "BasicRequestLine") and
            mcc.getArgument(1) = node1.asExpr() and // `BasicRequestLine(String method, String uri, ProtocolVersion version)
            builtFromHttpStringConcat(mcc.getArgument(1))
            or
            mcc.getConstructedType().hasQualifiedName("java.net", "URI") and
            (
              mcc.getNumArgument() = 1 and
              mcc.getArgument(0) = node1.asExpr() and
              builtFromHttpStringConcat(mcc.getArgument(0)) // `URI(String str)`
              or
              mcc.getNumArgument() = 4 and
              mcc.getArgument(0) = node1.asExpr() and
              concatHttpString(mcc.getArgument(0), mcc.getArgument(1)) // `URI(String scheme, String host, String path, String fragment)`
              or
              mcc.getNumArgument() = 7 and
              mcc.getArgument(0) = node1.asExpr() and
              concatHttpString(mcc.getArgument(2), mcc.getArgument(1)) // `URI(String scheme, String userInfo, String host, int port, String path, String query, String fragment)`
            )
          ) and
          (
            cc.getAnArgument() = mcc
            or
            exists(VarAccess va |
              cc.getAnArgument() = va and va.getVariable().getAnAssignedValue() = mcc
            )
          )
        )
        or
        exists(StaticMethodAccess ma |
          ma.getMethod().getDeclaringType().hasQualifiedName("java.net", "URI") and
          ma.getMethod().hasName("create") and
          builtFromHttpStringConcat(ma.getArgument(0)) and
          node1.asExpr() = ma.getArgument(0) and
          (
            cc.getArgument(0) = ma
            or
            exists(VarAccess va |
              cc.getArgument(0) = va and va.getVariable().getAnAssignedValue() = ma
            )
          )
        )
      )
    )
    or
    exists(MethodAccess ma |
      ma.getMethod() instanceof HttpURLOpenMethod and
      ma = node2.asExpr() and
      (
        node1.asExpr() = ma.getQualifier().(URLConstructor).getArgument(0) and
        (
          builtFromHttpStringConcat(ma.getQualifier().(URLConstructor).specArg()) or
          concatHttpString(ma.getQualifier().(URLConstructor).protocolArg(),
            ma.getQualifier().(URLConstructor).hostArg())
        )
        or
        exists(URLConstructor uc, VarAccess va |
          node1.asExpr() = uc.getAnArgument() and
          uc = va.getVariable().getAnAssignedValue() and
          ma.getQualifier() = va and
          (
            builtFromHttpStringConcat(uc.specArg()) or
            concatHttpString(uc.protocolArg(), uc.hostArg())
          )
        )
      )
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, BasicAuthFlowConfig config
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Insecure basic authentication from $@.", source.getNode(),
  "this user input"

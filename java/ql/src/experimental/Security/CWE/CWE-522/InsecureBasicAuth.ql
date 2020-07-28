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

  Expr stringArg() {
    // URLs constructed with any of the four string constructors below:
    // URL(String spec), URL(String protocol, String host, int port, String file), URL(String protocol, String host, int port, String file, URLStreamHandler handler), URL(String protocol, String host, String file)
    this.getConstructor().getParameter(0).getType() instanceof TypeString and
    result = this.getArgument(0) // First argument contains the protocol part.
  }
}

/**
 * The type `java.net.URLConnection`.
 */
class TypeHttpUrlConnection extends RefType {
  TypeHttpUrlConnection() {
    this.getASourceSupertype*().hasQualifiedName("java.net", "HttpURLConnection")
  }
}

/**
 * String of HTTP URLs not in private domains.
 */
class HttpString extends StringLiteral {
  HttpString() {
    // Match URLs with the HTTP protocol and without private IP addresses to reduce false positives.
    exists(string s | this.getRepresentedString() = s |
      s = "http"
      or
      s.matches("http://%") and
      not s.matches("%/localhost%") and
      not s.matches("%/127.0.0.1%") and
      not s.matches("%/10.%") and
      not s.matches("%/172.16.%") and
      not s.matches("%/192.168.%")
    )
  }
}

/**
 * String concatenated with `HttpString`.
 */
predicate builtFromHttpStringConcat(Expr expr) {
  expr instanceof HttpString
  or
  builtFromHttpStringConcat(expr.(AddExpr).getLeftOperand())
  or
  exists(Expr other | builtFromHttpStringConcat(other) |
    exists(Variable var | var.getAnAssignedValue() = other and var.getAnAccess() = expr)
  )
  or
  exists(Expr other | builtFromHttpStringConcat(other) |
    exists(ConstructorCall cc |
      (
        cc.getConstructedType().hasQualifiedName("org.apache.http.message", "BasicRequestLine") and
        cc.getArgument(1) = other // BasicRequestLine(String method, String uri, ProtocolVersion version)
        or
        cc.getConstructedType().hasQualifiedName("java.net", "URI") and
        cc.getArgument(0) = other // URI(String str) or URI(String scheme, ...)
      ) and
      (
        cc = expr
        or
        exists(Variable var, VariableAssign va |
          var.getAnAccess() = expr and
          va.getDestVar() = var and
          va.getSource() = cc
        )
      )
    )
  )
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

  override predicate isSource(DataFlow::Node src) {
    exists(ConstructorCall cc |
      (
        cc.getConstructedType() instanceof ApacheHttpRequest and
        cc = src.asExpr() and
        builtFromHttpStringConcat(cc.getAnArgument())
      )
    )
    or
    exists(MethodAccess ma |
      ma.getMethod() instanceof HttpURLOpenMethod and
      ma = src.asExpr() and
      (
        builtFromHttpStringConcat(ma.getQualifier().(URLConstructor).stringArg()) or
        exists(URLConstructor uc, VarAccess va |
          uc = va.getVariable().getAnAssignedValue() and
          ma.getQualifier() = va and
          builtFromHttpStringConcat(uc.stringArg())
        )
      )
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
}

from DataFlow::PathNode source, DataFlow::PathNode sink, BasicAuthFlowConfig config
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Insecure basic authentication from $@.", source.getNode(),
  "this user input"

/**
 * @name Insecure basic authentication
 * @description Basic authentication only obfuscates username/password in Base64 encoding, which can be easily recognized and reversed. Transmission of sensitive information not over HTTPS is vulnerable to packet sniffing.
 * @kind problem
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
    hasQualifiedName("org.apache.http.client.methods", "HttpRequestBase") or
    hasQualifiedName("org.apache.http.message", "BasicHttpRequest")
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
  TypeHttpUrlConnection() { hasQualifiedName("java.net", "HttpURLConnection") }
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

/**
 * The methods `addHeader()` and `setHeader` declared in ApacheHttpRequest invoked for basic authentication.
 */
class AddBasicAuthHeaderMethodAccess extends MethodAccess {
  AddBasicAuthHeaderMethodAccess() {
    this.getMethod().getDeclaringType() instanceof ApacheHttpRequest and
    (this.getMethod().hasName("addHeader") or this.getMethod().hasName("setHeader")) and
    this.getArgument(0).(CompileTimeConstantExpr).getStringValue() = "Authorization" and
    builtFromBasicAuthStringConcat(this.getArgument(1)) and
    exists(VarAccess request, VariableAssign va, ConstructorCall cc, Expr arg0 |
      this.getQualifier() = request and // Constructor call like HttpPost post = new HttpPost("http://www.example.com/rest/endpoint.do"); and BasicHttpRequest post = new BasicHttpRequest("POST", uriStr);
      va.getDestVar() = request.getVariable() and
      va.getSource() = cc and
      cc.getAnArgument() = arg0 and
      builtFromHttpStringConcat(arg0)
    )
  }
}

/** The `openConnection` method of Java URL. Not to include `openStream` since it won't be used in this query. */
class HttpURLOpenMethod extends Method {
  HttpURLOpenMethod() {
    this.getDeclaringType() instanceof TypeUrl and
    this.getName() = "openConnection"
  }
}

/**
 * Tracks the flow of data from parameter of URL constructor to the url instance.
 */
class URLConstructorTaintStep extends TaintTracking::AdditionalTaintStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    exists(URLConstructor u |
      node1.asExpr() = u.stringArg() and
      node2.asExpr() = u
    )
  }
}

/**
 * Tracks the flow of data from `openConnection` method to the connection object.
 */
class OpenHttpURLTaintStep extends TaintTracking::AdditionalTaintStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    exists(MethodAccess ma, VariableAssign va |
      ma.getMethod() instanceof HttpURLOpenMethod and
      ma.getQualifier() = node1.asExpr() and
      (
        ma = va.getSource()
        or
        exists(CastExpr ce |
          ce.getExpr() = ma and
          ce = va.getSource() and
          ce.getControlFlowNode().getASuccessor() = va //With a type cast like HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        )
      ) and
      node2.asExpr() = va.getDestVar().getAnAccess()
    )
  }
}

class HttpStringToHttpURLOpenMethodFlowConfig extends TaintTracking::Configuration {
  HttpStringToHttpURLOpenMethodFlowConfig() {
    this = "InsecureBasicAuth::HttpStringToHttpURLOpenMethodFlowConfig"
  }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof HttpString }

  override predicate isSink(DataFlow::Node sink) {
    sink.asExpr().(VarAccess).getVariable().getType() instanceof TypeUrlConnection or
    sink.asExpr().(VarAccess).getVariable().getType() instanceof TypeHttpUrlConnection // TypeHttpUrlConnection isn't instance of TypeUrlConnection
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(DataFlow::Node nodem |
      any(URLConstructorTaintStep uts).step(node1, nodem) and
      any(OpenHttpURLTaintStep ots).step(nodem, node2)
    )
  }

  override predicate isSanitizer(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or node.getType() instanceof BoxedType
  }
}

/**
 * The method `setRequestProperty()` declared in URL Connection invoked for basic authentication.
 */
class SetBasicAuthPropertyMethodAccess extends MethodAccess {
  SetBasicAuthPropertyMethodAccess() {
    this.getMethod().getDeclaringType() instanceof TypeUrlConnection and
    this.getMethod().hasName("setRequestProperty") and
    this.getArgument(0).(CompileTimeConstantExpr).getStringValue() = "Authorization" and
    builtFromBasicAuthStringConcat(this.getArgument(1)) and
    exists(VarAccess conn, DataFlow::PathNode source, DataFlow::PathNode sink, HttpString s |
      this.getQualifier() = conn and //HttpURLConnection conn = (HttpURLConnection) url.openConnection();
      source.getNode().asExpr() = s and
      sink.getNode().asExpr() = conn.getVariable().getAnAccess() and
      any(HttpStringToHttpURLOpenMethodFlowConfig c).hasFlowPath(source, sink)
    )
  }
}

from MethodAccess ma
where
  ma instanceof AddBasicAuthHeaderMethodAccess or
  ma instanceof SetBasicAuthPropertyMethodAccess
select ma, "Insecure basic authentication"

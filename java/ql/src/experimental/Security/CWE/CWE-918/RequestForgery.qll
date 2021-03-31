import java
import semmle.code.java.frameworks.Networking
import semmle.code.java.frameworks.ApacheHttp
import semmle.code.java.frameworks.spring.Spring
import semmle.code.java.frameworks.JaxWS
import semmle.code.java.frameworks.javase.Http
import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.ExternalFlow

predicate requestForgeryStep(DataFlow::Node pred, DataFlow::Node succ) {
  // propagate to a URI when its host is assigned to
  exists(UriCreation c | c.getHostArg() = pred.asExpr() | succ.asExpr() = c)
  or
  // propagate to a URL when its host is assigned to
  exists(UrlConstructorCall c | c.getHostArg() = pred.asExpr() | succ.asExpr() = c)
  or
  // propagate to a RequestEntity when its url is assigned to
  exists(MethodAccess m |
    m.getMethod().getDeclaringType() instanceof SpringRequestEntity and
    (
      m.getMethod().hasName(["get", "post", "head", "delete", "options", "patch", "put"]) and
      m.getArgument(0) = pred.asExpr() and
      m = succ.asExpr()
      or
      m.getMethod().hasName("method") and
      m.getArgument(1) = pred.asExpr() and
      m = succ.asExpr()
    )
  )
  or
  // propagate from a `RequestEntity<>$BodyBuilder` to a `RequestEntity`
  // when the builder is tainted
  exists(MethodAccess m, RefType t |
    m.getMethod().getDeclaringType() = t and
    t.hasQualifiedName("org.springframework.http", "RequestEntity<>$BodyBuilder") and
    m.getMethod().hasName("body") and
    m.getQualifier() = pred.asExpr() and
    m = succ.asExpr()
  )
}

private class RequestForgerySinkModel extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        "java.net;URL;false;openConnection;;;Argument[-1];request-forgery-sink",
        "java.net;URL;false;openStream;;;Argument[-1];request-forgery-sink",
        "org.apache.http.client.methods;HttpRequestBase;true;setURI;;;Argument[0];request-forgery-sink",
        "org.apache.http.message;BasicHttpRequest;true;setURI;;;Argument[0];request-forgery-sink",
        "org.apache.http.client.methods;HttpRequestBase;true;.ctor;;;Argument[0];request-forgery-sink",
        "org.apache.http.message;BasicHttpRequest;true;.ctor;;;Argument[0];request-forgery-sink",
        "org.apache.http.client.methods;RequestBuilder;false;setURI;;;Argument[0];request-forgery-sink",
        "org.apache.http.client.methods;RequestBuilder;false;get;;;Argument[0];request-forgery-sink",
        "org.apache.http.client.methods;RequestBuilder;false;post;;;Argument[0];request-forgery-sink",
        "org.apache.http.client.methods;RequestBuilder;false;put;;;Argument[0];request-forgery-sink",
        "org.apache.http.client.methods;RequestBuilder;false;options;;;Argument[0];request-forgery-sink",
        "org.apache.http.client.methods;RequestBuilder;false;head;;;Argument[0];request-forgery-sink",
        "org.apache.http.client.methods;RequestBuilder;false;delete;;;Argument[0];request-forgery-sink",
        "java.net.http;HttpRequest$Builder;false;uri;;;Argument[0];request-forgery-sink",
        "org.springframework.web.client;RestTemplate;false;patchForObject;;;Argument[0];request-forgery-sink",
        "org.springframework.web.client;RestTemplate;false;getForObject;;;Argument[0];request-forgery-sink",
        "org.springframework.web.client;RestTemplate;false;getForEntity;;;Argument[0];request-forgery-sink",
        "org.springframework.web.client;RestTemplate;false;execute;;;Argument[0];request-forgery-sink",
        "org.springframework.web.client;RestTemplate;false;exchange;;;Argument[0];request-forgery-sink",
        "org.springframework.web.client;RestTemplate;false;put;;;Argument[0];request-forgery-sink",
        "org.springframework.web.client;RestTemplate;false;postForObject;;;Argument[0];request-forgery-sink",
        "org.springframework.web.client;RestTemplate;false;postForLocation;;;Argument[0];request-forgery-sink",
        "org.springframework.web.client;RestTemplate;false;postForEntity;;;Argument[0];request-forgery-sink",
        "org.springframework.web.client;RestTemplate;false;doExecute;;;Argument[0];request-forgery-sink",
        "javax.ws.rs.client;Client;false;target;;;Argument[0];request-forgery-sink",
        "java.net.http;HttpRequest;false;newBuilder;;;Argument[0];request-forgery-sink" // todo: this might be stricter than before. Previously the package name was not checked.
      ]
  }
}

/** A data flow sink for request forgery vulnerabilities. */
abstract class RequestForgerySink extends DataFlow::Node { }

/**
 * An argument to `org.springframework.http.RequestEntity`s constructor call
 *   which is an URI taken as a sink for request forgery vulnerabilities.
 */
private class RequestEntityUriArg extends RequestForgerySink {
  RequestEntityUriArg() {
    exists(ClassInstanceExpr e, Argument a |
      e.getConstructedType() instanceof SpringRequestEntity and
      e.getAnArgument() = a and
      a.getType() instanceof TypeUri and
      this.asExpr() = a
    )
  }
}

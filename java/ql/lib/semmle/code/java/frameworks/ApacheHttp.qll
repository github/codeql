/**
 * Provides classes and predicates related to `org.apache.http.*` and `org.apache.hc.*`.
 */

import java
private import semmle.code.java.dataflow.FlowSteps

class ApacheHttpGetParams extends Method {
  ApacheHttpGetParams() { this.hasQualifiedName("org.apache.http", "HttpMessage", "getParams") }
}

class ApacheHttpEntityGetContent extends Method {
  ApacheHttpEntityGetContent() {
    this.hasQualifiedName("org.apache.http", "HttpEntity", "getContent")
  }
}

/**
 * An HTTP request as represented by the Apache HTTP Client library. This is
 * either `org.apache.http.client.methods.HttpRequestBase`,
 * `org.apache.http.message.BasicHttpRequest`, or one of their subclasses.
 */
class ApacheHttpRequest extends RefType {
  ApacheHttpRequest() {
    this.getASourceSupertype*()
        .hasQualifiedName("org.apache.http.client.methods", "HttpRequestBase") or
    this.getASourceSupertype*().hasQualifiedName("org.apache.http.message", "BasicHttpRequest")
  }
}

/**
 * The `org.apache.http.client.methods.RequestBuilder` class.
 */
class TypeApacheHttpRequestBuilder extends Class {
  TypeApacheHttpRequestBuilder() {
    this.hasQualifiedName("org.apache.http.client.methods", "RequestBuilder")
  }
}

/**
 * A call that sets a header of an `HttpResponse`.
 */
class ApacheHttpSetHeader extends Call {
  ApacheHttpSetHeader() {
    exists(Method m |
      this.getCallee().(Method).overrides*(m) and
      m.getDeclaringType()
          .hasQualifiedName(["org.apache.http", "org.apache.hc.core5.http"], "HttpMessage") and
      m.hasName(["addHeader", "setHeader"]) and
      m.getNumberOfParameters() = 2
    )
    or
    exists(Constructor c |
      this.getCallee() = c and
      c.getDeclaringType()
          .hasQualifiedName(["org.apache.http.message", "org.apache.hc.core5.http.message"],
            "BasicHeader")
    )
  }

  /** Gets the expression used as the name of this header. */
  Expr getName() { result = this.getArgument(0) }

  /** Gets the expression used as the value of this header. */
  Expr getValue() { result = this.getArgument(1) }
}

import java

class ApacheHttpGetParams extends Method {
  ApacheHttpGetParams() {
    this.getDeclaringType().getQualifiedName() = "org.apache.http.HttpMessage" and
    this.getName() = "getParams"
  }
}

class ApacheHttpEntityGetContent extends Method {
  ApacheHttpEntityGetContent() {
    this.getDeclaringType().getQualifiedName() = "org.apache.http.HttpEntity" and
    this.getName() = "getContent"
  }
}

/**
 *  A class derived from the `HttpRequestBase` or the `BasicHttpRequest`
 *  class of the Apache Http Client `org.apache.http` library
 */
class TypeApacheHttpRequestBase extends RefType {
  TypeApacheHttpRequestBase() {
    this
        .getASourceSupertype*()
        .hasQualifiedName("org.apache.http.client.methods", "HttpRequestBase") or
    this.getASourceSupertype*().hasQualifiedName("org.apache.http.message", "BasicHttpRequest")
  }
}

/* A class representing the `RequestBuilder` class of the Apache Http Client library */
class TypeApacheHttpRequestBuilder extends Class {
  TypeApacheHttpRequestBuilder() {
    hasQualifiedName("org.apache.http.client.methods", "RequestBuilder")
  }
}

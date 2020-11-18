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
 *  A class that is derived from the `HttpRequestBase` or the `BasicHttpRequest`
 *  classes of the Apache HTTP Client `org.apache.http` library
 */
class ApacheHttpRequest extends RefType {
  ApacheHttpRequest() {
    this
        .getASourceSupertype*()
        .hasQualifiedName("org.apache.http.client.methods", "HttpRequestBase") or
    this.getASourceSupertype*().hasQualifiedName("org.apache.http.message", "BasicHttpRequest")
  }
}

/** Models `RequestBuilder` class of the Apache Http Client library */
class TypeApacheHttpRequestBuilder extends Class {
  TypeApacheHttpRequestBuilder() {
    hasQualifiedName("org.apache.http.client.methods", "RequestBuilder")
  }
}

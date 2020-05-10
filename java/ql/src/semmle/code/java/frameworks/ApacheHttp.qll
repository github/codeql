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

/*
 * Any class which can be used to make an HTTP request using the Apache Http Client library
 * Examples include `HttpGet`,`HttpPost` etc.
 */

class TypeApacheHttpRequest extends Class {
  TypeApacheHttpRequest() { exists(TypeApacheHttpRequestBase t | this.extendsOrImplements(t)) }
}

/* A class representing the `RequestBuilder` class of the Apache Http Client library */
class TypeApacheHttpRequestBuilder extends Class {
  TypeApacheHttpRequestBuilder() {
    hasQualifiedName("org.apache.http.client.methods", "RequestBuilder")
  }
}

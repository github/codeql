/**
 * Provides classes and predicates related to `org.apache.http.*` and `org.apache.hc.*`.
 */

import java
private import semmle.code.java.dataflow.FlowSteps

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
 * The `request` parameter of an implementation of `HttpRequestHandler.handle`.
 */
class ApacheHttpRequestHandlerParameter extends Parameter {
  ApacheHttpRequestHandlerParameter() {
    exists(Method m, Interface i |
      i.hasQualifiedName(["org.apache.http.protocol", "org.apache.hc.core5.http.io"],
        "HttpRequestHandler") and
      m.getDeclaringType().extendsOrImplements+(i) and
      m.hasName("handle") and
      this = m.getParameter(0)
    )
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

/**
 * A call that sets the entity of an instance of `org.apache.http.HttpResponse` / `org.apache.hc.core5.http.ClassicHttpResponse`.
 */
class ApacheHttpResponseSetEntityCall extends MethodAccess {
  int arg;

  ApacheHttpResponseSetEntityCall() {
    exists(Method m | this.getMethod().overrides*(m) |
      m.getDeclaringType().hasQualifiedName("org.apache.http", "HttpResponse") and
      m.hasName("setEntity") and
      arg = 0
      or
      m.getDeclaringType().hasQualifiedName("org.apache.http.util", "EntityUtils") and
      m.hasName("updateEntity") and
      arg = 1
      or
      m.getDeclaringType().hasQualifiedName("org.apache.hc.core5.http", "HttpEntityContainer") and
      m.hasName("setEntity") and
      arg = 0
    )
  }

  /**
   * Gets the entity that is set by this call.
   */
  Expr getEntity() { result = this.getArgument(arg) }
}

/** A getter that returns tainted data when its qualifier is tainted. */
private class ApacheHttpGetter extends TaintPreservingCallable {
  ApacheHttpGetter() {
    exists(string pkg, string ty, string mtd, Method m |
      this.(Method).overrides*(m) and
      m.getDeclaringType().hasQualifiedName(pkg, ty) and
      m.hasName(mtd)
    |
      pkg = "org.apache.http" and
      (
        ty = "HttpMessage" and
        mtd =
          [
            "getAllHeaders", "getFirstHeader", "getHeaders", "getLastHeader", "getParams",
            "headerIterator"
          ]
        or
        ty = "HttpRequest" and
        mtd = "getRequestLine"
        or
        ty = "HttpEntityEnclosingRequest" and
        mtd = "getEntity"
        or
        ty = "Header" and
        mtd = "getElements"
        or
        ty = "HeaderElement" and
        mtd = ["getName", "getParameter", "getParameterByName", "getParameters", "getValue"]
        or
        ty = "NameValuePair" and
        mtd = ["getName", "getValue"]
        or
        ty = "HeaderIterator" and
        mtd = "nextHeader"
        or
        ty = "HttpEntity" and
        mtd = ["getContent", "getContentEncoding", "getContentType"]
        or
        ty = "RequestLine" and
        mtd = ["getMethod", "getUri"]
      )
      or
      pkg = "org.apache.http.params" and
      ty = "HttpParams" and
      mtd.matches("get%Parameter")
      or
      pkg = "org.apache.hc.core5.http" and
      (
        ty = "MessageHeaders" and
        mtd = ["getFirstHeader", "getHeader", "getHeaders", "getLastHeader", "headerIterator"]
        or
        ty = "HttpRequest" and
        mtd = ["getAuthority", "getPath", "getRequestUri", "getScheme", "getUri"]
        or
        ty = "HttpEntityContainer" and
        mtd = "getEntity"
        or
        ty = "NameValuePair" and
        mtd = ["getName", "getValue"]
        or
        ty = "HttpEntity" and
        mtd = ["getContent", "getTrailers"]
        or
        ty = "EntityDetails" and
        mtd = ["getContentType", "getTrailerNames"]
      )
      or
      pkg = "org.apache.hc.core5.message" and
      ty = "RequestLine" and
      mtd = ["getMethod", "getUri", "toString"]
      or
      pkg = "org.apache.hc.core5.function" and
      ty = "Supplier" and
      mtd = "get"
      or
      pkg = "org.apache.hc.core5.net" and
      ty = "UriAuthority" and
      mtd = ["getHostName", "toString"]
    )
  }

  override predicate returnsTaintFrom(int arg) { arg = -1 }
}

private class UtilMethod extends TaintPreservingCallable {
  UtilMethod() {
    exists(string pkg, string ty, string mtd |
      this.isStatic() and
      this.getDeclaringType().hasQualifiedName(pkg, ty) and
      this.hasName(mtd)
    |
      pkg = ["org.apache.http.util", "org.apache.hc.core5.io.entity"] and
      ty = "EntityUtils" and
      mtd = ["toString", "toByteArray", "getContentCharSet", "getContentMimeType", "parse"]
      or
      pkg = ["org.apache.http.util", "org.apache.hc.core5.util"] and
      ty = "EncodingUtils" and
      mtd = ["getAsciiBytes", "getAsciiString", "getBytes", "getString"]
      or
      pkg = ["org.apache.http.util", "org.apache.hc.core5.util"] and
      ty = "Args" and
      mtd = ["containsNoBlanks", "notBlank", "notEmpty", "notNull"]
      or
      pkg = "org.apache.hc.core5.io.entity" and
      ty = "HttpEntities" and
      mtd = ["create", "createGziped", "createUrlEncoded", "gzip", "withTrailers"]
    )
  }

  override predicate returnsTaintFrom(int arg) { arg = 0 }
}

private class EntitySetter extends TaintPreservingCallable {
  EntitySetter() {
    this.getDeclaringType()
        .getASourceSupertype*()
        .hasQualifiedName("org.apache.http.entity", "BasicHttpEntity") and
    this.hasName("setContent")
  }

  override predicate transfersTaint(int src, int sink) { src = 0 and sink = -1 }
}

private class EntityConstructor extends TaintPreservingCallable, Constructor {
  EntityConstructor() {
    this.getDeclaringType()
        .hasQualifiedName(["org.apache.http.entity", "org.apache.hc.core5.io.entity"],
          [
            "BasicHttpEntity", "BufferedHttpEntity", "ByteArrayEntity", "HttpEntityWrapper",
            "InputStreamEntity", "StringEntity"
          ])
  }

  override predicate returnsTaintFrom(int arg) { arg = 0 }
}

private class RequestLineConstructor extends TaintPreservingCallable, Constructor {
  RequestLineConstructor() {
    this.getDeclaringType().hasQualifiedName("org.apache.hc.core5.http.message", "RequestLine")
  }

  override predicate returnsTaintFrom(int arg) { arg = [0, 1] }
}

private class BufferMethod extends TaintPreservingCallable {
  BufferMethod() {
    exists(Method m |
      this.(Method).overrides*(m) and
      m.getDeclaringType()
          .hasQualifiedName(["org.apache.http.util", "org.apache.hc.core5.util"],
            ["ByteArrayBuffer", "CharArrayBuffer"]) and
      m.hasName([
          "append", "buffer", "subSequence", "substring", "substringTrimmed", "toByteAray",
          "toCharArray", "toString"
        ])
    )
  }

  override predicate returnsTaintFrom(int arg) { arg = -1 }

  override predicate transfersTaint(int src, int sink) {
    this.hasName("append") and
    src = 0 and
    sink = -1
  }
}

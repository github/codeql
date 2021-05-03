/**
 * Provides classes and predicates related to `ratpack.*`.
 */

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.FlowSteps

/**
 * Ratpack methods that access user-supplied request data.
 */
abstract class RatpackGetRequestDataMethod extends Method { }

/**
 * The interface `ratpack.http.Request`.
 * https://ratpack.io/manual/current/api/ratpack/http/Request.html
 */
class RatpackRequest extends RefType {
  RatpackRequest() {
    hasQualifiedName("ratpack.http", "Request") or
    hasQualifiedName("ratpack.core.http", "Request")
  }
}

/**
 * Methods on `ratpack.http.Request` that return user tainted data.
 */
class RatpackHttpRequestGetMethod extends RatpackGetRequestDataMethod {
  RatpackHttpRequestGetMethod() {
    getDeclaringType() instanceof RatpackRequest and
    hasName([
        "getContentLength", "getCookies", "oneCookie", "getHeaders", "getPath", "getQuery",
        "getQueryParams", "getRawUri", "getUri"
      ])
  }
}

/**
 * The interface `ratpack.http.TypedData`.
 * https://ratpack.io/manual/current/api/ratpack/http/TypedData.html
 */
class RatpackTypedData extends RefType {
  RatpackTypedData() {
    hasQualifiedName("ratpack.http", "TypedData") or
    hasQualifiedName("ratpack.core.http", "TypedData")
  }
}

/**
 * Methods on `ratpack.http.TypedData` that return user tainted data.
 */
class RatpackHttpTypedDataGetMethod extends RatpackGetRequestDataMethod {
  RatpackHttpTypedDataGetMethod() {
    getDeclaringType() instanceof RatpackTypedData and
    hasName(["getBuffer", "getBytes", "getContentType", "getInputStream", "getText"])
  }
}

/**
 * Methods on `ratpack.http.TypedData` that taint the parameter passed in.
 */
class RatpackHttpTypedDataWriteMethod extends Method {
  RatpackHttpTypedDataWriteMethod() {
    getDeclaringType() instanceof RatpackTypedData and
    hasName("writeTo")
  }
}

/**
 * The interface `ratpack.form.UploadedFile`.
 * https://ratpack.io/manual/current/api/ratpack/form/UploadedFile.html
 */
class RatpackUploadFile extends RefType {
  RatpackUploadFile() {
    hasQualifiedName("ratpack.form", "UploadedFile") or
    hasQualifiedName("ratpack.core.form", "UploadedFile")
  }
}

class RatpackUploadFileGetMethod extends RatpackGetRequestDataMethod {
  RatpackUploadFileGetMethod() {
    getDeclaringType() instanceof RatpackUploadFile and
    hasName("getFileName")
  }
}

class RatpackHeader extends RefType {
  RatpackHeader() {
    hasQualifiedName("ratpack.http", "Headers") or
    hasQualifiedName("ratpack.core.http", "Headers")
  }
}

private class RatpackHeaderTaintPropagatingMethod extends Method, TaintPreservingCallable {
  RatpackHeaderTaintPropigatingMethod() {
    getDeclaringType() instanceof RatpackHeader and
    hasName(["get", "getAll", "getNames", "asMultiValueMap"])
  }

  override predicate returnsTaintFrom(int arg) { arg = -1 }
}

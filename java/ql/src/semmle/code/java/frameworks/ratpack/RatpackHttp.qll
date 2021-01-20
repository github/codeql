/**
 * Provides classes and predicates related to `ratpack.http.*`.
 */

import java

/**
 * The interface `ratpack.http.Request`.
 * https://ratpack.io/manual/current/api/ratpack/http/Request.html
 */
library class RatpackRequest extends RefType {
  RatpackRequest() { hasQualifiedName("ratpack.http", "Request") }
}

/**
 * Methods on `ratpack.http.Request` that return user tainted data.
 */
library class RatpackHttpRequestGetMethod extends Method {
  RatpackHttpRequestGetMethod() {
    getDeclaringType() instanceof RatpackRequest and
    hasName([
        "getContentLength", "getCookies", "getHeaders", "getPath", "getQuery", "getQueryParams",
        "getRawUri", "getUri"
      ])
  }
}

/**
 * The interface `ratpack.http.TypedData`.
 * https://ratpack.io/manual/current/api/ratpack/http/TypedData.html
 */
library class RatpackTypedData extends RefType {
  RatpackTypedData() { hasQualifiedName("ratpack.http", "TypedData") }
}

/**
 * Methods on `ratpack.http.TypedData` that return user tainted data.
 */
library class RatpackHttpTypedDataGetMethod extends Method {
  RatpackHttpTypedDataGetMethod() {
    getDeclaringType() instanceof RatpackTypedData and
    hasName(["getBuffer", "getBytes", "getContentType", "getInputStream", "getText"])
  }
}

/**
 * The interface `ratpack.form.UploadedFile`.
 * https://ratpack.io/manual/current/api/ratpack/form/UploadedFile.html
 */
library class RatpackUploadFile extends RefType {
  RatpackUploadFile() { hasQualifiedName("ratpack.form", "UploadedFile") }
}

library class RatpackUploadFileGetMethod extends Method {
  RatpackUploadFileGetMethod() {
    getDeclaringType() instanceof RatpackUploadFile and
    hasName("getFileName")
  }
}

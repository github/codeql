/**
 * Provides classes for working with Spring classes and interfaces from
 * `org.springframework.http`.
 */

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.frameworks.spring.SpringController
private import semmle.code.java.security.XSS as XSS

/** The class `org.springframework.http.HttpEntity` or an instantiation of it. */
class SpringHttpEntity extends Class {
  SpringHttpEntity() {
    this.getSourceDeclaration().hasQualifiedName("org.springframework.http", "HttpEntity")
  }
}

/** The class `org.springframework.http.RequestEntity` or an instantiation of it. */
class SpringRequestEntity extends Class {
  SpringRequestEntity() {
    this.getSourceDeclaration().hasQualifiedName("org.springframework.http", "RequestEntity")
  }
}

/** The class `org.springframework.http.ResponseEntity` or an instantiation of it. */
class SpringResponseEntity extends Class {
  SpringResponseEntity() {
    this.getSourceDeclaration().hasQualifiedName("org.springframework.http", "ResponseEntity")
  }
}

/** The nested class `BodyBuilder` in `org.springframework.http.ResponseEntity`. */
class SpringResponseEntityBodyBuilder extends Interface {
  SpringResponseEntityBodyBuilder() {
    this.getSourceDeclaration().getEnclosingType() instanceof SpringResponseEntity and
    this.hasName("BodyBuilder")
  }
}

/** The class `org.springframework.http.HttpHeaders`. */
class SpringHttpHeaders extends Class {
  SpringHttpHeaders() { this.hasQualifiedName("org.springframework.http", "HttpHeaders") }
}

private predicate specifiesContentType(SpringRequestMappingMethod method) {
  exists(method.getAProducesExpr())
}

private class SpringXssSink extends XSS::XssSink {
  SpringXssSink() {
    exists(SpringRequestMappingMethod requestMappingMethod, ReturnStmt rs |
      requestMappingMethod = rs.getEnclosingCallable() and
      this.asExpr() = rs.getResult() and
      (
        not specifiesContentType(requestMappingMethod) or
        isXssVulnerableContentTypeExpr(requestMappingMethod.getAProducesExpr())
      )
    |
      // If a Spring request mapping method is either annotated with @ResponseBody (or equivalent),
      // or returns a HttpEntity or sub-type, then the return value of the method is converted into
      // a HTTP response using a HttpMessageConverter implementation. The implementation is chosen
      // based on the return type of the method, and the Accept header of the request.
      //
      // By default, the only message converter which produces a response which is vulnerable to
      // XSS is the StringHttpMessageConverter, which "Accept"s all text/* content types, including
      // text/html. Therefore, if a browser request includes "text/html" in the "Accept" header,
      // any String returned will be converted into a text/html response.
      requestMappingMethod.isResponseBody() and
      requestMappingMethod.getReturnType() instanceof TypeString
      or
      exists(Type returnType |
        // A return type of HttpEntity<T> or ResponseEntity<T> represents an HTTP response with both
        // a body and a set of headers. The body is subject to the same HttpMessageConverter
        // process as above.
        returnType = requestMappingMethod.getReturnType() and
        (
          returnType instanceof SpringHttpEntity
          or
          returnType instanceof SpringResponseEntity
        )
      |
        // The type argument, representing the type of the body, is type String
        returnType.(ParameterizedClass).getTypeArgument(0) instanceof TypeString
        or
        // Return type is a Raw class, which means no static type information on the body. In this
        // case we will still treat this as an XSS sink, but rely on our taint flow steps for
        // HttpEntity/ResponseEntity to only pass taint into those instances if the body type was
        // String.
        returnType instanceof RawClass
      )
    )
  }
}

private string getSpringConstantContentType(FieldAccess e) {
  e.getQualifier().getType().(RefType).hasQualifiedName("org.springframework.http", "MediaType") and
  exists(string fieldName | e.getField().hasName(fieldName) |
    fieldName = "APPLICATION_ATOM_XML" + ["", "_VALUE"] and result = "application/atom+xml"
    or
    fieldName = "APPLICATION_CBOR" + ["", "_VALUE"] and result = "application/cbor"
    or
    fieldName = "APPLICATION_FORM_URLENCODED" + ["", "_VALUE"] and
    result = "application/x-www-form-urlencoded"
    or
    fieldName = "APPLICATION_JSON" + ["", "_VALUE"] and result = "application/json"
    or
    fieldName = "APPLICATION_JSON_UTF8" + ["", "_VALUE"] and
    result = "application/json;charset=UTF-8"
    or
    fieldName = "APPLICATION_NDJSON" + ["", "_VALUE"] and result = "application/x-ndjson"
    or
    fieldName = "APPLICATION_OCTET_STREAM" + ["", "_VALUE"] and result = "application/octet-stream"
    or
    fieldName = "APPLICATION_PDF" + ["", "_VALUE"] and result = "application/pdf"
    or
    fieldName = "APPLICATION_PROBLEM_JSON" + ["", "_VALUE"] and result = "application/problem+json"
    or
    fieldName = "APPLICATION_PROBLEM_JSON_UTF8" + ["", "_VALUE"] and
    result = "application/problem+json;charset=UTF-8"
    or
    fieldName = "APPLICATION_PROBLEM_XML" + ["", "_VALUE"] and result = "application/problem+xml"
    or
    fieldName = "APPLICATION_RSS_XML" + ["", "_VALUE"] and result = "application/rss+xml"
    or
    fieldName = "APPLICATION_STREAM_JSON" + ["", "_VALUE"] and result = "application/stream+json"
    or
    fieldName = "APPLICATION_XHTML_XML" + ["", "_VALUE"] and result = "application/xhtml+xml"
    or
    fieldName = "APPLICATION_XML" + ["", "_VALUE"] and result = "application/xml"
    or
    fieldName = "IMAGE_GIF" + ["", "_VALUE"] and result = "image/gif"
    or
    fieldName = "IMAGE_JPEG" + ["", "_VALUE"] and result = "image/jpeg"
    or
    fieldName = "IMAGE_PNG" + ["", "_VALUE"] and result = "image/png"
    or
    fieldName = "MULTIPART_FORM_DATA" + ["", "_VALUE"] and result = "multipart/form-data"
    or
    fieldName = "MULTIPART_MIXED" + ["", "_VALUE"] and result = "multipart/mixed"
    or
    fieldName = "MULTIPART_RELATED" + ["", "_VALUE"] and result = "multipart/related"
    or
    fieldName = "TEXT_EVENT_STREAM" + ["", "_VALUE"] and result = "text/event-stream"
    or
    fieldName = "TEXT_HTML" + ["", "_VALUE"] and result = "text/html"
    or
    fieldName = "TEXT_MARKDOWN" + ["", "_VALUE"] and result = "text/markdown"
    or
    fieldName = "TEXT_PLAIN" + ["", "_VALUE"] and result = "text/plain"
    or
    fieldName = "TEXT_XML" + ["", "_VALUE"] and result = "text/xml"
  )
}

private string getContentTypeString(Expr e) {
  result = e.(CompileTimeConstantExpr).getStringValue() or
  result = getSpringConstantContentType(e)
}

pragma[nomagic]
private predicate contentTypeString(string s) { s = getContentTypeString(_) }

pragma[nomagic]
private predicate isXssVulnerableContentTypeString(string s) {
  contentTypeString(s) and XSS::isXssVulnerableContentType(s)
}

pragma[nomagic]
private predicate isXssSafeContentTypeString(string s) {
  contentTypeString(s) and XSS::isXssSafeContentType(s)
}

private predicate isXssVulnerableContentTypeExpr(Expr e) {
  isXssVulnerableContentTypeString(getContentTypeString(e))
}

private predicate isXssSafeContentTypeExpr(Expr e) {
  isXssSafeContentTypeString(getContentTypeString(e))
}

private DataFlow::Node getABodyBuilderWithExplicitContentType(Expr contentType) {
  result.asExpr() =
    any(MethodCall ma |
      ma.getCallee()
          .hasQualifiedName("org.springframework.http", "ResponseEntity$BodyBuilder", "contentType") and
      contentType = ma.getArgument(0)
    )
  or
  result.asExpr() =
    any(MethodCall ma |
      ma.getQualifier() = getABodyBuilderWithExplicitContentType(contentType).asExpr() and
      ma.getType()
          .(RefType)
          .hasQualifiedName("org.springframework.http", "ResponseEntity$BodyBuilder")
    )
  or
  DataFlow::localFlowStep(getABodyBuilderWithExplicitContentType(contentType), result)
}

private DataFlow::Node getASanitizedBodyBuilder() {
  result = getABodyBuilderWithExplicitContentType(any(Expr e | isXssSafeContentTypeExpr(e)))
}

private DataFlow::Node getAVulnerableBodyBuilder() {
  result = getABodyBuilderWithExplicitContentType(any(Expr e | isXssVulnerableContentTypeExpr(e)))
}

private class SanitizedBodyCall extends XSS::XssSanitizer {
  SanitizedBodyCall() {
    this.asExpr() =
      any(MethodCall ma |
        ma.getQualifier() = getASanitizedBodyBuilder().asExpr() and
        ma.getCallee().hasName("body")
      ).getArgument(0)
  }
}

/**
 * Mark BodyBuilder.body calls with an explicitly vulnerable Content-Type as themselves sinks,
 * as the eventual return site from a RequestHandler may have a benign @Produces annotation that
 * would otherwise sanitise the result.
 *
 * Note these are SinkBarriers so that a return from a RequestHandlerMethod is not also flagged
 * for the same path.
 */
private class ExplicitlyVulnerableBodyArgument extends XSS::XssSinkBarrier {
  ExplicitlyVulnerableBodyArgument() {
    this.asExpr() =
      any(MethodCall ma |
        ma.getQualifier() = getAVulnerableBodyBuilder().asExpr() and
        ma.getCallee().hasName("body")
      ).getArgument(0)
  }
}

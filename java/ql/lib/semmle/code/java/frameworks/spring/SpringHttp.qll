/**
 * Provides classes for working with Spring classes and interfaces from
 * `org.springframework.http`.
 */

import java
private import semmle.code.java.dataflow.ExternalFlow
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

private class UrlOpenSink extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        "org.springframework.http;RequestEntity;false;get;;;Argument[0];open-url",
        "org.springframework.http;RequestEntity;false;post;;;Argument[0];open-url",
        "org.springframework.http;RequestEntity;false;head;;;Argument[0];open-url",
        "org.springframework.http;RequestEntity;false;delete;;;Argument[0];open-url",
        "org.springframework.http;RequestEntity;false;options;;;Argument[0];open-url",
        "org.springframework.http;RequestEntity;false;patch;;;Argument[0];open-url",
        "org.springframework.http;RequestEntity;false;put;;;Argument[0];open-url",
        "org.springframework.http;RequestEntity;false;method;;;Argument[1];open-url",
        "org.springframework.http;RequestEntity;false;RequestEntity;(HttpMethod,URI);;Argument[1];open-url",
        "org.springframework.http;RequestEntity;false;RequestEntity;(MultiValueMap,HttpMethod,URI);;Argument[2];open-url",
        "org.springframework.http;RequestEntity;false;RequestEntity;(Object,HttpMethod,URI);;Argument[2];open-url",
        "org.springframework.http;RequestEntity;false;RequestEntity;(Object,HttpMethod,URI,Type);;Argument[2];open-url",
        "org.springframework.http;RequestEntity;false;RequestEntity;(Object,MultiValueMap,HttpMethod,URI);;Argument[3];open-url",
        "org.springframework.http;RequestEntity;false;RequestEntity;(Object,MultiValueMap,HttpMethod,URI,Type);;Argument[3];open-url"
      ]
  }
}

private class SpringHttpFlowStep extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        //"package;type;overrides;name;signature;ext;inputspec;outputspec;kind",
        "org.springframework.http;HttpEntity;true;HttpEntity;(Object);;Argument[0];Argument[-1];taint",
        "org.springframework.http;HttpEntity;true;HttpEntity;(Object,MultiValueMap);;Argument[0];Argument[-1];taint",
        "org.springframework.http;HttpEntity;true;HttpEntity;(Object,MultiValueMap);;Argument[1].MapKey;Argument[-1];taint",
        "org.springframework.http;HttpEntity;true;HttpEntity;(Object,MultiValueMap);;Argument[1].MapValue.Element;Argument[-1];taint",
        "org.springframework.http;HttpEntity;true;HttpEntity;(MultiValueMap);;Argument[0].MapKey;Argument[-1];taint",
        "org.springframework.http;HttpEntity;true;HttpEntity;(MultiValueMap);;Argument[0].MapValue.Element;Argument[-1];taint",
        "org.springframework.http;HttpEntity;true;getBody;;;Argument[-1];ReturnValue;taint",
        "org.springframework.http;HttpEntity;true;getHeaders;;;Argument[-1];ReturnValue;taint",
        "org.springframework.http;ResponseEntity;true;ResponseEntity;(Object,HttpStatus);;Argument[0];Argument[-1];taint",
        "org.springframework.http;ResponseEntity;true;ResponseEntity;(Object,MultiValueMap,HttpStatus);;Argument[0];Argument[-1];taint",
        "org.springframework.http;ResponseEntity;true;ResponseEntity;(Object,MultiValueMap,HttpStatus);;Argument[1].MapKey;Argument[-1];taint",
        "org.springframework.http;ResponseEntity;true;ResponseEntity;(Object,MultiValueMap,HttpStatus);;Argument[1].MapValue.Element;Argument[-1];taint",
        "org.springframework.http;ResponseEntity;true;ResponseEntity;(MultiValueMap,HttpStatus);;Argument[0].MapKey;Argument[-1];taint",
        "org.springframework.http;ResponseEntity;true;ResponseEntity;(MultiValueMap,HttpStatus);;Argument[0].MapValue.Element;Argument[-1];taint",
        "org.springframework.http;ResponseEntity;true;ResponseEntity;(Object,MultiValueMap,int);;Argument[0];Argument[-1];taint",
        "org.springframework.http;ResponseEntity;true;ResponseEntity;(Object,MultiValueMap,int);;Argument[1].MapKey;Argument[-1];taint",
        "org.springframework.http;ResponseEntity;true;ResponseEntity;(Object,MultiValueMap,int);;Argument[1].MapValue.Element;Argument[-1];taint",
        "org.springframework.http;ResponseEntity;true;of;(Optional);;Argument[0].Element;ReturnValue;taint",
        "org.springframework.http;ResponseEntity;true;ok;(Object);;Argument[0];ReturnValue;taint",
        "org.springframework.http;ResponseEntity;true;created;(URI);;Argument[0];ReturnValue;taint",
        "org.springframework.http;ResponseEntity$BodyBuilder;true;contentLength;(long);;Argument[-1];ReturnValue;value",
        "org.springframework.http;ResponseEntity$BodyBuilder;true;contentType;(MediaType);;Argument[-1];ReturnValue;value",
        "org.springframework.http;ResponseEntity$BodyBuilder;true;body;(Object);;Argument[-1..0];ReturnValue;taint",
        "org.springframework.http;ResponseEntity$HeadersBuilder;true;allow;(HttpMethod[]);;Argument[-1];ReturnValue;value",
        "org.springframework.http;ResponseEntity$HeadersBuilder;true;eTag;(String);;Argument[-1];ReturnValue;value",
        "org.springframework.http;ResponseEntity$HeadersBuilder;true;eTag;(String);;Argument[0];Argument[-1];taint",
        "org.springframework.http;ResponseEntity$HeadersBuilder;true;header;(String,String[]);;Argument[-1];ReturnValue;value",
        "org.springframework.http;ResponseEntity$HeadersBuilder;true;header;(String,String[]);;Argument[0];Argument[-1];taint",
        "org.springframework.http;ResponseEntity$HeadersBuilder;true;header;(String,String[]);;Argument[1].ArrayElement;Argument[-1];taint",
        "org.springframework.http;ResponseEntity$HeadersBuilder;true;headers;(Consumer);;Argument[-1];ReturnValue;value",
        "org.springframework.http;ResponseEntity$HeadersBuilder;true;headers;(HttpHeaders);;Argument[-1];ReturnValue;value",
        "org.springframework.http;ResponseEntity$HeadersBuilder;true;headers;(HttpHeaders);;Argument[0];Argument[-1];taint",
        "org.springframework.http;ResponseEntity$HeadersBuilder;true;lastModified;;;Argument[-1];ReturnValue;value",
        "org.springframework.http;ResponseEntity$HeadersBuilder;true;location;(URI);;Argument[-1];ReturnValue;value",
        "org.springframework.http;ResponseEntity$HeadersBuilder;true;location;(URI);;Argument[0];Argument[-1];taint",
        "org.springframework.http;ResponseEntity$HeadersBuilder;true;varyBy;(String[]);;Argument[-1];ReturnValue;value",
        "org.springframework.http;ResponseEntity$HeadersBuilder;true;build;();;Argument[-1];ReturnValue;taint",
        "org.springframework.http;RequestEntity;true;getUrl;();;Argument[-1];ReturnValue;taint",
        "org.springframework.http;HttpHeaders;true;HttpHeaders;(MultiValueMap);;Argument[0].MapKey;Argument[-1];taint",
        "org.springframework.http;HttpHeaders;true;HttpHeaders;(MultiValueMap);;Argument[0].MapValue.Element;Argument[-1];taint",
        "org.springframework.http;HttpHeaders;true;get;(Object);;Argument[-1];ReturnValue.Element;taint",
        "org.springframework.http;HttpHeaders;true;getAccessControlAllowHeaders;();;Argument[-1];ReturnValue.Element;taint",
        "org.springframework.http;HttpHeaders;true;getAccessControlAllowOrigin;();;Argument[-1];ReturnValue;taint",
        "org.springframework.http;HttpHeaders;true;getAccessControlExposeHeaders;();;Argument[-1];ReturnValue.Element;taint",
        "org.springframework.http;HttpHeaders;true;getAccessControlRequestHeaders;();;Argument[-1];ReturnValue.Element;taint",
        "org.springframework.http;HttpHeaders;true;getCacheControl;();;Argument[-1];ReturnValue;taint",
        "org.springframework.http;HttpHeaders;true;getConnection;();;Argument[-1];ReturnValue.Element;taint",
        "org.springframework.http;HttpHeaders;true;getETag;();;Argument[-1];ReturnValue;taint",
        "org.springframework.http;HttpHeaders;true;getETagValuesAsList;(String);;Argument[-1];ReturnValue.Element;taint",
        "org.springframework.http;HttpHeaders;true;getFieldValues;(String);;Argument[-1];ReturnValue;taint",
        "org.springframework.http;HttpHeaders;true;getFirst;(String);;Argument[-1];ReturnValue;taint",
        "org.springframework.http;HttpHeaders;true;getIfMatch;();;Argument[-1];ReturnValue.Element;taint",
        "org.springframework.http;HttpHeaders;true;getIfNoneMatch;();;Argument[-1];ReturnValue.Element;taint",
        "org.springframework.http;HttpHeaders;true;getHost;();;Argument[-1];ReturnValue;taint",
        "org.springframework.http;HttpHeaders;true;getLocation;();;Argument[-1];ReturnValue;taint",
        "org.springframework.http;HttpHeaders;true;getOrEmpty;(Object);;Argument[-1];ReturnValue.Element;taint",
        "org.springframework.http;HttpHeaders;true;getOrigin;();;Argument[-1];ReturnValue;taint",
        "org.springframework.http;HttpHeaders;true;getPragma;();;Argument[-1];ReturnValue;taint",
        "org.springframework.http;HttpHeaders;true;getUpgrade;();;Argument[-1];ReturnValue;taint",
        "org.springframework.http;HttpHeaders;true;getValuesAsList;(String);;Argument[-1];ReturnValue.Element;taint",
        "org.springframework.http;HttpHeaders;true;getVary;();;Argument[-1];ReturnValue.Element;taint",
        "org.springframework.http;HttpHeaders;true;add;(String,String);;Argument[0..1];Argument[-1];taint",
        "org.springframework.http;HttpHeaders;true;set;(String,String);;Argument[0..1];Argument[-1];taint",
        "org.springframework.http;HttpHeaders;true;addAll;(MultiValueMap);;Argument[0].MapKey;Argument[-1];taint",
        "org.springframework.http;HttpHeaders;true;addAll;(MultiValueMap);;Argument[0].MapValue.Element;Argument[-1];taint",
        "org.springframework.http;HttpHeaders;true;addAll;(String,List);;Argument[0];Argument[-1];taint",
        "org.springframework.http;HttpHeaders;true;addAll;(String,List);;Argument[1].Element;Argument[-1];taint",
        "org.springframework.http;HttpHeaders;true;formatHeaders;(MultiValueMap);;Argument[0].MapKey;ReturnValue;taint",
        "org.springframework.http;HttpHeaders;true;formatHeaders;(MultiValueMap);;Argument[0].MapValue.Element;ReturnValue;taint",
        "org.springframework.http;HttpHeaders;true;encodeBasicAuth;(String,String,Charset);;Argument[0..1];ReturnValue;taint"
      ]
  }
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
      // a HTTP reponse using a HttpMessageConverter implementation. The implementation is chosen
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

private predicate isXssVulnerableContentTypeExpr(Expr e) {
  XSS::isXssVulnerableContentType(e.(CompileTimeConstantExpr).getStringValue()) or
  XSS::isXssVulnerableContentType(getSpringConstantContentType(e))
}

private predicate isXssSafeContentTypeExpr(Expr e) {
  XSS::isXssSafeContentType(e.(CompileTimeConstantExpr).getStringValue()) or
  XSS::isXssSafeContentType(getSpringConstantContentType(e))
}

private DataFlow::Node getABodyBuilderWithExplicitContentType(Expr contentType) {
  result.asExpr() =
    any(MethodAccess ma |
      ma.getCallee()
          .hasQualifiedName("org.springframework.http", "ResponseEntity$BodyBuilder", "contentType") and
      contentType = ma.getArgument(0)
    )
  or
  result.asExpr() =
    any(MethodAccess ma |
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
      any(MethodAccess ma |
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
      any(MethodAccess ma |
        ma.getQualifier() = getAVulnerableBodyBuilder().asExpr() and
        ma.getCallee().hasName("body")
      ).getArgument(0)
  }
}

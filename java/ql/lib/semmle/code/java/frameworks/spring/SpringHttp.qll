/**
 * Provides classes for working with Spring classes and interfaces from
 * `org.springframework.http`.
 */

import java
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.DataFlow
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
        "org.springframework.http;HttpEntity;true;HttpEntity;(Object,MultiValueMap);;MapKey of Argument[1];Argument[-1];taint",
        "org.springframework.http;HttpEntity;true;HttpEntity;(Object,MultiValueMap);;Element of MapValue of Argument[1];Argument[-1];taint",
        "org.springframework.http;HttpEntity;true;HttpEntity;(MultiValueMap);;MapKey of Argument[0];Argument[-1];taint",
        "org.springframework.http;HttpEntity;true;HttpEntity;(MultiValueMap);;Element of MapValue of Argument[0];Argument[-1];taint",
        "org.springframework.http;HttpEntity;true;getBody;;;Argument[-1];ReturnValue;taint",
        "org.springframework.http;HttpEntity;true;getHeaders;;;Argument[-1];ReturnValue;taint",
        "org.springframework.http;ResponseEntity;true;ResponseEntity;(Object,HttpStatus);;Argument[0];Argument[-1];taint",
        "org.springframework.http;ResponseEntity;true;ResponseEntity;(Object,MultiValueMap,HttpStatus);;Argument[0];Argument[-1];taint",
        "org.springframework.http;ResponseEntity;true;ResponseEntity;(Object,MultiValueMap,HttpStatus);;MapKey of Argument[1];Argument[-1];taint",
        "org.springframework.http;ResponseEntity;true;ResponseEntity;(Object,MultiValueMap,HttpStatus);;Element of MapValue of Argument[1];Argument[-1];taint",
        "org.springframework.http;ResponseEntity;true;ResponseEntity;(MultiValueMap,HttpStatus);;MapKey of Argument[0];Argument[-1];taint",
        "org.springframework.http;ResponseEntity;true;ResponseEntity;(MultiValueMap,HttpStatus);;Element of MapValue of Argument[0];Argument[-1];taint",
        "org.springframework.http;ResponseEntity;true;ResponseEntity;(Object,MultiValueMap,int);;Argument[0];Argument[-1];taint",
        "org.springframework.http;ResponseEntity;true;ResponseEntity;(Object,MultiValueMap,int);;MapKey of Argument[1];Argument[-1];taint",
        "org.springframework.http;ResponseEntity;true;ResponseEntity;(Object,MultiValueMap,int);;Element of MapValue of Argument[1];Argument[-1];taint",
        "org.springframework.http;ResponseEntity;true;of;(Optional);;Element of Argument[0];ReturnValue;taint",
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
        "org.springframework.http;ResponseEntity$HeadersBuilder;true;header;(String,String[]);;ArrayElement of Argument[1];Argument[-1];taint",
        "org.springframework.http;ResponseEntity$HeadersBuilder;true;headers;(Consumer);;Argument[-1];ReturnValue;value",
        "org.springframework.http;ResponseEntity$HeadersBuilder;true;headers;(HttpHeaders);;Argument[-1];ReturnValue;value",
        "org.springframework.http;ResponseEntity$HeadersBuilder;true;headers;(HttpHeaders);;Argument[0];Argument[-1];taint",
        "org.springframework.http;ResponseEntity$HeadersBuilder;true;lastModified;;;Argument[-1];ReturnValue;value",
        "org.springframework.http;ResponseEntity$HeadersBuilder;true;location;(URI);;Argument[-1];ReturnValue;value",
        "org.springframework.http;ResponseEntity$HeadersBuilder;true;location;(URI);;Argument[0];Argument[-1];taint",
        "org.springframework.http;ResponseEntity$HeadersBuilder;true;varyBy;(String[]);;Argument[-1];ReturnValue;value",
        "org.springframework.http;ResponseEntity$HeadersBuilder;true;build;();;Argument[-1];ReturnValue;taint",
        "org.springframework.http;RequestEntity;true;getUrl;();;Argument[-1];ReturnValue;taint",
        "org.springframework.http;HttpHeaders;true;HttpHeaders;(MultiValueMap);;MapKey of Argument[0];Argument[-1];taint",
        "org.springframework.http;HttpHeaders;true;HttpHeaders;(MultiValueMap);;Element of MapValue of Argument[0];Argument[-1];taint",
        "org.springframework.http;HttpHeaders;true;get;(Object);;Argument[-1];Element of ReturnValue;taint",
        "org.springframework.http;HttpHeaders;true;getAccessControlAllowHeaders;();;Argument[-1];Element of ReturnValue;taint",
        "org.springframework.http;HttpHeaders;true;getAccessControlAllowOrigin;();;Argument[-1];ReturnValue;taint",
        "org.springframework.http;HttpHeaders;true;getAccessControlExposeHeaders;();;Argument[-1];Element of ReturnValue;taint",
        "org.springframework.http;HttpHeaders;true;getAccessControlRequestHeaders;();;Argument[-1];Element of ReturnValue;taint",
        "org.springframework.http;HttpHeaders;true;getCacheControl;();;Argument[-1];ReturnValue;taint",
        "org.springframework.http;HttpHeaders;true;getConnection;();;Argument[-1];Element of ReturnValue;taint",
        "org.springframework.http;HttpHeaders;true;getETag;();;Argument[-1];ReturnValue;taint",
        "org.springframework.http;HttpHeaders;true;getETagValuesAsList;(String);;Argument[-1];Element of ReturnValue;taint",
        "org.springframework.http;HttpHeaders;true;getFieldValues;(String);;Argument[-1];ReturnValue;taint",
        "org.springframework.http;HttpHeaders;true;getFirst;(String);;Argument[-1];ReturnValue;taint",
        "org.springframework.http;HttpHeaders;true;getIfMatch;();;Argument[-1];Element of ReturnValue;taint",
        "org.springframework.http;HttpHeaders;true;getIfNoneMatch;();;Argument[-1];Element of ReturnValue;taint",
        "org.springframework.http;HttpHeaders;true;getHost;();;Argument[-1];ReturnValue;taint",
        "org.springframework.http;HttpHeaders;true;getLocation;();;Argument[-1];ReturnValue;taint",
        "org.springframework.http;HttpHeaders;true;getOrEmpty;(Object);;Argument[-1];Element of ReturnValue;taint",
        "org.springframework.http;HttpHeaders;true;getOrigin;();;Argument[-1];ReturnValue;taint",
        "org.springframework.http;HttpHeaders;true;getPragma;();;Argument[-1];ReturnValue;taint",
        "org.springframework.http;HttpHeaders;true;getUpgrade;();;Argument[-1];ReturnValue;taint",
        "org.springframework.http;HttpHeaders;true;getValuesAsList;(String);;Argument[-1];Element of ReturnValue;taint",
        "org.springframework.http;HttpHeaders;true;getVary;();;Argument[-1];Element of ReturnValue;taint",
        "org.springframework.http;HttpHeaders;true;add;(String,String);;Argument[0..1];Argument[-1];taint",
        "org.springframework.http;HttpHeaders;true;set;(String,String);;Argument[0..1];Argument[-1];taint",
        "org.springframework.http;HttpHeaders;true;addAll;(MultiValueMap);;MapKey of Argument[0];Argument[-1];taint",
        "org.springframework.http;HttpHeaders;true;addAll;(MultiValueMap);;Element of MapValue of Argument[0];Argument[-1];taint",
        "org.springframework.http;HttpHeaders;true;addAll;(String,List);;Argument[0];Argument[-1];taint",
        "org.springframework.http;HttpHeaders;true;addAll;(String,List);;Element of Argument[1];Argument[-1];taint",
        "org.springframework.http;HttpHeaders;true;formatHeaders;(MultiValueMap);;MapKey of Argument[0];ReturnValue;taint",
        "org.springframework.http;HttpHeaders;true;formatHeaders;(MultiValueMap);;Element of MapValue of Argument[0];ReturnValue;taint",
        "org.springframework.http;HttpHeaders;true;encodeBasicAuth;(String,String,Charset);;Argument[0..1];ReturnValue;taint"
      ]
  }
}

private string getSpringConstantContentType(FieldAccess e) {
  e.getQualifier().getType().(RefType).hasQualifiedName("org.springframework.http", "MediaType") and
  exists(string fieldName | e.getField().hasName(fieldName) |
    fieldName = "APPLICATION_ATOM_XML" and result = "application/atom+xml"
    or
    fieldName = "APPLICATION_CBOR" and result = "application/cbor"
    or
    fieldName = "APPLICATION_FORM_URLENCODED" and result = "application/x-www-form-urlencoded"
    or
    fieldName = "APPLICATION_JSON" and result = "application/json"
    or
    fieldName = "APPLICATION_JSON_UTF8" and result = "application/json;charset=UTF-8"
    or
    fieldName = "APPLICATION_NDJSON" and result = "application/x-ndjson"
    or
    fieldName = "APPLICATION_OCTET_STREAM" and result = "application/octet-stream"
    or
    fieldName = "APPLICATION_PDF" and result = "application/pdf"
    or
    fieldName = "APPLICATION_PROBLEM_JSON" and result = "application/problem+json"
    or
    fieldName = "APPLICATION_PROBLEM_JSON_UTF8" and
    result = "application/problem+json;charset=UTF-8"
    or
    fieldName = "APPLICATION_PROBLEM_XML" and result = "application/problem+xml"
    or
    fieldName = "APPLICATION_RSS_XML" and result = "application/rss+xml"
    or
    fieldName = "APPLICATION_STREAM_JSON" and result = "application/stream+json"
    or
    fieldName = "APPLICATION_XHTML_XML" and result = "application/xhtml+xml"
    or
    fieldName = "APPLICATION_XML" and result = "application/xml"
    or
    fieldName = "IMAGE_GIF" and result = "image/gif"
    or
    fieldName = "IMAGE_JPEG" and result = "image/jpeg"
    or
    fieldName = "IMAGE_PNG" and result = "image/png"
    or
    fieldName = "MULTIPART_FORM_DATA" and result = "multipart/form-data"
    or
    fieldName = "MULTIPART_MIXED" and result = "multipart/mixed"
    or
    fieldName = "MULTIPART_RELATED" and result = "multipart/related"
    or
    fieldName = "TEXT_EVENT_STREAM" and result = "text/event-stream"
    or
    fieldName = "TEXT_HTML" and result = "text/html"
    or
    fieldName = "TEXT_MARKDOWN" and result = "text/markdown"
    or
    fieldName = "TEXT_PLAIN" and result = "text/plain"
    or
    fieldName = "TEXT_XML" and result = "text/xml"
  )
}

private predicate isXssSafeContentTypeExpr(Expr e) {
  XSS::isXssSafeContentType(e.(CompileTimeConstantExpr).getStringValue()) or
  XSS::isXssSafeContentType(getSpringConstantContentType(e))
}

private DataFlow::Node getASanitizedBodyBuilder() {
  result.asExpr() =
    any(MethodAccess ma |
      ma.getCallee()
          .hasQualifiedName("org.springframework.http", "ResponseEntity<>$BodyBuilder",
            "contentType") and
      isXssSafeContentTypeExpr(ma.getArgument(0))
    )
  or
  result.asExpr() =
    any(MethodAccess ma |
      ma.getQualifier() = getASanitizedBodyBuilder().asExpr() and
      ma.getType()
          .(RefType)
          .hasQualifiedName("org.springframework.http", "ResponseEntity<>$BodyBuilder")
    )
  or
  DataFlow::localFlow(getASanitizedBodyBuilder(), result)
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

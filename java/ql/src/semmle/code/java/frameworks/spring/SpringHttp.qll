/**
 * Provides classes for working with Spring classes and interfaces from
 * `org.springframework.http`.
 */

import java
private import semmle.code.java.dataflow.ExternalFlow

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

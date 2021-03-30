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

private class SpringHttpFlowStep extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        //"package;type;overrides;name;signature;ext;inputspec;outputspec;kind",
        "org.springframework.http;HttpEntity;false;HttpEntity;(T);;Argument[0];Argument[-1];taint",
        "org.springframework.http;HttpEntity;false;HttpEntity;(T,MultiValueMap<String,String>);;Argument[0];Argument[-1];taint",
        "org.springframework.http;HttpEntity;false;getBody;;;Argument[-1];ReturnValue;taint",
        "org.springframework.http;HttpEntity;false;HttpEntity;getHeaders;;Argument[-1];ReturnValue;taint",
        // Constructor with signature (MultiValueMap<String,String>) dependant on collection flow
        "org.springframework.http;ResponseEntity;false;ResponseEntity;(T,HttpStatus);;Argument[0];Argument[-1];taint",
        "org.springframework.http;ResponseEntity;false;ResponseEntity;(T,MultiValueMap<String,String>,HttpStatus);;Argument[0];Argument[-1];taint",
        "org.springframework.http;ResponseEntity;false;ResponseEntity;(T,MultiValueMap<String,String>,int);;Argument[0];Argument[-1];taint",
        "org.springframework.http;HttpHeaders;false;get;(Object);Argument[-1];ReturnValue;taint", // Returns List<String>
        "org.springframework.http;HttpHeaders;false;getAccessControlAllowHeaders;();Argument[-1];ReturnValue;taint", // Returns List<String>
        "org.springframework.http;HttpHeaders;false;getAccessControlAllowOrigin;();Argument[-1];ReturnValue;taint",
        "org.springframework.http;HttpHeaders;false;getAccessControlExposeHeaders;();Argument[-1];ReturnValue;taint", // Returns List<String>
        "org.springframework.http;HttpHeaders;false;getAccessControlRequestHeaders;();Argument[-1];ReturnValue;taint", // Returns List<String>
        "org.springframework.http;HttpHeaders;false;getCacheControl;();Argument[-1];ReturnValue;taint",
        "org.springframework.http;HttpHeaders;false;getConnection;();Argument[-1];ReturnValue;taint", // Returns List<String>
        "org.springframework.http;HttpHeaders;false;getETag;();Argument[-1];ReturnValue;taint",
        "org.springframework.http;HttpHeaders;false;getETagValuesAsList;(String);Argument[-1];ReturnValue;taint", // Returns List<String>
        "org.springframework.http;HttpHeaders;false;getFieldValues;(String);Argument[-1];ReturnValue;taint",
        "org.springframework.http;HttpHeaders;false;getFirst;(String);Argument[-1];ReturnValue;taint",
        "org.springframework.http;HttpHeaders;false;getIfMatch;();Argument[-1];ReturnValue;taint", // Returns List<String>
        "org.springframework.http;HttpHeaders;false;getIfNoneMatch;();Argument[-1];ReturnValue;taint", // Returns List<String>
        "org.springframework.http;HttpHeaders;false;getLocation;();Argument[-1];ReturnValue;taint",
        "org.springframework.http;HttpHeaders;false;getOrEmpty;(Object);Argument[-1];ReturnValue;taint", // Returns List<String>
        "org.springframework.http;HttpHeaders;false;getOrigin;();Argument[-1];ReturnValue;taint",
        "org.springframework.http;HttpHeaders;false;getPragma;();Argument[-1];ReturnValue;taint",
        "org.springframework.http;HttpHeaders;false;getUpgrade;();Argument[-1];ReturnValue;taint",
        "org.springframework.http;HttpHeaders;false;getValuesAsList;(String);Argument[-1];ReturnValue;taint", // Returns List<String>
        "org.springframework.http;HttpHeaders;false;getVary;();Argument[-1];ReturnValue;taint", // Returns List<String>
        ""
      ]
  }
}

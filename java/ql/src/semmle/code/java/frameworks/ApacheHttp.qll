/**
 * Provides classes and predicates related to `org.apache.http.*` and `org.apache.hc.*`.
 */

import java
private import semmle.code.java.dataflow.FlowSteps
private import semmle.code.java.dataflow.ExternalFlow

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

private class ApacheHttpSource extends SourceModelCsv {
  override predicate row(string row) {
    row =
      [
        "org.apache.http.protocol;HttpRequestHandler;true;handle;(HttpRequest,HttpResponse,HttpContext);;Parameter[0];remote",
        "org.apache.hc.core5.http.io;HttpRequestHandler;true;handle;(ClassicHttpRequest,ClassicHttpResponse,HttpContext);;Parameter[0];remote",
        "org.apache.hc.core5.http.io;HttpServerRequestHandler;true;handle;(ClassicHttpRequest,ResponseTrigger,HttpContext);;Parameter[0];remote"
      ]
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

private class ApacheHttpXssSink extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        "org.apache.http;HttpResponse;true;setEntity;(HttpEntity);;Argument[0];xss",
        "org.apache.http.util;EntityUtils;true;updateEntity;(HttpResponse,HttpEntity);;Argument[1];xss",
        "org.apache.hc.core5.http;HttpEntityContainer;true;setEntity;(HttpEntity);;Argument[0];xss"
      ]
  }
}

private class ApacheHttpOpenUrlSink extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        "org.apache.http;HttpRequest;true;setURI;;;Argument[0];open-url",
        "org.apache.http.message;BasicHttpRequest;false;BasicHttpRequest;(RequestLine);;Argument[0];open-url",
        "org.apache.http.message;BasicHttpRequest;false;BasicHttpRequest;(String,String);;Argument[1];open-url",
        "org.apache.http.message;BasicHttpRequest;false;BasicHttpRequest;(String,String,ProtocolVersion);;Argument[1];open-url",
        "org.apache.http.message;BasicHttpEntityEnclosingRequest;false;BasicHttpEntityEnclosingRequest;(RequestLine);;Argument[0];open-url",
        "org.apache.http.message;BasicHttpEntityEnclosingRequest;false;BasicHttpEntityEnclosingRequest;(String,String);;Argument[1];open-url",
        "org.apache.http.message;BasicHttpEntityEnclosingRequest;false;BasicHttpEntityEnclosingRequest;(String,String,ProtocolVersion);;Argument[1];open-url",
        "org.apache.http.client.methods;HttpGet;false;HttpGet;;;Argument[0];open-url",
        "org.apache.http.client.methods;HttpHead;false;HttpHead;;;Argument[0];open-url",
        "org.apache.http.client.methods;HttpPut;false;HttpPut;;;Argument[0];open-url",
        "org.apache.http.client.methods;HttpPost;false;HttpPost;;;Argument[0];open-url",
        "org.apache.http.client.methods;HttpDelete;false;HttpDelete;;;Argument[0];open-url",
        "org.apache.http.client.methods;HttpOptions;false;HttpOptions;;;Argument[0];open-url",
        "org.apache.http.client.methods;HttpTrace;false;HttpTrace;;;Argument[0];open-url",
        "org.apache.http.client.methods;HttpPatch;false;HttpPatch;;;Argument[0];open-url",
        "org.apache.http.client.methods;HttpRequestBase;true;setURI;;;Argument[0];open-url",
        "org.apache.http.client.methods;RequestBuilder;false;setUri;;;Argument[0];open-url",
        "org.apache.http.client.methods;RequestBuilder;false;get;;;Argument[0];open-url",
        "org.apache.http.client.methods;RequestBuilder;false;post;;;Argument[0];open-url",
        "org.apache.http.client.methods;RequestBuilder;false;put;;;Argument[0];open-url",
        "org.apache.http.client.methods;RequestBuilder;false;options;;;Argument[0];open-url",
        "org.apache.http.client.methods;RequestBuilder;false;head;;;Argument[0];open-url",
        "org.apache.http.client.methods;RequestBuilder;false;delete;;;Argument[0];open-url",
        "org.apache.http.client.methods;RequestBuilder;false;trace;;;Argument[0];open-url",
        "org.apache.http.client.methods;RequestBuilder;false;patch;;;Argument[0];open-url"
      ]
  }
}

private class ApacheHttpFlowStep extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "org.apache.http;HttpMessage;true;getAllHeaders;();;Argument[-1];ReturnValue;taint",
        "org.apache.http;HttpMessage;true;getFirstHeader;(String);;Argument[-1];ReturnValue;taint",
        "org.apache.http;HttpMessage;true;getLastHeader;(String);;Argument[-1];ReturnValue;taint",
        "org.apache.http;HttpMessage;true;getHeaders;(String);;Argument[-1];ReturnValue;taint",
        "org.apache.http;HttpMessage;true;getParams;();;Argument[-1];ReturnValue;taint",
        "org.apache.http;HttpMessage;true;headerIterator;();;Argument[-1];ReturnValue;taint",
        "org.apache.http;HttpMessage;true;headerIterator;(String);;Argument[-1];ReturnValue;taint",
        "org.apache.http;HttpRequest;true;getRequestLine;();;Argument[-1];ReturnValue;taint",
        "org.apache.http;HttpEntityEnclosingRequest;true;getEntity;();;Argument[-1];ReturnValue;taint",
        "org.apache.http;Header;true;getElements;();;Argument[-1];ReturnValue;taint",
        "org.apache.http;HeaderElement;true;getName;();;Argument[-1];ReturnValue;taint",
        "org.apache.http;HeaderElement;true;getValue;();;Argument[-1];ReturnValue;taint",
        "org.apache.http;HeaderElement;true;getParameter;(int);;Argument[-1];ReturnValue;taint",
        "org.apache.http;HeaderElement;true;getParameterByName;(String);;Argument[-1];ReturnValue;taint",
        "org.apache.http;HeaderElement;true;getParameters;();;Argument[-1];ReturnValue;taint",
        "org.apache.http;NameValuePair;true;getName;();;Argument[-1];ReturnValue;taint",
        "org.apache.http;NameValuePair;true;getValue;();;Argument[-1];ReturnValue;taint",
        "org.apache.http;HeaderIterator;true;nextHeader;();;Argument[-1];ReturnValue;taint",
        "org.apache.http;HttpEntity;true;getContent;();;Argument[-1];ReturnValue;taint",
        "org.apache.http;HttpEntity;true;getContentEncoding;();;Argument[-1];ReturnValue;taint",
        "org.apache.http;HttpEntity;true;getContentType;();;Argument[-1];ReturnValue;taint",
        "org.apache.http;RequestLine;true;getMethod;();;Argument[-1];ReturnValue;taint",
        "org.apache.http;RequestLine;true;getUri;();;Argument[-1];ReturnValue;taint",
        "org.apache.http.params;HttpParams;true;getParameter;(String);;Argument[-1];ReturnValue;taint",
        "org.apache.http.params;HttpParams;true;getDoubleParameter;(String,double);;Argument[-1];ReturnValue;taint",
        "org.apache.http.params;HttpParams;true;getIntParameter;(String,int);;Argument[-1];ReturnValue;taint",
        "org.apache.http.params;HttpParams;true;getLongParameter;(String,long);;Argument[-1];ReturnValue;taint",
        "org.apache.http.params;HttpParams;true;getDoubleParameter;(String,double);;Argument[1];ReturnValue;value",
        "org.apache.http.params;HttpParams;true;getIntParameter;(String,int);;Argument[1];ReturnValue;value",
        "org.apache.http.params;HttpParams;true;getLongParameter;(String,long);;Argument[1];ReturnValue;value",
        "org.apache.hc.core5.http;MessageHeaders;true;getFirstHeader;(String);;Argument[-1];ReturnValue;taint",
        "org.apache.hc.core5.http;MessageHeaders;true;getLastHeader;(String);;Argument[-1];ReturnValue;taint",
        "org.apache.hc.core5.http;MessageHeaders;true;getHeader;(String);;Argument[-1];ReturnValue;taint",
        "org.apache.hc.core5.http;MessageHeaders;true;getHeaders;();;Argument[-1];ReturnValue;taint",
        "org.apache.hc.core5.http;MessageHeaders;true;getHeaders;(String);;Argument[-1];ReturnValue;taint",
        "org.apache.hc.core5.http;MessageHeaders;true;headerIterator;();;Argument[-1];ReturnValue;taint",
        "org.apache.hc.core5.http;MessageHeaders;true;headerIterator;(String);;Argument[-1];ReturnValue;taint",
        "org.apache.hc.core5.http;HttpRequest;true;getAuthority;();;Argument[-1];ReturnValue;taint",
        "org.apache.hc.core5.http;HttpRequest;true;getMethod;();;Argument[-1];ReturnValue;taint",
        "org.apache.hc.core5.http;HttpRequest;true;getPath;();;Argument[-1];ReturnValue;taint",
        "org.apache.hc.core5.http;HttpRequest;true;getUri;();;Argument[-1];ReturnValue;taint",
        "org.apache.hc.core5.http;HttpRequest;true;getRequestUri;();;Argument[-1];ReturnValue;taint",
        "org.apache.hc.core5.http;HttpEntityContainer;true;getEntity;();;Argument[-1];ReturnValue;taint",
        "org.apache.hc.core5.http;NameValuePair;true;getName;();;Argument[-1];ReturnValue;taint",
        "org.apache.hc.core5.http;NameValuePair;true;getValue;();;Argument[-1];ReturnValue;taint",
        "org.apache.hc.core5.http;HttpEntity;true;getContent;();;Argument[-1];ReturnValue;taint",
        "org.apache.hc.core5.http;HttpEntity;true;getTrailers;();;Argument[-1];ReturnValue;taint",
        "org.apache.hc.core5.http;EntityDetails;true;getContentType;();;Argument[-1];ReturnValue;taint",
        "org.apache.hc.core5.http;EntityDetails;true;getContentEncoding;();;Argument[-1];ReturnValue;taint",
        "org.apache.hc.core5.http;EntityDetails;true;getTrailerNames;();;Argument[-1];ReturnValue;taint",
        "org.apache.hc.core5.http.message;RequestLine;true;getMethod;();;Argument[-1];ReturnValue;taint",
        "org.apache.hc.core5.http.message;RequestLine;true;getUri;();;Argument[-1];ReturnValue;taint",
        "org.apache.hc.core5.http.message;RequestLine;true;toString;();;Argument[-1];ReturnValue;taint",
        "org.apache.hc.core5.http.message;RequestLine;true;RequestLine;(HttpRequest);;Argument[0];Argument[-1];taint",
        "org.apache.hc.core5.http.message;RequestLine;true;RequestLine;(String,String,ProtocolVersion);;Argument[1];Argument[-1];taint",
        "org.apache.hc.core5.function;Supplier;true;get;();;Argument[-1];ReturnValue;taint",
        "org.apache.hc.core5.net;URIAuthority;true;getHostName;();;Argument[-1];ReturnValue;taint",
        "org.apache.hc.core5.net;URIAuthority;true;toString;();;Argument[-1];ReturnValue;taint",
        "org.apache.http.util;EntityUtils;true;toString;;;Argument[0];ReturnValue;taint",
        "org.apache.http.util;EntityUtils;true;toByteArray;(HttpEntity);;Argument[0];ReturnValue;taint",
        "org.apache.http.util;EntityUtils;true;getContentCharSet;(HttpEntity);;Argument[0];ReturnValue;taint",
        "org.apache.http.util;EntityUtils;true;getContentMimeType;(HttpEntity);;Argument[0];ReturnValue;taint",
        "org.apache.hc.core5.http.io.entity;EntityUtils;true;toString;;;Argument[0];ReturnValue;taint",
        "org.apache.hc.core5.http.io.entity;EntityUtils;true;toByteArray;;;Argument[0];ReturnValue;taint",
        "org.apache.hc.core5.http.io.entity;EntityUtils;true;parse;;;Argument[0];ReturnValue;taint",
        "org.apache.http.util;EncodingUtils;true;getAsciiBytes;(String);;Argument[0];ReturnValue;taint",
        "org.apache.http.util;EncodingUtils;true;getAsciiString;;;Argument[0];ReturnValue;taint",
        "org.apache.http.util;EncodingUtils;true;getBytes;(String,String);;Argument[0];ReturnValue;taint",
        "org.apache.http.util;EncodingUtils;true;getString;;;Argument[0];ReturnValue;taint",
        "org.apache.http.util;Args;true;containsNoBlanks;(CharSequence,String);;Argument[0];ReturnValue;value",
        "org.apache.http.util;Args;true;notNull;(Object,String);;Argument[0];ReturnValue;value",
        "org.apache.http.util;Args;true;notEmpty;(CharSequence,String);;Argument[0];ReturnValue;value",
        "org.apache.http.util;Args;true;notEmpty;(Collection,String);;Argument[0];ReturnValue;value",
        "org.apache.http.util;Args;true;notBlank;(CharSequence,String);;Argument[0];ReturnValue;value",
        "org.apache.hc.core5.util;Args;true;containsNoBlanks;(CharSequence,String);;Argument[0];ReturnValue;value",
        "org.apache.hc.core5.util;Args;true;notNull;(Object,String);;Argument[0];ReturnValue;value",
        "org.apache.hc.core5.util;Args;true;notEmpty;(Collection,String);;Argument[0];ReturnValue;value",
        "org.apache.hc.core5.util;Args;true;notEmpty;(CharSequence,String);;Argument[0];ReturnValue;value",
        "org.apache.hc.core5.util;Args;true;notEmpty;(Object,String);;Argument[0];ReturnValue;value",
        "org.apache.hc.core5.util;Args;true;notBlank;(CharSequence,String);;Argument[0];ReturnValue;value",
        "org.apache.hc.core5.http.io.entity;HttpEntities;true;create;;;Argument[0];ReturnValue;taint",
        "org.apache.hc.core5.http.io.entity;HttpEntities;true;createGzipped;;;Argument[0];ReturnValue;taint",
        "org.apache.hc.core5.http.io.entity;HttpEntities;true;createUrlEncoded;;;Argument[0];ReturnValue;taint",
        "org.apache.hc.core5.http.io.entity;HttpEntities;true;gzip;(HttpEntity);;Argument[0];ReturnValue;taint",
        "org.apache.hc.core5.http.io.entity;HttpEntities;true;withTrailers;;;Argument[0];ReturnValue;taint",
        "org.apache.http.entity;BasicHttpEntity;true;setContent;(InputStream);;Argument[0];Argument[-1];taint",
        "org.apache.http.entity;BufferedHttpEntity;true;BufferedHttpEntity;(HttpEntity);;Argument[0];ReturnValue;taint",
        "org.apache.http.entity;ByteArrayEntity;true;ByteArrayEntity;;;Argument[0];Argument[-1];taint",
        "org.apache.http.entity;HttpEntityWrapper;true;HttpEntityWrapper;(HttpEntity);;Argument[0];ReturnValue;taint",
        "org.apache.http.entity;InputStreamEntity;true;InputStreamEntity;;;Argument[0];ReturnValue;taint",
        "org.apache.http.entity;StringEntity;true;StringEntity;;;Argument[0];Argument[-1];taint",
        "org.apache.hc.core5.http.io.entity;BasicHttpEntity;true;BasicHttpEntity;;;Argument[0];ReturnValue;taint",
        "org.apache.hc.core5.http.io.entity;BufferedHttpEntity;true;BufferedHttpEntity;(HttpEntity);;Argument[0];ReturnValue;taint",
        "org.apache.hc.core5.http.io.entity;ByteArrayEntity;true;ByteArrayEntity;;;Argument[0];Argument[-1];taint",
        "org.apache.hc.core5.http.io.entity;HttpEntityWrapper;true;HttpEntityWrapper;(HttpEntity);;Argument[0];ReturnValue;taint",
        "org.apache.hc.core5.http.io.entity;InputStreamEntity;true;InputStreamEntity;;;Argument[0];ReturnValue;taint",
        "org.apache.hc.core5.http.io.entity;StringEntity;true;StringEntity;;;Argument[0];Argument[-1];taint",
        "org.apache.http.util;ByteArrayBuffer;true;append;(byte[],int,int);;Argument[0];Argument[-1];taint",
        "org.apache.http.util;ByteArrayBuffer;true;append;(char[],int,int);;Argument[0];Argument[-1];taint",
        "org.apache.http.util;ByteArrayBuffer;true;append;(CharArrayBuffer,int,int);;Argument[0];Argument[-1];taint",
        "org.apache.http.util;ByteArrayBuffer;true;buffer;();;Argument[-1];ReturnValue;taint",
        "org.apache.http.util;ByteArrayBuffer;true;toByteArray;();;Argument[-1];ReturnValue;taint",
        "org.apache.http.util;CharArrayBuffer;true;append;(byte[],int,int);;Argument[0];Argument[-1];taint",
        "org.apache.http.util;CharArrayBuffer;true;append;(char[],int,int);;Argument[0];Argument[-1];taint",
        "org.apache.http.util;CharArrayBuffer;true;append;(CharArrayBuffer,int,int);;Argument[0];Argument[-1];taint",
        "org.apache.http.util;CharArrayBuffer;true;append;(ByteArrayBuffer,int,int);;Argument[0];Argument[-1];taint",
        "org.apache.http.util;CharArrayBuffer;true;append;(CharArrayBuffer);;Argument[0];Argument[-1];taint",
        "org.apache.http.util;CharArrayBuffer;true;append;(String);;Argument[0];Argument[-1];taint",
        "org.apache.http.util;CharArrayBuffer;true;append;(Object);;Argument[0];Argument[-1];taint",
        "org.apache.http.util;CharArrayBuffer;true;buffer;();;Argument[-1];ReturnValue;taint",
        "org.apache.http.util;CharArrayBuffer;true;toCharArray;();;Argument[-1];ReturnValue;taint",
        "org.apache.http.util;CharArrayBuffer;true;toString;();;Argument[-1];ReturnValue;taint",
        "org.apache.http.util;CharArrayBuffer;true;substring;(int,int);;Argument[-1];ReturnValue;taint",
        "org.apache.http.util;CharArrayBuffer;true;subSequence;(int,int);;Argument[-1];ReturnValue;taint",
        "org.apache.http.util;CharArrayBuffer;true;substringTrimmed;(int,int);;Argument[-1];ReturnValue;taint",
        "org.apache.hc.core5.util;ByteArrayBuffer;true;append;(byte[],int,int);;Argument[0];Argument[-1];taint",
        "org.apache.hc.core5.util;ByteArrayBuffer;true;append;(char[],int,int);;Argument[0];Argument[-1];taint",
        "org.apache.hc.core5.util;ByteArrayBuffer;true;append;(CharArrayBuffer,int,int);;Argument[0];Argument[-1];taint",
        "org.apache.hc.core5.util;ByteArrayBuffer;true;array;();;Argument[-1];ReturnValue;taint",
        "org.apache.hc.core5.util;ByteArrayBuffer;true;toByteArray;();;Argument[-1];ReturnValue;taint",
        "org.apache.hc.core5.util;CharArrayBuffer;true;append;(byte[],int,int);;Argument[0];Argument[-1];taint",
        "org.apache.hc.core5.util;CharArrayBuffer;true;append;(char[],int,int);;Argument[0];Argument[-1];taint",
        "org.apache.hc.core5.util;CharArrayBuffer;true;append;(CharArrayBuffer,int,int);;Argument[0];Argument[-1];taint",
        "org.apache.hc.core5.util;CharArrayBuffer;true;append;(ByteArrayBuffer,int,int);;Argument[0];Argument[-1];taint",
        "org.apache.hc.core5.util;CharArrayBuffer;true;append;(CharArrayBuffer);;Argument[0];Argument[-1];taint",
        "org.apache.hc.core5.util;CharArrayBuffer;true;append;(String);;Argument[0];Argument[-1];taint",
        "org.apache.hc.core5.util;CharArrayBuffer;true;append;(Object);;Argument[0];Argument[-1];taint",
        "org.apache.hc.core5.util;CharArrayBuffer;true;array;();;Argument[-1];ReturnValue;taint",
        "org.apache.hc.core5.util;CharArrayBuffer;true;toCharArray;();;Argument[-1];ReturnValue;taint",
        "org.apache.hc.core5.util;CharArrayBuffer;true;toString;();;Argument[-1];ReturnValue;taint",
        "org.apache.hc.core5.util;CharArrayBuffer;true;substring;(int,int);;Argument[-1];ReturnValue;taint",
        "org.apache.hc.core5.util;CharArrayBuffer;true;subSequence;(int,int);;Argument[-1];ReturnValue;taint",
        "org.apache.hc.core5.util;CharArrayBuffer;true;substringTrimmed;(int,int);;Argument[-1];ReturnValue;taint",
        "org.apache.http.message;BasicRequestLine;false;BasicRequestLine;;;Argument[1];Argument[-1];taint",
        "org.apache.http;RequestLine;true;getUri;;;Argument[-1];ReturnValue;taint",
        "org.apache.http;RequestLine;true;toString;;;Argument[-1];ReturnValue;taint"
      ]
  }
}
